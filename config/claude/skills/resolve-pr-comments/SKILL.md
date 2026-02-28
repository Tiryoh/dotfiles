# resolve-pr-comments

PRのレビューコメントを確認し、コード修正 → commit → push → 返信を行う。

## Steps

1. **PR情報を取得**:
   ```bash
   gh pr view --json number,url,headRefName
   ```

2. **レビューコメントを取得**（owner/repoはURLから抽出）:
   ```bash
   gh api /repos/{owner}/{repo}/pulls/{number}/comments
   ```

3. **コメントを分析**:
   - `in_reply_to_id` があるものはスレッド返信としてグループ化
   - 各スレッドの最新の返信者を確認し、**自分のアカウント（PRのauthor）が既に返信済みのスレッドはスキップ**
   - 残ったコメントについて、該当コードを読み妥当性を評価

4. **ユーザーに判断を仰ぐ**:
   - 未対応のコメントごとに、コメント内容・該当コード・妥当性評価を提示
   - AskUserQuestion で対応方針（修正する / 対応しない / 他）をユーザーに確認
   - ユーザーの指示に従って対応

5. **各コメントへの対応**:

   **修正する場合:**
   - コードを修正
   - プロジェクトのlint・テストコマンドで検証（CLAUDE.mdやMakefile等を参照して適切なコマンドを判断）
   - commit & push
   - 返信フォーマット:
     ```
     {commit_hash} にて修正

     - 変更点1
     - 変更点2
     ```

   **対応しない場合（意図的な設計、誤解、対象外など）:**
   - 返信で理由を簡潔に説明

6. **返信APIの呼び方**:
   ```bash
   gh api /repos/{owner}/{repo}/pulls/{number}/comments -X POST \
     -F body="..." \
     -F in_reply_to={parent_comment_id}
   ```

## Rules

- 返信は簡潔に。「ありがとうございます」等の社交辞令は不要（Bot相手の場合が多い）
- 修正コミットは変更ごとにまとめて1つでよい（コメント単位で分けない）
- commit後は必ず push する
- lint・テストが通らない場合はユーザーに相談する
- 全コメント処理後、対応サマリーを表示する

## Output

処理完了後、以下のサマリーを表示:

```
## 対応サマリー

- [修正] @author `file.go`#L42: 修正内容の要約 (commit_hash)
- [スキップ] @author `file.go`#L10: 既に返信済み
- [対応不要] @author `file.go`#L55: 理由
```
