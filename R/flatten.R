
#' @importFrom purrr map_df flatten_df
#' @importFrom dplyr select mutate %>%
NULL


#' Flatten sentences
#'
#' Convert the JSON/list \code{sentences} response into a flattened data frame.
#' 
#' @param sentences_list The \code{sentences} component of the API response.
#' 
#' @examples
#' sample_post <- gcnlp_post(api_key = gcnlp_key(),
#'                           text_body = "Google, headquartered in Mountain View, unveiled the new Android phone at the Consumer Electronic Show.
#'                                        Sundar Pichai said in his keynote that users love their new Android phones.",
#'                           extract_syntax = TRUE,
#'                           extract_entities = TRUE,
#'                           extract_document_sentiment = TRUE)
#' 
#' flatten_sentences(sentences_list = sample_post$content$sentences)
#' 
#' @return
#' A flattened data frame.
#' 
#' @export
flatten_sentences <- function(sentences_list){
  
  map_df(sentences_list, flatten_df) %>%
    select(content, beginOffset, magnitude, score)
  
}


#' Flatten tokens
#'
#' Convert the JSON/list \code{tokens} response into a flattened data frame.
#' 
#' @param tokens_list The \code{tokens} component of the API response.
#' 
#' @examples
#' sample_post <- gcnlp_post(api_key = gcnlp_key(),
#'                           text_body = "Google, headquartered in Mountain View, unveiled the new Android phone at the Consumer Electronic Show.
#'                                        Sundar Pichai said in his keynote that users love their new Android phones.",
#'                           extract_syntax = TRUE,
#'                           extract_entities = TRUE,
#'                           extract_document_sentiment = TRUE)
#' 
#' flatten_tokens(tokens_list = sample_post$content$tokens)
#' 
#' @return
#' A flattened data frame.
#' 
#' @export
flatten_tokens <- function(tokens_list){
  
  map_df(tokens_list, flatten_df) %>%
    select(content, beginOffset, lemma,
           tag, aspect, case, form, gender, mood, number,
           person, proper, reciprocity, tense, voice,
           dependencyEdge_headTokenIndex=headTokenIndex,
           dependencyEdge_label=label)
  
}


#' Flatten entities
#'
#' Convert the JSON/list \code{entities} response into a flattened data frame.
#' 
#' @param entities_list The \code{entities} component of the API response.
#' 
#' @examples
#' sample_post <- gcnlp_post(api_key = gcnlp_key(),
#'                           text_body = "Google, headquartered in Mountain View, unveiled the new Android phone at the Consumer Electronic Show.
#'                                        Sundar Pichai said in his keynote that users love their new Android phones.",
#'                           extract_syntax = TRUE,
#'                           extract_entities = TRUE,
#'                           extract_document_sentiment = TRUE)
#' 
#' flatten_entities(entities_list = sample_post$content$entities)
#' 
#' @return
#' A flattened data frame.
#' 
#' @export
flatten_entities <- function(entities_list){
  
  map_df(entities_list,
         function(element){
           
           # extract 1:1 fields
           df1 <- flatten_df(element[c("name", "type", "metadata", "salience")]) %>%
             mutate(mid = as.character(ifelse("mid" %in% colnames(.), mid, NA)),
                    wikipedia_url = as.character(ifelse("wikipedia_url" %in% colnames(.), wikipedia_url, NA)))
           df1 <- df1 %>%
             select(name, entity_type=type, mid, wikipedia_url, salience)
           
           # extract 1:many fields
           df2 <- map_df(element$mentions,
                         function(inner_element){
                           
                           c(as.list(inner_element$text),
                             mentions_type=inner_element$type)
                           
                         }
           )
           df2 <- df2 %>%
             select(content, beginOffset, mentions_type)
           
           # combine into one dataframe
           df2 %>%
             mutate(name = df1$name,
                    entity_type = df1$entity_type,
                    mid = df1$mid,
                    wikipedia_url = df1$wikipedia_url,
                    salience = df1$salience) %>%
             select(name, entity_type, mid, wikipedia_url, salience, content, beginOffset, mentions_type)
           
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
#' sample_post <- gcnlp_post(api_key = gcnlp_key(),
#'                           text_body = "Google, headquartered in Mountain View, unveiled the new Android phone at the Consumer Electronic Show.
#'                                        Sundar Pichai said in his keynote that users love their new Android phones.",
#'                           extract_syntax = TRUE,
#'                           extract_entities = TRUE,
#'                           extract_document_sentiment = TRUE)
#' 
#' flatten_sentiment(sentiment_list = sample_post$content$sentiment)
#' 
#' @return
#' A flattened data frame.
#' 
#' @export
flatten_sentiment <- function(sentiment_list){
  
  as.data.frame(sentiment_list) %>%
    select(magnitude, score)
  
}

