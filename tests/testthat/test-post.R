
context("POST to API")

test_that("User can send a POST request to the API", {

  post_response <- gcnlp_post(text_body = sample_1,
                              extract_syntax = TRUE,
                              extract_entities = TRUE,
                              extract_document_sentiment = TRUE)

  expect_identical(object = names(post_response),
                   expected = c("content", "raw_response"))

  expect_identical(object = names(post_response$content),
                   expected = c("sentences", "tokens", "entities", "documentSentiment", "language"))

  expect_identical(object = names(post_response$raw_response),
                   expected = c("url", "status_code", "headers", "all_headers", "cookies",
                                "content", "date", "times", "request", "handle"))

})
