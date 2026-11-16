#!/usr/bin/env bash
# Keeps every open pull request of PR_AUTHOR level with its base branch.
#
# A clean merge of the base branch is pushed as is. A merge with conflicts, or
# checks that fail on the pull request, go to a coding agent. Its result is
# pushed only if it passes the checks in verify_result. Nothing is force
# pushed and nothing is posted on GitHub.
set -uo pipefail

: "${PR_AUTHOR:?}" "${PR_SYNC_TOKEN:?}" "${GIT_NAME:?}" "${GIT_EMAIL:?}"
DRY_RUN=${DRY_RUN:-false}
# PR_FILTER limits the run to pull request URLs that match this regex.
AGENT_TIMEOUT=${AGENT_TIMEOUT:-45m}
ROOT=$(pwd)
WORK=${RUNNER_TEMP:-/tmp}/pr-sync-work
STATE=$ROOT/state/attempted.txt
PROBLEMS=$ROOT/problems.md
SUMMARY=${GITHUB_STEP_SUMMARY:-/dev/null}

mkdir -p "$WORK" "$(dirname "$STATE")"
touch "$STATE"
: > "$PROBLEMS"

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global advice.detachedHead false

report() {
  echo "$*"
  echo "$*" >> "$SUMMARY"
}

problem() {
  report "$*"
  echo "$*" >> "$PROBLEMS"
}

# run_agent gives the agent one task in the clone. The agent reads GitHub with
# the workflow token, which cannot push to the forks or write to other repos.
run_agent() {
  local dir=$1 task=$2
  if [ -z "${OPENCODE_MODEL:-}" ]; then
    echo "OPENCODE_MODEL is not set"
    return 1
  fi
  local prompt
  # shellcheck disable=SC2016 # envsubst takes the variable names literally.
  prompt=$(TASK=$task envsubst '${PR_URL} ${BASE_REF} ${HEAD_REF} ${TASK}' < "$ROOT/prompt.md")
  (
    cd "$dir" || exit 1
    # The push token is removed from the agent's environment.
    env -u PR_SYNC_TOKEN GH_TOKEN="${AGENT_GH_TOKEN:-}" timeout "$AGENT_TIMEOUT" \
      opencode run --pure --auto --model "$OPENCODE_MODEL" "$prompt"
  )
}

# verify_result checks what the agent left: a finished merge, no uncommitted
# changes, no conflict markers, and only signed commits by GIT_NAME.
verify_result() {
  local start=$1 commit message
  if git rev-parse -q --verify MERGE_HEAD > /dev/null; then
    echo "the merge is still in progress"
    return 1
  fi
  if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
    echo "uncommitted changes are left"
    return 1
  fi
  if git diff "$start" HEAD | grep -qE '^\+(<<<<<<<|>>>>>>>)( |$)|^\+=======$'; then
    echo "conflict markers are left"
    return 1
  fi
  # Commits that arrive with the base branch belong to other authors.
  for commit in $(git rev-list HEAD "^$start" "^upstream/$BASE_REF"); do
    message=$(git log -1 --format=%B "$commit")
    if ! grep -qF "Signed-off-by: $GIT_NAME <$GIT_EMAIL>" <<< "$message"; then
      echo "commit $commit is not signed off"
      return 1
    fi
    if grep -qiE 'co-authored-by|generated (with|by)' <<< "$message"; then
      echo "commit $commit has a tool trailer"
      return 1
    fi
    if [ "$(git log -1 --format='%an <%ae>' "$commit")" != "$GIT_NAME <$GIT_EMAIL>" ]; then
      echo "commit $commit has another author"
      return 1
    fi
  done
}

