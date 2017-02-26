
context("API methods")

test_that("Methods return the expected responses and response sizes", {

  set_api_key(api_key = api_key)

  expect_identical(object = capture.output(str(annotate_text(text_body = sample_1, flatten = FALSE), max.level = 1)),
                   expected = c("List of 5",
                                " $ sentences        :List of 2",
                                " $ tokens           :List of 32",
                                " $ entities         :List of 9",
                                " $ documentSentiment:List of 2",
                                " $ language         : chr \"en\""))

  expect_identical(object = capture.output(str(analyze_syntax(text_body = sample_1, flatten = FALSE), max.level = 1)),
                   expected = c("List of 3",
                                " $ sentences:List of 2",
                                " $ tokens   :List of 32",
                                " $ language : chr \"en\""))

  expect_identical(object = capture.output(str(analyze_entities(text_body = sample_1, flatten = FALSE), max.level = 1)),
                   expected = c("List of 2",
                                " $ entities:List of 9",
                                " $ language: chr \"en\""))

  expect_identical(object = capture.output(str(analyze_sentiment(text_body = sample_1, flatten = FALSE), max.level = 1)),
                   expected = c("List of 3",
                                " $ documentSentiment:List of 2",
                                " $ sentences        :List of 2",
                                " $ language         : chr \"en\""))

})
