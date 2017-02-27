
<!-- README.md is generated from README.Rmd. Please edit that file -->

------------------------------------------------------------------------

googlenlp
---------

The googlenlp package provides an R interface to Google's [Cloud Natural Language API](https://cloud.google.com/natural-language/).

### Installation

You can install the development version from GitHub:

``` r
devtools::install_github("BrianWeinstein/googlenlp")
```

### Authentication

To use the API, you'll first need to [create a Google Cloud project and enable billing](https://cloud.google.com/natural-language/docs/getting-started), and get an [API key](https://cloud.google.com/natural-language/docs/common/auth).

### Getting started

Load the package and set your API key.

``` r
library(googlenlp)

set_api_key("MY_API_KEY")
```

Define the text you'd like to analyze.

``` r
my_text <- "Google, headquartered in Mountain View, unveiled the
            new Android phone at the Consumer Electronic Show.
            Sundar Pichai said in his keynote that users love
            their new Android phones."
```

The `annotate_text` function analyzes the text's syntax (sentences and tokens), entities, sentiment, and language.

``` r
annotate_text(text_body = my_text)
#> $sentences
#> Source: local data frame [2 x 4]
#> Groups: <by row>
#> 
#> # A tibble: 2 × 4
#>                                                                        content
#>                                                                          <chr>
#> 1 Google, headquartered in Mountain View, unveiled the\n            new Androi
#> 2 Sundar Pichai said in his keynote that users love\n            their new And
#> # ... with 3 more variables: beginOffset <int>, magnitude <dbl>,
#> #   score <dbl>
#> 
#> $tokens
#> # A tibble: 32 × 17
#>          content beginOffset       lemma   tag         aspect         case
#>            <chr>       <int>       <chr> <chr>          <chr>        <chr>
#> 1         Google           0      Google  NOUN ASPECT_UNKNOWN CASE_UNKNOWN
#> 2              ,           6           , PUNCT ASPECT_UNKNOWN CASE_UNKNOWN
#> 3  headquartered           8 headquarter  VERB ASPECT_UNKNOWN CASE_UNKNOWN
#> 4             in          22          in   ADP ASPECT_UNKNOWN CASE_UNKNOWN
#> 5       Mountain          25    Mountain  NOUN ASPECT_UNKNOWN CASE_UNKNOWN
#> 6           View          34        View  NOUN ASPECT_UNKNOWN CASE_UNKNOWN
#> 7              ,          38           , PUNCT ASPECT_UNKNOWN CASE_UNKNOWN
#> 8       unveiled          40      unveil  VERB ASPECT_UNKNOWN CASE_UNKNOWN
#> 9            the          49         the   DET ASPECT_UNKNOWN CASE_UNKNOWN
#> 10           new          65         new   ADJ ASPECT_UNKNOWN CASE_UNKNOWN
#> # ... with 22 more rows, and 11 more variables: form <chr>, gender <chr>,
#> #   mood <chr>, number <chr>, person <chr>, proper <chr>,
#> #   reciprocity <chr>, tense <chr>, voice <chr>,
#> #   dependencyEdge_headTokenIndex <int>, dependencyEdge_label <chr>
#> 
#> $entities
#> # A tibble: 10 × 8
#>                        name   entity_type        mid
#>                       <chr>         <chr>      <chr>
#> 1                    Google  ORGANIZATION  /m/045c7b
#> 2                     phone CONSUMER_GOOD       <NA>
#> 3                   Android CONSUMER_GOOD /m/02wxtgw
#> 4                   Android CONSUMER_GOOD /m/02wxtgw
#> 5                     users        PERSON       <NA>
#> 6             Sundar Pichai        PERSON /m/09gds74
#> 7             Mountain View      LOCATION   /m/0r6c4
#> 8  Consumer Electronic Show         EVENT  /m/01p15w
#> 9                    phones CONSUMER_GOOD       <NA>
#> 10                  keynote         OTHER       <NA>
#> # ... with 5 more variables: wikipedia_url <chr>, salience <dbl>,
#> #   content <chr>, beginOffset <int>, mentions_type <chr>
#> 
#> $documentSentiment
#>   magnitude score
#> 1       0.9   0.4
#> 
#> $language
#> [1] "en"
```