sync_pr() {
  local url=$1 info number head_owner head_repo head_sha base_slug key dir
  local action changed=false behind conflicts failing start reason
  info=$(gh pr view "$url" --json number,headRepositoryOwner,headRepository,headRefName,headRefOid,baseRefName) || {
    problem "- $url: could not read the pull request"
    return
  }
  number=$(jq -r .number <<< "$info")
  head_owner=$(jq -r .headRepositoryOwner.login <<< "$info")
  head_repo=$(jq -r .headRepository.name <<< "$info")
  head_sha=$(jq -r .headRefOid <<< "$info")
  export PR_URL=$url
  HEAD_REF=$(jq -r .headRefName <<< "$info")
  BASE_REF=$(jq -r .baseRefName <<< "$info")
  export HEAD_REF BASE_REF
  base_slug=$(sed -E 's#^https://github.com/([^/]+/[^/]+)/pull/[0-9]+$#\1#' <<< "$url")
  key="$base_slug#$number"

  if [ "$head_owner" != "$PR_AUTHOR" ]; then
    report "- $key: skipped, the head branch is in $head_owner/$head_repo"
    return
  fi

  dir="$WORK/${base_slug//\//_}_$number"
  rm -rf "$dir"
  # The token is passed per command and never stored in the clone, so the
  # agent working in it cannot push.
  local auth filter=()
  auth="http.https://github.com/.extraheader=AUTHORIZATION: basic $(printf 'x-access-token:%s' "$PR_SYNC_TOKEN" | base64 | tr -d '\n')"
  if [ "$(gh api "repos/$head_owner/$head_repo" --jq .private 2> /dev/null)" = false ]; then
    filter=(--filter=blob:none)
  fi
  if ! git -c "$auth" clone -q --no-tags ${filter[@]+"${filter[@]}"} --branch "$HEAD_REF" \
    "https://github.com/$head_owner/$head_repo.git" "$dir"; then
    problem "- $key: could not clone $head_owner/$head_repo"
    return
  fi
  cd "$dir" || return
  git remote add upstream "https://github.com/$base_slug.git"
  if ! git fetch -q --no-tags --filter=blob:none upstream "$BASE_REF"; then
    problem "- $key: could not fetch $base_slug $BASE_REF"
    return
  fi

  if git merge-base --is-ancestor "upstream/$BASE_REF" HEAD; then
    action="level with $BASE_REF"
  else
    behind=$(git rev-list --count "HEAD..upstream/$BASE_REF")
    if [ "$DRY_RUN" = true ]; then
      if git merge -q --no-ff --no-commit "upstream/$BASE_REF" > /dev/null 2>&1; then
        action="would merge $behind commits"
      else
        action="would resolve conflicts, $behind commits behind"
      fi
      git merge --abort 2> /dev/null || true
    elif git merge -q --no-ff --signoff -m "Merge branch '$BASE_REF' into $HEAD_REF" "upstream/$BASE_REF"; then
      action="merged $behind commits"
      changed=true
    else
      conflicts=$(git diff --name-only --diff-filter=U | tr '\n' ' ')
      task="A merge of upstream/$BASE_REF into this branch is in progress and has conflicts in: $conflicts
Resolve every conflict. Read what the pull request changes (gh pr diff $url) and what the base branch changed in each conflicting file (git log -p HEAD..upstream/$BASE_REF -- <file>). Keep the base branch's new code and apply the pull request's change on top of it. Then build and run the tests for the code the pull request touches, fix anything the merge broke, and finish the merge with git commit -s --no-edit."
      if run_agent "$dir" "$task" && reason=$(verify_result "$head_sha"); then
        action="resolved conflicts in $conflicts"
        changed=true
      else
        git merge --abort 2> /dev/null || true
        git reset -q --hard "$head_sha"
        problem "- $key: could not resolve conflicts in $conflicts ${reason:-}"
        return
      fi
    fi
  fi

  # Update: checks that fail on the current head may come from the base branch
  # moving. Each head commit gets one attempt, recorded in the state file.
  failing=$(gh pr checks "$url" --json name,bucket --jq '[.[] | select(.bucket == "fail") | .name] | join(", ")' 2> /dev/null || true)
  if [ -n "$failing" ] && ! grep -qxF "$key@$head_sha" "$STATE"; then
    if [ "$DRY_RUN" = true ]; then
      action="$action; would look at failing checks: $failing"
    else
      start=$(git rev-parse HEAD)
      task="These checks fail on the pull request: $failing
Find out why with gh pr checks $url and gh run view <run id> --log-failed -R $base_slug. If a failure comes from the pull request's code, or from the base branch having moved (a renamed API, generated files out of date, a new lint rule, a broken test), fix it with the smallest change, run the related build and tests, and commit. If a failure is unrelated to the code (a flaky test, infrastructure, missing secrets, a workflow waiting for approval), change nothing."
      if run_agent "$dir" "$task" && reason=$(verify_result "$start"); then
        if [ "$(git rev-parse HEAD)" != "$start" ]; then
          action="$action; fixed failing checks: $failing"
          changed=true
        else
          action="$action; failing checks need no change: $failing"
        fi
      else
        git reset -q --hard "$start"
        problem "- $key: could not handle failing checks ($failing) ${reason:-}"
      fi
      echo "$key@$head_sha" >> "$STATE"
    fi
  fi

  if [ "$changed" != true ]; then
    report "- $key: $action"
    return
  fi
  if ! git -c "$auth" push -q origin "HEAD:$HEAD_REF"; then
    problem "- $key: push was rejected after: $action"
    return
  fi
  report "- $key: $action, pushed $(git rev-parse --short HEAD)"
}

report "## Pull requests of $PR_AUTHOR (dry run: $DRY_RUN)"
urls=$(gh search prs --author "$PR_AUTHOR" --state open --limit 200 --json url --jq '.[].url' | sort | grep -E "${PR_FILTER:-.}") || {
  problem "- could not list the pull requests"
  exit 1
}
for url in $urls; do
  (sync_pr "$url")
done
