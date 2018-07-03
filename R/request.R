
#' @importFrom httr POST user_agent accept_json http_type content http_error status_code
#' @importFrom jsonlite fromJSON
NULL

#' Send a POST request to the Google Cloud Natural Language API
#'
#' Send a POST request to the Google Cloud Natural Language API and retrieve the results.
#'
#' @param text_body The text string to send to the API.
#' @param extract_syntax Behavior for the analyzeSyntax method. Defaults to \code{TRUE}. See \href{https://cloud.google.com/natural-language/reference/rest/v1/documents/analyzeSyntax}{the API documentation} for more information.
#' @param extract_entities Behavior for the analyzeEntities method. Defaults to \code{TRUE}. See \href{https://cloud.google.com/natural-language/reference/rest/v1/documents/analyzeEntities}{the API documentation} for more information.
#' @param extract_document_sentiment Behavior for the analyzeSentiment method. Defaults to \code{TRUE}. See \href{https://cloud.google.com/natural-language/reference/rest/v1/documents/analyzeSentiment}{the API documentation} for more information.
#'
#' @examples
#' \dontrun{
#' gcnlp_post(text_body = "Google, headquartered in Mountain View, unveiled
#'                                        the new Android phone at the Consumer Electronic Show.
#'                                        Sundar Pichai said in his keynote that users love
#'                                        their new Android phones.",
#'            extract_syntax = TRUE,
#'            extract_entities = TRUE,
#'            extract_document_sentiment = TRUE)
#' }
#'
#' @return
#' A list containing two elements: [1] \code{content} includes the parsed response, and contains the \code{sentences}, \code{tokens}, \code{entities}, \code{documentSentiment}, \code{language} results specified in the request. [2] \code{raw_response} contains the raw response from the API.
#'
#' @export
gcnlp_post <- function(text_body,
                       extract_syntax = TRUE,
                       extract_entities = TRUE,
                       extract_document_sentiment = TRUE) {

  url <- paste0("https://language.googleapis.com/v1/documents:annotateText/?key=", gcnlp_key())

  raw_response <- POST(url = url,
                       config = c(user_agent("http://github.com/brianweinstein/googlenlp"),
                                  accept_json()),
                       body = list(document = list(type = "PLAIN_TEXT",
                                                   content = text_body),
                                   features = list(extractSyntax = extract_syntax,
                                                   extractEntities = extract_entities,
                                                   extractDocumentSentiment = extract_document_sentiment),
                                   encodingType = "UTF8"),
                       encode = "json")

  # check if API returned JSON
  if (http_type(raw_response) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  # parse the raw_response
  parsed <- jsonlite::fromJSON(content(raw_response, "text"), simplifyVector = FALSE)

  # check the status
  if (http_error(raw_response)) {
    stop(
      paste0(
        "Google Cloud Natural Language API request failed ",
        "[", status_code(raw_response), "]\n",
        parsed$error$message, "\n",
        parsed$error$details[[1]]$links[[1]]$url
      ),
      call. = FALSE
    )
  }

  structure(
    list(
      content = parsed,
      raw_response = raw_response
    ),
    class = "google_natural_language_api"
  )

}
