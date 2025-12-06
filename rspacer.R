# install
install.packages("remotes")
remotes::install_github("LACDR/rspacer")
install.packages("usethis")
install.packages("tibble")

# usethis を使って環境変数を設定します
usethis::edit_r_environ()
library(rspacer)




# load
library(rspacer)


rspacer::set_api_url("http://rspace.gmo-rast.co.jp/api/v1")
api_status()
HyWDGMUY20LMTU31MpWs5Vx70cugPJtU

(file_name <- system.file("Template_example.html", package = "rspacer"))

(matching_code_file <- fs::path_ext_set(file_name, ".qmd"))

stopifnot(file.exists(file_name))
stopifnot(file.exists(matching_code_file))

folder_tree()
# folder_tree(180)
# TemplatesフォルダのIDを指定しても何故か機能しない

df_to_upload <- data.frame(
  name = c("Title", "Date", "Main part", "Conclusion"),
  content = c("example title", "23-12-2024", "This is example text.",
              "ready for uploading.")
)
document_create_from_tabular(
  df = df_to_upload,
#  template_id = "SD367"
)

document_create_from_html(
  path = file_name,
  template_id = "SD397",
  folder_id = "FL332",
  tags = c("tutorial"),
  attachments = tibble(field = 3, path = matching_code_file),
  existing_document_id = NULL
)


remotes::install_github("LACDR/LACDR.ISA")


doc_df_to_upload <- tibble::tribble(
  ~name, ~content,
  "Example field", "Example content"
)
document_create_from_tabular(df = doc_df_to_upload, document_name = "Example document")
