# GitHub Pagesでスライドを公開する方法

このドキュメントでは、Quartoで作成したreveal.jsスライドをGitHub Pagesで公開する手順を説明します。

## 前提条件

- GitHubアカウントを持っていること
- このリポジトリをGitHubにプッシュできること

## 手順

### 1. GitHubリポジトリの準備

まだリポジトリを作成していない場合：

```bash
# リポジトリを初期化（まだの場合）
git init

# ファイルを追加
git add .

# 初回コミット
git commit -m "Initial commit"

# GitHubでリポジトリを作成後、リモートを追加
git remote add origin https://github.com/あなたのユーザー名/リポジトリ名.git

# mainブランチにプッシュ
git branch -M main
git push -u origin main
```

### 2. GitHub Pagesの設定

1. GitHubリポジトリのページにアクセス
2. **Settings** → **Pages** を開く
3. **Source** で **GitHub Actions** を選択
4. 設定を保存

### 3. ファイルの確認

以下のファイルが正しく設定されていることを確認してください：

- `_quarto.yml`: `output-dir: docs` が設定されている
- `.github/workflows/publish.yml`: GitHub Actionsのワークフローファイルが存在する

### 4. スライドの更新と公開

1. `slides.qmd` を編集
2. 変更をコミットしてプッシュ：

```bash
git add slides.qmd
git commit -m "Update slides"
git push
```

3. GitHub Actionsが自動的にビルドとデプロイを実行します
4. 数分後、以下のURLでスライドにアクセスできます：
   ```
   https://あなたのユーザー名.github.io/リポジトリ名/slides.html
   ```

## トラブルシューティング

### GitHub Actionsが失敗する場合

- **Actions** タブでエラーログを確認
- Quartoのバージョンや依存関係の問題がないか確認

### スライドが表示されない場合

- GitHub Pagesの設定で **GitHub Actions** が選択されているか確認
- ビルドが完了しているか（緑色のチェックマーク）確認
- URLが正しいか確認（`/リポジトリ名/slides.html`）

### ローカルで確認したい場合

```bash
# スライドをレンダリング
quarto render slides.qmd

# ローカルサーバーで確認（オプション）
quarto preview slides.qmd
```

## 注意事項

- `renv/` ディレクトリは通常Gitに含めません（`.gitignore`に追加推奨）
- `slides_files/` は自動生成されるため、Gitに含める必要はありません
- 個人アカウントの場合、リポジトリは公開（Public）でも非公開（Private）でもGitHub Pagesを使用できます

