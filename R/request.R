
#' @importFrom httr POST user_agent accept_json http_type content http_error status_code
NULL

#' Send a POST request to the Google Cloud Natural Language API and retrieve the results
#' 
#' TODO: Description
#'
#' @param api_key Your API key, from \url{https://console.cloud.google.com/apis/credentials}. Either enter the API key directly, or access it via \code{gcnlp_key()}.
#' @param text_body The text string to send to the API.
#' @param extract_syntax Behavior for the analyzeSyntax method. Defaults to \code{TRUE}. See \href{https://cloud.google.com/natural-language/reference/rest/v1/documents/analyzeSyntax}{the API documentation} for more information.
#' @param extract_entities Behavior for the analyzeEntities method. Defaults to \code{TRUE}. See \href{https://cloud.google.com/natural-language/reference/rest/v1/documents/analyzeEntities}{the API documentation} for more information.
#' @param extract_document_sentiment Behavior for the analyzeSentiment method. Defaults to \code{TRUE}. See \href{https://cloud.google.com/natural-language/reference/rest/v1/documents/analyzeSentiment}{the API documentation} for more information.
#'
#' @examples
#' gcnlp_post(api_key = gcnlp_key(),
#'            text_body = "Google, headquartered in Mountain View, unveiled the new Android phone at the Consumer Electronic Show.
#'                        Sundar Pichai said in his keynote that users love their new Android phones.",
#'            extract_syntax = TRUE,
#'            extract_entities = TRUE,
#'            extract_document_sentiment = TRUE)
#' @return
#' TODO: RETURN VALUE
#'
#' @export
gcnlp_post <- function(api_key = gcnlp_key(),
                       text_body,
                       extract_syntax = TRUE,
                       extract_entities = TRUE,
                       extract_document_sentiment = TRUE) {
  
  url <- paste0("https://language.googleapis.com/v1/documents:annotateText/?key=", api_key)
  
  response <- POST(url = url,
                   config = c(user_agent("http://github.com/brianweinstein/googlenlp"),
                              accept_json()),
                   body = list(document=list(type="PLAIN_TEXT",
                                             content=text_body),
                               features=list(extractSyntax=extract_syntax,
                                             extractEntities=extract_entities,
                                             extractDocumentSentiment=extract_document_sentiment),
                               encodingType="UTF8"),
                   encode = "json")
  
  # check if API returned JSON
  if (http_type(response) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }
  
  # parse the response
  parsed <- jsonlite::fromJSON(content(response, "text"), simplifyVector = FALSE)
  
  # check the status
  if (http_error(response)) {
    stop(
      paste0(
        "Google Cloud Natural Language API request failed ", "[", status_code(response), "]\n", 
        parsed$error$message, "\n",
        parsed$error$details[[1]]$links[[1]]$url
      ),
      call. = FALSE
    )
  }
  
  structure(
    list(
      content = parsed,
      response = response
    ),
    class = "google_natural_language_api"
  )
  
  
}

