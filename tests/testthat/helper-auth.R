
path <- "/tests/testthat/api_key.txt"
has_auth <- file.exists(path)

if (has_auth) {
  api_key <- readLines(path)
  set_api_key(api_key)
}
