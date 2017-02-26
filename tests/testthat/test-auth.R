
context("Authorization")

test_that("API key can be set", {

  set_api_key(api_key = api_key)
  expect_identical(gcnlp_env$GCNLP_API_KEY, api_key)

})

test_that("API key can be retrieved", {

  expect_identical(gcnlp_key(), api_key)

})
