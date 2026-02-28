---
description: "Fetch and display comments from the current GitHub pull request"
user-invocable: true
---

# pr-comments

Fetch and display comments from the current branch's GitHub pull request.

## Steps

1. Get PR info:
   ```bash
   gh pr view --json number,url,headRefName
   ```

2. Extract owner/repo from the URL (e.g. `https://github.com/OWNER/REPO/pull/N`).

3. Fetch PR-level comments and review comments in parallel:
   ```bash
   gh api /repos/{owner}/{repo}/issues/{number}/comments
   gh api /repos/{owner}/{repo}/pulls/{number}/comments
   ```

4. Parse the JSON responses. IMPORTANT: Do NOT rely on jq `-r` with string interpolation for fields that may contain newlines or special characters (like `body` or `diff_hunk`). Instead, use `jq` to extract fields individually or process the JSON directly in your response.

   For review comments, the key fields are:
   - `user.login` - comment author
   - `path` - file path
   - `line` or `original_line` - line number
   - `diff_hunk` - code context
   - `body` - comment text
   - `in_reply_to_id` - if present, this is a reply to another comment

5. Format and display ALL comments. Use this format:

```
## Comments

- @author `file.ts`#line:
  ```diff
  [diff_hunk]
  ```
  > comment body (preserve markdown)

  - @reply_author (reply):
    > reply body
```

For PR-level comments (from issues/{number}/comments):
```
- @author (PR comment):
  > comment body
```

## Rules

- Show ALL comments, do not summarize or omit any
- Preserve the full body text including markdown formatting
- Group replies under their parent comment using `in_reply_to_id`
- If there are no comments at all, output "No comments found."
- Do NOT add any explanatory text beyond the formatted comments
