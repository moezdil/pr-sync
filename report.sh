#!/usr/bin/env bash
# Writes a status report of the open pull requests of PR_AUTHOR to
# reports/<date>.md and STATUS.md. It only reads from GitHub.
set -euo pipefail

: "${PR_AUTHOR:?}"
TODAY=$(TZ=Europe/Berlin date +%F)
NOW=$(date -u +%s)
IDLE_DAYS=${IDLE_DAYS:-14}

days_since() {
  local since
  since=$(date -u -d "$1" +%s)
  echo $(( (NOW - since) / 86400 ))
}

# cell escapes text for a Markdown table cell.
cell() {
  local text=${1//|/\\|}
  echo "${text//$'\n'/ }"
}

rows=""
attention=""
count=0
urls=$(gh search prs --author "$PR_AUTHOR" --state open --limit 200 --json url --jq '.[].url' | sort)
for url in $urls; do
  slug=$(sed -E 's#^https://github.com/([^/]+/[^/]+)/pull/[0-9]+$#\1#' <<< "$url")
  number=${url##*/}
  info=$(gh pr view "$url" --json title,createdAt,updatedAt,isDraft,mergeable,reviewDecision,statusCheckRollup,headRefName,baseRefName,headRepositoryOwner)
  title=$(jq -r .title <<< "$info")
  [ "$(jq -r .isDraft <<< "$info")" = true ] && title="$title (draft)"
  open_days=$(days_since "$(jq -r .createdAt <<< "$info")")
  idle_days=$(days_since "$(jq -r .updatedAt <<< "$info")")
  base=$(jq -r .baseRefName <<< "$info")
  head="$(jq -r .headRepositoryOwner.login <<< "$info"):$(jq -r .headRefName <<< "$info")"
  behind=$(gh api "repos/$slug/compare/$base...$head" --jq .behind_by 2> /dev/null || echo "?")
  case "$(jq -r .mergeable <<< "$info")" in
    CONFLICTING) conflicts=yes ;;
    MERGEABLE) conflicts=no ;;
    *) conflicts="?" ;;
  esac
  ci=$(jq -r '
    [.statusCheckRollup[] | (.conclusion // .state // "")] as $s
    | ($s | map(select(. == "FAILURE" or . == "ERROR" or . == "TIMED_OUT" or . == "CANCELLED" or . == "ACTION_REQUIRED")) | length) as $fail
    | ($s | map(select(. == "SUCCESS" or . == "NEUTRAL" or . == "SKIPPED")) | length) as $ok
    | (($s | length) - $fail - $ok) as $pending
    | if ($s | length) == 0 then "none"
      elif $fail > 0 then "failing (\($fail))"
      elif $pending > 0 then "pending (\($pending))"
      else "passing (\($ok))" end' <<< "$info")
  case "$(jq -r '.reviewDecision // ""' <<< "$info")" in
    APPROVED) review=approved ;;
    CHANGES_REQUESTED) review="changes requested" ;;
    REVIEW_REQUIRED) review="review required" ;;
    *) review="-" ;;
  esac

  reasons=""
  [ "$conflicts" = yes ] && reasons="$reasons, conflicts"
  [[ $ci == failing* ]] && reasons="$reasons, CI $ci"
  [ "$review" = "changes requested" ] && reasons="$reasons, changes requested"
  [ "$idle_days" -ge "$IDLE_DAYS" ] && reasons="$reasons, no activity for $idle_days days"
  link="[$slug#$number]($url)"
  if [ -n "$reasons" ]; then
    attention="$attention- $link $(cell "$title"): ${reasons#, }"$'\n'
  fi
  rows="$rows| $link | $(cell "$title") | ${open_days}d | $behind | $conflicts | $ci | $review | ${idle_days}d ago |"$'\n'
  count=$((count + 1))
done

mkdir -p reports
{
  echo "# Open pull requests, $TODAY"
  echo
  echo "$count open pull requests by @$PR_AUTHOR. Written every day by the daily-report workflow."
  echo
  echo "## Needs attention"
  echo
  if [ -n "$attention" ]; then
    printf '%s' "$attention"
  else
    echo "Nothing needs attention."
  fi
  echo
  echo "## All"
  echo
  echo "| Pull request | Title | Open | Behind | Conflicts | CI | Review | Last activity |"
  echo "|---|---|---|---|---|---|---|---|"
  printf '%s' "$rows"
} > "reports/$TODAY.md"
cp "reports/$TODAY.md" STATUS.md
echo "Wrote reports/$TODAY.md with $count pull requests"
