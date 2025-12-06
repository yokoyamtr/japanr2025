# rspacer パッケージの使い方

このドキュメントでは、rspacer パッケージを使用して RSpace に構造化ドキュメントを作成する方法について説明します。

## 目次

1. [開始前に](#開始前に)
2. [HTMLファイルからドキュメントを作成する](#htmlファイルからドキュメントを作成する)
3. [テーブルファイルからドキュメントを作成する](#テーブルファイルからドキュメントを作成する)

---

## 開始前に

このチュートリアルを開始する前に、以下の準備が必要です。

- rspacer パッケージのインストール
- API URL と API キーの設定
- `vignette("rspacer")` を読んで、アップロード機能を使用する準備ができていることを確認

### 必要なライブラリの読み込み

```r
library(tidyverse)
library(rspacer)
```

### API の利用可能性を確認

API が利用可能かどうかを確認します。API ステータスは OK である必要があります。

```r
(res <- api_status())
stopifnot(res$message == "OK")
```

---

## HTMLファイルからドキュメントを作成する

### 概要

このチュートリアルでは、Quarto ファイルから `document_create_from_html()` を使用して RSpace 構造化ドキュメントを作成する方法を説明します。

### RSpace でテンプレートを作成

RSpace で、4つのテキストフィールド（"Title"、"Date"、"Main part"、"Conclusion"）を持つフォームからテンプレートを作成します。後で必要になるため、構造化ドキュメントの一意の識別子を書き留めておいてください。

テンプレートの設計方法については、[RSpace のドキュメント](https://documentation.researchspace.com/article/wxfk9gf0a0-templates)を参照してください。

### サンプルドキュメントの作成

1. rspacer パッケージにはサンプルファイルが含まれています。RStudio で、ファイル > 新規ファイル > R Markdown に移動します。現時点（2025-02-06）では、Quarto ファイルをテンプレートから作成するオプションはまだないため、R Markdown テンプレートとしてファイルを提供しています。

2. 左側で「From Template」をクリックします。

3. rspacer テンプレートの例を選択します。ファイルを Quarto ファイル（`.qmd`）として保存します。

4. ファイルを HTML レポートにレンダリングします。

または、新しい Quarto ドキュメントを作成することもできます。以前に作成した RSpace テンプレートと同じヘッダーを含め、これらのヘッダーがすべて2つのハッシュタグ（h2 ヘッダー、`##`）を持つようにします。h2 ヘッダーが構造化ドキュメントテンプレートと同一である限り、任意のコードを記述したり、h3 や h4 ヘッダー（3つまたは4つのハッシュタグ）を使用したりできます。

### アップロードするファイル名の指定

rspacer は、アップロードするファイルを知る必要があります。このチュートリアルでは、以前に作成した `Template_example.html` ファイルから構造化ドキュメントを作成し、`.qmd` ファイルを添付ファイルとしてアップロードします。

R プロジェクト内から相対パスで作業することをお勧めします（[`here` パッケージ](https://here.r-lib.org/)を使用して指定できます）。これが望ましくない場合は、絶対ファイルパスを指定する必要があります。

以下のコードは、HTML ファイルと QMD ファイルが同じファイル名を持つことを前提としています。そうでない場合は、`file_name` と `matching_code_file` の両方の変数を変更してください。

```r
(file_name <- system.file("Template_example.html", package = "rspacer"))
(matching_code_file <- fs::path_ext_set(file_name, ".qmd"))
stopifnot(file.exists(file_name))
stopifnot(file.exists(matching_code_file))
```

### ファイルのアップロード

ドキュメントと添付ファイルを API インボックスにアップロードするには、以下のコードチャンクで十分です。

```r
document_create_from_html(
    path = file_name,
    template_id = template_id
)
```

ただし、`document_create_from_html()` には、特定のフォルダにファイルをアップロードしたり、既存のドキュメントを置き換えたりする場合など、より多くのパラメータがあります（詳細については、上記の関数をクリックしてください）。

### パラメータ値の見つけ方

`folder_tree()` を使用して RSpace フォルダを閲覧し、`id` または `globalID` を使用します。フォルダ識別子は `FL` で始まり、ノートブック識別子は `NB` で始まり、構造化ドキュメント識別子は `SD` で始まります。例：

```r
folder_tree()
folder_tree("FL7833")
```

もちろん、RSpace インスタンスの Web インターフェースに移動してこれらを見つけることもできます。

ドキュメントにタグを付けることもできます。`tags` ベクトルを使用して、たとえば "finished"、"in progress"、"failed" などのステータスを指定します。

最後に、添付ファイルをアップロードできます。これらは、フィールド番号とそのフィールドに添付する必要があるファイルのパスを含むリストのリストを使用して指定する必要があります。

以下に、ソース `.qmd` ファイルもアップロードする例を示します。

```r
document_create_from_html(
  path = file_name,
  template_id = "SD377682",
  folder_id = "FL242398",
  tags = c("tutorial"),
  attachments = tibble(field = 3, path = matching_code_file),
  existing_document_id = NULL
)
```

---

## テーブルファイルからドキュメントを作成する

### 概要

このチュートリアルでは、Excel、TSV、CSV などの区切りファイル形式から RSpace 構造化ドキュメントを作成する方法を説明します。

### RSpace でテンプレートを作成

RSpace で、4つのテキストフィールド（"Title"、"Date"、"Main part"、"Conclusion"）を持つフォームからテンプレートを作成します。後で必要になるため、構造化ドキュメントの一意の識別子を書き留めておいてください。この例では、識別子は `SD377682` でした。

テンプレートの設計方法については、[RSpace のドキュメント](https://documentation.researchspace.com/article/wxfk9gf0a0-templates)を参照してください。

### サンプルドキュメントの作成

Excel を開いて CSV ファイルを作成するか、以下のコードチャンクを実行して小さなサンプルファイルを作成します。2つの列が必要です。最初の列には、テンプレートとまったく同じすべてのフィールドが含まれている必要があります。2番目の列には、各フィールドの内容が正しい形式で含まれている必要があります。

Excel を使用する場合は、日付が dd-mm-yyyy 形式の文字列として保存されていることを確認してください。

```r
df_to_upload <- data.frame(
    name = c("Title", "Date", "Main part", "Conclusion"),
    content = c("example title", "23-12-2024", "This is example text.",
                "ready for uploading.")
  )
```

### データのアップロード

データを API インボックスにアップロードするには、以下のコードチャンクで十分で、作成されたドキュメントを返します。これは `Template_example.csv` からドキュメントを作成します。この関数は CSV、TSV、XLSX ファイル形式で動作します。

テンプレート ID が、以前に RSpace で作成したテンプレートの識別子であることを確認してください。

```r
document_create_from_tabular(
    df = df_to_upload,
    template_id = "SD377682"
)
```

`document_create_from_tabular()` 関数には、たとえば、ドキュメントを指定されたノートブックまたはフォルダにアップロードするなど、より多くのパラメータがあります（詳細については、上記の関数をクリックしてください）。

### パラメータ値の見つけ方

`folder_tree()` を使用して RSpace フォルダを閲覧し、`id` または `globalID` を使用します。フォルダ識別子は `FL` で始まり、ノートブック識別子は `NB` で始まり、構造化ドキュメント識別子は `SD` で始まります。例：

```r
folder_tree()
folder_tree("FL409926")
```

もちろん、RSpace インスタンスの Web インターフェースに移動してこれらを見つけることもできます。

`tags` ベクトルを使用してドキュメントにタグを付けることもできます。たとえば、"finished"、"in progress"、"failed" などのステータスを指定できます。

フィールドに添付ファイルをアップロードする場合は、`attachments` 引数を使用します。ファイルは、フィールド番号に応じて添付ファイルとして追加されます。

既存のドキュメントを置き換える場合は、`existing_file_id` を指定できます。これは、ファイルを作成するのではなく置き換える必要がある場合にのみ使用してください。

以下の例では、フィールド番号 4 に Quarto コードファイルと HTML ファイル `Template_example.html` を添付ファイルとして追加します。また、ファイルを特定のフォルダに配置し、"tutorial" タグを追加します。

```r
attachment_file <- system.file("Template_example.html", package = "rspacer")
(matching_code_file <- fs::path_ext_set(attachment_file, ".qmd"))

document_create_from_tabular(
  df = df_to_upload,
  template_id = "SD377682",
  tags = c("tutorial"),
  attachments = tibble(field = c(4, 4), path = c(attachment_file, matching_code_file))
)
```

### ファイルから直接アップロード

`document_create_from_tabfile()` 関数を使用して、ファイルから表形式データを直接アップロードすることもできます。以前のサンプルデータを使用した小さな例：

```r
file_name <- "Template_example.csv"
df_to_upload |>
  write_csv(file_name, col_names = FALSE) # CSV には列名を含めない

# アップロード
document_create_from_tabfile(
    path = file_name,
    template_id = "SD377682"
)
```

---

## まとめ

rspacer パッケージを使用すると、以下の方法で RSpace に構造化ドキュメントを作成できます。

1. **HTML ファイルから作成** - `document_create_from_html()` を使用して、Quarto や R Markdown から生成された HTML ファイルからドキュメントを作成

2. **テーブルデータから作成** - `document_create_from_tabular()` または `document_create_from_tabfile()` を使用して、CSV、TSV、Excel ファイルからドキュメントを作成

どちらの方法でも、フォルダの指定、タグの追加、添付ファイルの追加などの追加オプションを使用できます。


