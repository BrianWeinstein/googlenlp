
gcnlp_env <- new.env(parent = emptyenv())


#' Set access credentials
#'
#' Define an API key
#'
#' @param api_key Your API key, from \url{https://console.cloud.google.com/apis/credentials}
#'
#' @examples
#' \dontrun{
#' set_api_key("YOUR_API_KEY")
#' }
#'
#' @return
#' None
#'
#' @export
set_api_key <- function(api_key) {

  gcnlp_env$GCNLP_API_KEY <- api_key

}




#' Retrieve API key
#'
#' Retrieve API key
#'
#' @examples
#' \dontrun{
#' gcnlp_key()
#' }
#'
#' @return
#' Your API key
#'
gcnlp_key <- function() {

  key <- gcnlp_env$GCNLP_API_KEY

  if (identical(key, "") | is.null(key)) {
    stop("Please define your API key with set_api_key('YOUR_API_KEY')",
         call. = FALSE)
  }

  key

}
