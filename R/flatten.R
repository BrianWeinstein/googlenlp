
#' @importFrom purrr map_df flatten_df
#' @importFrom dplyr select mutate rowwise %>% ungroup
#' @importFrom rlang .data
NULL


#' Flatten sentences
#'
#' Convert the JSON/list \code{sentences} response into a flattened data frame.
#'
#' @param sentences_list The \code{sentences} component of the API response.
#'
#' @examples
#' \dontrun{
#' sample_post <- gcnlp_post(text_body = "Google, headquartered in Mountain View, unveiled
#'                                        the new Android phone at the Consumer Electronic Show.
#'                                        Sundar Pichai said in his keynote that users love
#'                                        their new Android phones.",
#'                           extract_syntax = TRUE,
#'                           extract_entities = TRUE,
#'                           extract_document_sentiment = TRUE)
#'
#' flatten_sentences(sentences_list = sample_post$content$sentences)
#' }
#'
#' @return
#' A flattened data frame.
#'
#' @export
flatten_sentences <- function(sentences_list){

  # check if any sentences exist
  if (length(sentences_list) == 0) {
    warning("API did not return any sentences. There is nothing to flatten.", call. = TRUE)
    return(NULL)
  }

  df1 <- map_df(sentences_list, flatten_df) %>%
    rowwise()

  # check if the dataframe contains the "magnitude" and "score" columns
  magnitude_in_df1 <- "magnitude" %in% colnames(df1)
  score_in_df1 <- "score" %in% colnames(df1)

  df1 <- df1 %>%
    mutate(magnitude = as.numeric(ifelse(magnitude_in_df1, .data$magnitude, NA)),
           score = as.numeric(ifelse(score_in_df1, .data$score, NA))) %>%
    select(.data$content, .data$beginOffset, .data$magnitude, .data$score) %>%
    ungroup()

}


#' Flatten tokens
#'
#' Convert the JSON/list \code{tokens} response into a flattened data frame.
#'
#' @param tokens_list The \code{tokens} component of the API response.
#'
#' @examples
#' \dontrun{
#' sample_post <- gcnlp_post(text_body = "Google, headquartered in Mountain View, unveiled
#'                                        the new Android phone at the Consumer Electronic Show.
#'                                        Sundar Pichai said in his keynote that users love
#'                                        their new Android phones.",
#'                           extract_syntax = TRUE,
#'                           extract_entities = TRUE,
#'                           extract_document_sentiment = TRUE)
#'
#' flatten_tokens(tokens_list = sample_post$content$tokens)
#' }
#'
#' @return
#' A flattened data frame.
#'
#' @export
flatten_tokens <- function(tokens_list){

  # check if any tokens exist
  if (length(tokens_list) == 0) {
    warning("API did not return any tokens. There is nothing to flatten.", call. = TRUE)
    return(NULL)
  }

  map_df(tokens_list, flatten_df) %>%
    select(.data$content, .data$beginOffset, .data$lemma,
           .data$tag, .data$aspect, .data$case, .data$form, .data$gender, .data$mood, .data$number,
           .data$person, .data$proper, .data$reciprocity, .data$tense, .data$voice,
           dependencyEdge_headTokenIndex = .data$headTokenIndex,
           dependencyEdge_label = .data$label) %>%
    ungroup()

}


#' Flatten entities
#'
#' Convert the JSON/list \code{entities} response into a flattened data frame.
#'
#' @param entities_list The \code{entities} component of the API response.
#'
#' @examples
#' \dontrun{
#' sample_post <- gcnlp_post(text_body = "Google, headquartered in Mountain View, unveiled
#'                                        the new Android phone at the Consumer Electronic Show.
#'                                        Sundar Pichai said in his keynote that users love
#'                                        their new Android phones.",
#'                           extract_syntax = TRUE,
#'                           extract_entities = TRUE,
#'                           extract_document_sentiment = TRUE)
#'
#' flatten_entities(entities_list = sample_post$content$entities)
#' }
#'
#' @return
#' A flattened data frame.
#'
#' @export
flatten_entities <- function(entities_list){

  # check if any entities exist
  if (length(entities_list) == 0) {
    warning("API did not return any entities. There is nothing to flatten.", call. = TRUE)
    return(NULL)
  }

  map_df(entities_list,
         function(element){

           ### extract 1:1 fields
           df1 <- flatten_df(element[c("name", "type", "metadata", "salience")])

           # check if the dataframe contains the "mid" and "wikipedia_url" columns
           mid_in_df1 <- "mid" %in% colnames(df1)
           wikipedia_url_in_df1 <- "wikipedia_url" %in% colnames(df1)

           # create "mid" and "wikipedia_url" columns; reorder columns
           df1 <- df1 %>%
             mutate(mid = as.character(ifelse(mid_in_df1, .data$mid, NA)),
                    wikipedia_url = as.character(ifelse(wikipedia_url_in_df1, .data$wikipedia_url, NA)))
           df1 <- df1 %>%
             select(.data$name, entity_type = .data$type, .data$mid, .data$wikipedia_url, .data$salience)

           ### extract 1:many fields
           df2 <- map_df(element$mentions,
                         function(inner_element){

                           c(as.list(inner_element$text),
                             mentions_type = inner_element$type)

                         }
           )
           df2 <- df2 %>%
             select(.data$content, .data$beginOffset, .data$mentions_type)

           # combine into one dataframe
           df2 %>%
             mutate(name = df1$name,
                    entity_type = df1$entity_type,
                    mid = df1$mid,
                    wikipedia_url = df1$wikipedia_url,
                    salience = df1$salience) %>%
             select(.data$name, .data$entity_type, .data$mid, .data$wikipedia_url, .data$salience,
                    .data$content, .data$beginOffset, .data$mentions_type) %>%
             ungroup()

         }
  )

}


#' Flatten sentiment
#'
#' Convert the JSON/list \code{sentiment} response into a flattened data frame.
#'
#' @param sentiment_list The \code{sentiment} component of the API response.
#'
#' @examples
#' \dontrun{
#' sample_post <- gcnlp_post(text_body = "Google, headquartered in Mountain View, unveiled
#'                                        the new Android phone at the Consumer Electronic Show.
#'                                        Sundar Pichai said in his keynote that users love
#'                                        their new Android phones.",
#'                           extract_syntax = TRUE,
#'                           extract_entities = TRUE,
#'                           extract_document_sentiment = TRUE)
#'
#' flatten_sentiment(sentiment_list = sample_post$content$sentiment)
#' }
#'
#' @return
#' A flattened data frame.
#'
#' @export
flatten_sentiment <- function(sentiment_list){

  # check if the document sentiment exists
  if (length(sentiment_list) == 0) {
    warning("API did not return the document sentiment. There is nothing to flatten.", call. = TRUE)
    return(NULL)
  }

  as.data.frame(sentiment_list) %>%
    select(.data$magnitude, .data$score) %>%
    ungroup()

}
