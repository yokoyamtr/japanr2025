# install
install.packages("remotes")
remotes::install_github("LACDR/rspacer")
install.packages("usethis")
install.packages("tibble")

# usethis を使って環境変数を設定します
usethis::edit_r_environ()
library(rspacer)
library(tibble)



# load
library(rspacer)

rspacer::set_api_url()

api_status()

(file_name <- system.file("Template_example.html", package = "rspacer"))

(matching_code_file <- fs::path_ext_set(file_name, ".qmd"))

stopifnot(file.exists(file_name))
stopifnot(file.exists(matching_code_file))

folder_tree()
folder_tree("FL180")

df_to_upload <- data.frame(
  name = c("Title", "Date", "Main part", "Conclusion"),
  content = c("example title", "23-12-2024", "This is example text.",
              "ready for uploading.")
)

document_create_from_tabular(
  df = df_to_upload,
  template_id = "SD397"
)

document_create_from_html(
  path = file_name,
  template_id = "SD397",
  folder_id = "FL416",
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
