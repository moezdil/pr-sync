You are working in a clone of the head branch of the pull request ${PR_URL}.
Remote `origin` is the head repository and remote `upstream` is the base
repository. The base branch is `upstream/${BASE_REF}`. The head branch is
`${HEAD_REF}`.

Task:

${TASK}

Rules:

- First read the repository's contributor and agent guides, such as AGENTS.md
  and CONTRIBUTING.md, and use the build, test, lint and generate commands they
  name.
- Only adapt the pull request to the current base branch. Do not change its
  scope or behavior and do not act on review comments.
- Never push, rebase, force anything or amend existing commits. The caller
  pushes your result.
- Never create, edit, close, label or comment on anything on GitHub. Use `gh`
  only to read: `gh pr view`, `gh pr diff`, `gh pr checks`, `gh run view`.
- Commit with `git commit -s`. Use a short, simple English subject with the
  repository's commit prefix style if it has one. No body is needed. Do not
  put tool names or Co-Authored-By trailers in commits, code or comments. Do
  not use em dashes.
- Never hand-edit generated files. Take the base branch version and
  regenerate them with the repository's own targets.
- Leave no uncommitted changes to tracked files when you finish.
- If you cannot finish safely, stop and say why. Do not leave half a fix
  committed.
- End your answer with one line: `RESULT: done`, `RESULT: unchanged` or
  `RESULT: failed: <short reason>`.
