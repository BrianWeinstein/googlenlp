
#' @importFrom purrr map_df flatten_df
#' @importFrom dplyr select mutate %>%
NULL

#' Flatten methods
#'
#' Flatten each nested JSON/list API response into a data frame
#' 
#' @param param1 param1 description
#' 
#' @examples
#' example
#' 
#' @return
#' return
#' 
#' @name flatten
NULL


#' @rdname flatten
#' @export
flatten_sentences <- function(sentences_list){
  
  map_df(sentences_list, flatten_df) %>%
    select(content, beginOffset, magnitude, score)
  
}


#' @rdname flatten
#' @export
flatten_tokens <- function(tokens_list){
  
  map_df(tokens_list, flatten_df) %>%
    select(content, beginOffset, lemma,
           tag, aspect, case, form, gender, mood, number,
           person, proper, reciprocity, tense, voice,
           dependencyEdge_headTokenIndex=headTokenIndex,
           dependencyEdge_label=label)
  
}


#' @rdname flatten
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


#' @rdname flatten
#' @export
flatten_sentiment <- function(sentiment_list){
  as.data.frame(sentiment_list) %>%
    select(magnitude, score)
}

