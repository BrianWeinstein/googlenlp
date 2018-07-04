
#' annotate_text
#'
#' Send a request, and retrieve the \code{sentences}, \code{tokens}, \code{entities}, \code{documentSentiment}, and \code{language} responses.
#' This function calls the \href{https://cloud.google.com/natural-language/reference/rest/v1/documents/annotateText}{annotateText} method, which performs the \href{https://cloud.google.com/natural-language/reference/rest/v1/documents/analyzeSyntax}{analyzeSyntax}, \href{https://cloud.google.com/natural-language/reference/rest/v1/documents/analyzeEntities}{analyzeEntities}, and \href{https://cloud.google.com/natural-language/reference/rest/v1/documents/analyzeSentiment}{analyzeSentiment} methods all within one API call.
#'
#' @param text_body The text string to send to the API.
#' @param flatten If \code{TRUE} (default), then the results of each method are flattened and converted to a data frame.
#'
#' @examples
#' \dontrun{
#' sample_annotate <- annotate_text(text_body = "Google, headquartered in Mountain View, unveiled
#'                                        the new Android phone at the Consumer Electronic Show.
#'                                        Sundar Pichai said in his keynote that users love
#'                                        their new Android phones.",
#'                                  flatten = TRUE)
#' sample_annotate$sentences
#' sample_annotate$tokens
#' sample_annotate$entities
#' sample_annotate$documentSentiment
#' sample_annotate$language
#' }
#'
#' @return
#' A list containing five elements: \code{sentences}, \code{tokens}, \code{entities}, \code{documentSentiment}, and \code{language}.
#'
#' If \code{flatten} is \code{TRUE}, then the \code{sentences}, \code{tokens}, \code{entities}, and \code{documentSentiment} elements are each converted to data frames.
#'
#' @export
annotate_text <- function(text_body, flatten = TRUE) {

  resp <- gcnlp_post(text_body = text_body,
                     extract_syntax = TRUE,
                     extract_entities = TRUE,
                     extract_document_sentiment = TRUE)
  content <- resp$content

  if (flatten == TRUE) {
    list(
      sentences = flatten_sentences(content$sentences),
      tokens = flatten_tokens(content$tokens),
      entities = flatten_entities(content$entities),
      documentSentiment = flatten_sentiment(content$documentSentiment),
      language = content$language
    )
  } else {
    list(
      sentences = content$sentences,
      tokens = content$tokens,
      entities = content$entities,
      documentSentiment = content$documentSentiment,
      language = content$language
    )
  }

}


#' analyze_syntax
#'
#' Send a request, and retrieve the \code{sentences}, \code{tokens}, and \code{language} responses.
#' This function retrieves the results from the \href{https://cloud.google.com/natural-language/reference/rest/v1/documents/analyzeSyntax}{analyzeSyntax} method.
#'
#' @inheritParams annotate_text
#'
#' @examples
#' \dontrun{
#' sample_syntax <- analyze_syntax(text_body = "Google, headquartered in Mountain View, unveiled
#'                                        the new Android phone at the Consumer Electronic Show.
#'                                        Sundar Pichai said in his keynote that users love
#'                                        their new Android phones.",
#'                                 flatten = TRUE)
#' sample_syntax$sentences
#' sample_syntax$tokens
#' sample_syntax$language
#' }
#'
#' @return
#' A list containing three elements: \code{sentences}, \code{tokens}, and \code{language}.
#'
#' If \code{flatten} is \code{TRUE}, then the \code{sentences} and \code{tokens} elements are each converted to data frames.
#'
#' @export
analyze_syntax <- function(text_body, flatten = TRUE) {

  resp <- gcnlp_post(text_body = text_body,
                     extract_syntax = TRUE,
                     extract_entities = FALSE,
                     extract_document_sentiment = FALSE)
  content <- resp$content

  if (flatten == TRUE) {
    list(
      sentences = flatten_sentences(content$sentences),
      tokens = flatten_tokens(content$tokens),
      language = content$language
    )
  } else {
    list(
      sentences = content$sentences,
      tokens = content$tokens,
      language = content$language
    )
  }

}


#' analyze_entities
#'
#' Send a request, and retrieve the \code{entities} and \code{language} responses.
#' This function retrieves the results from the \href{https://cloud.google.com/natural-language/reference/rest/v1/documents/analyzeEntities}{analyzeEntities} method.
#'
#' @inheritParams annotate_text
#'
#' @examples
#' \dontrun{
#' sample_entities <- analyze_entities(text_body = "Google, headquartered in Mountain View, unveiled
#'                                        the new Android phone at the Consumer Electronic Show.
#'                                        Sundar Pichai said in his keynote that users love
#'                                        their new Android phones.",
#'                                     flatten = TRUE)
#' sample_entities$entities
#' sample_entities$language
#' }
#'
#' @return
#' A list containing two elements: \code{entities} and \code{language}.
#'
#' If \code{flatten} is \code{TRUE}, then the \code{entities} element is converted to a data frame.
#'
#' @export
analyze_entities <- function(text_body, flatten = TRUE) {

  resp <- gcnlp_post(text_body = text_body,
                     extract_syntax = FALSE,
                     extract_entities = TRUE,
                     extract_document_sentiment = FALSE)
  content <- resp$content

  if (flatten == TRUE) {
    list(
      entities = flatten_entities(content$entities),
      language = content$language
    )
  } else {
    list(
      entities = content$entities,
      language = content$language
    )
  }

}


#' analyze_sentiment
#'
#' Send a request, and retrieve the \code{documentSentiment} and \code{language} responses.
#' This function retrieves the results from the \href{https://cloud.google.com/natural-language/reference/rest/v1/documents/analyzeSentiment}{analyzeSentiment} method.
#'
#' @inheritParams annotate_text
#'
#' @examples
#' \dontrun{
#' sample_sentiment <- analyze_sentiment(text_body = "Google, headquartered in Mountain View, unveiled
#'                                        the new Android phone at the Consumer Electronic Show.
#'                                        Sundar Pichai said in his keynote that users love
#'                                        their new Android phones.",
#'                                       flatten = TRUE)
#' sample_sentiment$documentSentiment
#' sample_sentiment$language
#' }
#'
#' @return
#' A list containing two elements: \code{documentSentiment} and \code{language}.
#'
#' If \code{flatten} is \code{TRUE}, then the \code{documentSentiment} element is converted to a data frame.
#'
#' @export
analyze_sentiment <- function(text_body, flatten = TRUE) {

  resp <- gcnlp_post(text_body = text_body,
                     extract_syntax = FALSE,
                     extract_entities = FALSE,
                     extract_document_sentiment = TRUE)
  content <- resp$content

  if (flatten == TRUE) {
    list(
      documentSentiment = flatten_sentiment(content$documentSentiment),
      sentences = flatten_sentences(content$sentences),
      language = content$language
    )
  } else {
    list(
      documentSentiment = content$documentSentiment,
      sentences = content$sentences,
      language = content$language
    )
  }

}

