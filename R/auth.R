
#' @importFrom readr write_file
#' @importFrom utils file.edit
NULL




# Set default values for googlenlp configuration
gcnlp_env <- new.env(parent = emptyenv())
gcnlp_env$config_file <- "~/.Renviron"




#' Fetch session-specific gcnlp default values
#'
#' \code{get_config_file()} gets the value of \code{config_file}
#'
#' @return
#' The path to the user's \code{config_file}
#'
#' @examples
#' \dontrun{
#' get_config_file()
#' }
#'
#' @export
get_config_file <- function() {

  config_file <- gcnlp_env$config_file

  return(config_file)

}



#' Configure your computer or a server to connect to the Google Cloud Natural Language API via R functions
#'
#' Creates variables in your .Renviron file for use by other googlenlp functions.
#' This will edit your .Renviron file only if you call this function directly. If you prefer not to change your .Renviron file, use the \code{set_api_key} function instead.
#'
#' @return None
#'
#' @examples
#' \dontrun{
#' configure_googlenlp()
#' }
#'
#' @export
configure_googlenlp <- function(){

  config_file <- get_config_file()

  # define string to add to config_file file
  string <- "\n\n# Google Cloud API credentials, for use by googlenlp
    GOOGLE_NLP_API_KEY = ENTER_YOUR_API_KEY_HERE"

  # append the string to config_file
  readr::write_file(x = string, path = config_file, append = TRUE)

  # print helper instructions to console
  cat("googlenlp setup instructions:\n",
      "1. Your", config_file, "file will now open in a new window/tab.\n",
      paste0("   *** If it doesn't open, run:  file.edit(\"", config_file, "\") ***\n"),
      "2. To use the API, you'll first need to create a Google Cloud project and enable billing (https://cloud.google.com/natural-language/docs/getting-started).\n",
      "3. Next you'll need to get an API key (https://cloud.google.com/natural-language/docs/common/auth).\n",
      "4. In your ", config_file, " file, replace the ENTER_YOUR_API_KEY_HERE with your Google Cloud API key.\n",
      "5. Save your", config_file, "file.\n",
      "6. *** Restart your R session for changes to take effect. ***")

  # open the config_file file
  file.edit(config_file)

}




#' Manually set access credentials
#'
#' Manually define an API key. Only use this function if you haven't run \code{configure_googlenlp()}
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

  gcnlp_env$GOOGLE_NLP_API_KEY_MANUAL <- api_key

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
#' @export
gcnlp_key <- function() {

  config_file <- get_config_file()

  # Check if the API key has been set from your config_file file
  key_renviron <- Sys.getenv("GOOGLE_NLP_API_KEY")
  key_renviron_exists <- (!identical(key_renviron, "") & !is.null(key_renviron))

  # Check if the key has been manually set
  key_manual <- gcnlp_env$GOOGLE_NLP_API_KEY_MANUAL
  key_manual_exists <- (!identical(key_manual, "") & !is.null(key_manual))

  if (key_renviron_exists & key_manual_exists) {

    # If they key has been set in multiple places, warn the user and default to the one set in the config_file
    warning(paste0("API key has been set in multiple places.\n",
                   "You've defined it in both your ", config_file, " file (via the configure_googlenlp() function) and manually (via the set_api_key('YOUR_API_KEY') function.\n",
                   "Defaulting to the value stored in your ", config_file, " file."))

    key <- key_renviron

  } else if (key_renviron_exists) {

    # If the key has been set only in the config_file, use that one
    key <- key_renviron

  } else if (key_manual_exists) {

    # If the key has been set only via the set_api_key function, use that one
    key <- key_manual

  } else {

    # If the key hasn't been defined, stop
    stop("API key is not defined. Define it either by running configure_googlenlp() or with set_api_key('YOUR_API_KEY')",
         call. = FALSE)
  }

  return(key)

}
