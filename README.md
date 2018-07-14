
<!-- README.md is generated from README.Rmd. Please edit that file -->
googlenlp
---------

[![Travis-CI Build Status](https://travis-ci.org/BrianWeinstein/googlenlp.svg?branch=master)](https://travis-ci.org/BrianWeinstein/googlenlp) <!-- [![CRAN version](http://www.r-pkg.org/badges/version/googlenlp)](https://cran.r-project.org/package=googlenlp) ![](http://cranlogs.r-pkg.org/badges/grand-total/googlenlp) -->

------------------------------------------------------------------------

The googlenlp package provides an R interface to Google's [Cloud Natural Language API](https://cloud.google.com/natural-language/).

"Google Cloud Natural Language API reveals the structure and meaning of text by offering powerful machine learning models in an easy to use REST API. You can use it to **extract information** about people, places, events and much more, mentioned in text documents, news articles or blog posts. You can use it to **understand sentiment** about your product on social media or **parse intent** from customer conversations happening in a call center or a messaging app." \[[source](https://cloud.google.com/natural-language/)\]

There are four main features of the API, all of which are available through this R package \[[source](https://cloud.google.com/natural-language/)\]:

-   **Syntax Analysis:** "Extract tokens and sentences, identify parts of speech (PoS) and create dependency parse trees for each sentence."
-   **Entity Analysis:** "Identify entities and label by types such as person, organization, location, events, products and media."
-   **Sentiment Analysis:** "Understand the overall sentiment expressed in a block of text."
-   **Multi-Language:** "Enables you to easily analyze text in multiple languages including English, Spanish and Japanese."

### Resources

-   [API Documentation](https://cloud.google.com/natural-language/docs/)
-   [Natural Language API Basics](https://cloud.google.com/natural-language/docs/basics)
-   [Morphology & Dependency Trees](https://cloud.google.com/natural-language/docs/morphology)

### Installation

You can install the development version from GitHub:

``` r
devtools::install_github("BrianWeinstein/googlenlp")
```

### Authentication

To use the API, you'll first need to [create a Google Cloud project and enable billing](https://cloud.google.com/natural-language/docs/getting-started), and get an [API key](https://cloud.google.com/natural-language/docs/common/auth).

### Configuration

Load the package and set your API key. There are two ways to do this.

#### Method A (preferred)

Method A (preferred method) adds your API key as a variable to your `.Renviron` file. Under this method, you only need to do this setup process one time.

``` r
library(googlenlp)

configure_googlenlp() # follow the instructions printed to the console
```

    googlenlp setup instructions:
     1. Your ~/.Renviron file will now open in a new window/tab.
        *** If it doesn't open, run:  file.edit("~/.Renviron") ***
     2. To use the API, you'll first need to create a Google Cloud project and enable billing (https://cloud.google.com/natural-language/docs/getting-started).
     3. Next you'll need to get an API key (https://cloud.google.com/natural-language/docs/common/auth).
     4. In your  ~/.Renviron  file, replace the ENTER_YOUR_API_KEY_HERE with your Google Cloud API key.
     5. Save your ~/.Renviron file.
     6. *** Restart your R session for changes to take effect. ***

#### Method B

Method B defines your API key as a session-level variable. Under this method, you'll need to set your API key at the beginning of each R session.

``` r
library(googlenlp)

set_api_key("MY_API_KEY") # replace this with your API key
```

### Getting started

Define the text you'd like to analyze.

``` r
text <- "Google, headquartered in Mountain View, unveiled the new Android phone at the Consumer Electronic Show.
         Sundar Pichai said in his keynote that users love their new Android phones."
```

The `annotate_text` function analyzes the text's syntax (sentences and tokens), entities, sentiment, and language; and returns the result as a five-element list.

``` r
analyzed <- annotate_text(text_body = text)
#> Warning: package 'bindrcpp' was built under R version 3.4.4

str(analyzed, max.level = 1)
#> List of 5
#>  $ sentences        :Classes 'tbl_df', 'tbl' and 'data.frame':   2 obs. of  4 variables:
#>  $ tokens           :Classes 'tbl_df', 'tbl' and 'data.frame':   32 obs. of  17 variables:
#>  $ entities         :Classes 'tbl_df', 'tbl' and 'data.frame':   10 obs. of  8 variables:
#>  $ documentSentiment:'data.frame':   1 obs. of  2 variables:
#>  $ language         : chr "en"
```

#### Sentences

"Sentence extraction breaks up the stream of text into a series of sentences." \[[API Documentation](https://cloud.google.com/natural-language/docs/basics#sentence-extraction)\]

-   `beginOffset` indicates the (zero-based) character index of where the sentence begins (wtih UTF-8 encoding).
-   The `magnitude` and `score` fields quantify each sentence's sentiment — see the [Document Sentiment](#document-sentiment) section for more details.

``` r
analyzed$sentences
```

<table>
<colgroup>
<col width="77%" />
<col width="9%" />
<col width="8%" />
<col width="5%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">content</th>
<th align="right">beginOffset</th>
<th align="right">magnitude</th>
<th align="right">score</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Google, headquartered in Mountain View, unveiled the new Android phone at the Consumer Electronic Show.</td>
<td align="right">0</td>
<td align="right">0.0</td>
<td align="right">0.0</td>
</tr>
<tr class="even">
<td align="left">Sundar Pichai said in his keynote that users love their new Android phones.</td>
<td align="right">113</td>
<td align="right">0.6</td>
<td align="right">0.6</td>
</tr>
</tbody>
</table>

#### Tokens

"Tokenization breaks the stream of text up into a series of tokens, with each token usually corresponding to a single word. The Natural Language API then processes the tokens and, using their locations within sentences, adds syntactic information to the tokens." \[[API Documentation](https://cloud.google.com/natural-language/docs/basics#tokenization)\]

-   `lemma` indicates the token's "root" word, and can be useful in standardizing the word within the text.
-   `tag` indicates the token's part of speech.
-   Additional column definitions are outlined [here](https://cloud.google.com/natural-language/docs/basics#tokenization) and [here](https://cloud.google.com/natural-language/docs/morphology#parts_of_speech).

``` r
analyzed$tokens
```

<table>
<colgroup>
<col width="5%" />
<col width="4%" />
<col width="4%" />
<col width="2%" />
<col width="5%" />
<col width="5%" />
<col width="5%" />
<col width="5%" />
<col width="5%" />
<col width="5%" />
<col width="5%" />
<col width="5%" />
<col width="7%" />
<col width="5%" />
<col width="5%" />
<col width="11%" />
<col width="8%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">content</th>
<th align="right">beginOffset</th>
<th align="left">lemma</th>
<th align="left">tag</th>
<th align="left">aspect</th>
<th align="left">case</th>
<th align="left">form</th>
<th align="left">gender</th>
<th align="left">mood</th>
<th align="left">number</th>
<th align="left">person</th>
<th align="left">proper</th>
<th align="left">reciprocity</th>
<th align="left">tense</th>
<th align="left">voice</th>
<th align="right">dependencyEdge_headTokenIndex</th>
<th align="left">dependencyEdge_label</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Google</td>
<td align="right">0</td>
<td align="left">Google</td>
<td align="left">NOUN</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">SINGULAR</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">7</td>
<td align="left">NSUBJ</td>
</tr>
<tr class="even">
<td align="left">,</td>
<td align="right">6</td>
<td align="left">,</td>
<td align="left">PUNCT</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">NUMBER_UNKNOWN</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">0</td>
<td align="left">P</td>
</tr>
<tr class="odd">
<td align="left">headquartered</td>
<td align="right">8</td>
<td align="left">headquarter</td>
<td align="left">VERB</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">NUMBER_UNKNOWN</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">PAST</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">0</td>
<td align="left">VMOD</td>
</tr>
<tr class="even">
<td align="left">in</td>
<td align="right">22</td>
<td align="left">in</td>
<td align="left">ADP</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">NUMBER_UNKNOWN</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">2</td>
<td align="left">PREP</td>
</tr>
<tr class="odd">
<td align="left">Mountain</td>
<td align="right">25</td>
<td align="left">Mountain</td>
<td align="left">NOUN</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">SINGULAR</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">5</td>
<td align="left">NN</td>
</tr>
<tr class="even">
<td align="left">View</td>
<td align="right">34</td>
<td align="left">View</td>
<td align="left">NOUN</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">SINGULAR</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">3</td>
<td align="left">POBJ</td>
</tr>
<tr class="odd">
<td align="left">,</td>
<td align="right">38</td>
<td align="left">,</td>
<td align="left">PUNCT</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">NUMBER_UNKNOWN</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">0</td>
<td align="left">P</td>
</tr>
<tr class="even">
<td align="left">unveiled</td>
<td align="right">40</td>
<td align="left">unveil</td>
<td align="left">VERB</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">INDICATIVE</td>
<td align="left">NUMBER_UNKNOWN</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">PAST</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">7</td>
<td align="left">ROOT</td>
</tr>
<tr class="odd">
<td align="left">the</td>
<td align="right">49</td>
<td align="left">the</td>
<td align="left">DET</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">NUMBER_UNKNOWN</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">11</td>
<td align="left">DET</td>
</tr>
<tr class="even">
<td align="left">new</td>
<td align="right">53</td>
<td align="left">new</td>
<td align="left">ADJ</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">NUMBER_UNKNOWN</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">11</td>
<td align="left">AMOD</td>
</tr>
<tr class="odd">
<td align="left">Android</td>
<td align="right">57</td>
<td align="left">Android</td>
<td align="left">NOUN</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">SINGULAR</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">11</td>
<td align="left">NN</td>
</tr>
<tr class="even">
<td align="left">phone</td>
<td align="right">65</td>
<td align="left">phone</td>
<td align="left">NOUN</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">SINGULAR</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">7</td>
<td align="left">DOBJ</td>
</tr>
<tr class="odd">
<td align="left">at</td>
<td align="right">71</td>
<td align="left">at</td>
<td align="left">ADP</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">NUMBER_UNKNOWN</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">7</td>
<td align="left">PREP</td>
</tr>
<tr class="even">
<td align="left">the</td>
<td align="right">74</td>
<td align="left">the</td>
<td align="left">DET</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">NUMBER_UNKNOWN</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">16</td>
<td align="left">DET</td>
</tr>
<tr class="odd">
<td align="left">Consumer</td>
<td align="right">78</td>
<td align="left">Consumer</td>
<td align="left">NOUN</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">SINGULAR</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">16</td>
<td align="left">NN</td>
</tr>
<tr class="even">
<td align="left">Electronic</td>
<td align="right">87</td>
<td align="left">Electronic</td>
<td align="left">NOUN</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">SINGULAR</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">16</td>
<td align="left">NN</td>
</tr>
<tr class="odd">
<td align="left">Show</td>
<td align="right">98</td>
<td align="left">Show</td>
<td align="left">NOUN</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">SINGULAR</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">12</td>
<td align="left">POBJ</td>
</tr>
<tr class="even">
<td align="left">.</td>
<td align="right">102</td>
<td align="left">.</td>
<td align="left">PUNCT</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">NUMBER_UNKNOWN</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">7</td>
<td align="left">P</td>
</tr>
<tr class="odd">
<td align="left">Sundar</td>
<td align="right">113</td>
<td align="left">Sundar</td>
<td align="left">NOUN</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">SINGULAR</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">19</td>
<td align="left">NN</td>
</tr>
<tr class="even">
<td align="left">Pichai</td>
<td align="right">120</td>
<td align="left">Pichai</td>
<td align="left">NOUN</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">SINGULAR</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">20</td>
<td align="left">NSUBJ</td>
</tr>
<tr class="odd">
<td align="left">said</td>
<td align="right">127</td>
<td align="left">say</td>
<td align="left">VERB</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">INDICATIVE</td>
<td align="left">NUMBER_UNKNOWN</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">PAST</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">20</td>
<td align="left">ROOT</td>
</tr>
<tr class="even">
<td align="left">in</td>
<td align="right">132</td>
<td align="left">in</td>
<td align="left">ADP</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">NUMBER_UNKNOWN</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">20</td>
<td align="left">PREP</td>
</tr>
<tr class="odd">
<td align="left">his</td>
<td align="right">135</td>
<td align="left">his</td>
<td align="left">PRON</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">GENITIVE</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">MASCULINE</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">SINGULAR</td>
<td align="left">THIRD</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">23</td>
<td align="left">POSS</td>
</tr>
<tr class="even">
<td align="left">keynote</td>
<td align="right">139</td>
<td align="left">keynote</td>
<td align="left">NOUN</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">SINGULAR</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">21</td>
<td align="left">POBJ</td>
</tr>
<tr class="odd">
<td align="left">that</td>
<td align="right">147</td>
<td align="left">that</td>
<td align="left">ADP</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">NUMBER_UNKNOWN</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">26</td>
<td align="left">MARK</td>
</tr>
<tr class="even">
<td align="left">users</td>
<td align="right">152</td>
<td align="left">user</td>
<td align="left">NOUN</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">PLURAL</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">26</td>
<td align="left">NSUBJ</td>
</tr>
<tr class="odd">
<td align="left">love</td>
<td align="right">158</td>
<td align="left">love</td>
<td align="left">VERB</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">INDICATIVE</td>
<td align="left">NUMBER_UNKNOWN</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">PRESENT</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">20</td>
<td align="left">CCOMP</td>
</tr>
<tr class="even">
<td align="left">their</td>
<td align="right">163</td>
<td align="left">their</td>
<td align="left">PRON</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">GENITIVE</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">PLURAL</td>
<td align="left">THIRD</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">30</td>
<td align="left">POSS</td>
</tr>
<tr class="odd">
<td align="left">new</td>
<td align="right">169</td>
<td align="left">new</td>
<td align="left">ADJ</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">NUMBER_UNKNOWN</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">30</td>
<td align="left">AMOD</td>
</tr>
<tr class="even">
<td align="left">Android</td>
<td align="right">173</td>
<td align="left">Android</td>
<td align="left">NOUN</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">SINGULAR</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">30</td>
<td align="left">NN</td>
</tr>
<tr class="odd">
<td align="left">phones</td>
<td align="right">181</td>
<td align="left">phone</td>
<td align="left">NOUN</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">PLURAL</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">26</td>
<td align="left">DOBJ</td>
</tr>
<tr class="even">
<td align="left">.</td>
<td align="right">187</td>
<td align="left">.</td>
<td align="left">PUNCT</td>
<td align="left">ASPECT_UNKNOWN</td>
<td align="left">CASE_UNKNOWN</td>
<td align="left">FORM_UNKNOWN</td>
<td align="left">GENDER_UNKNOWN</td>
<td align="left">MOOD_UNKNOWN</td>
<td align="left">NUMBER_UNKNOWN</td>
<td align="left">PERSON_UNKNOWN</td>
<td align="left">PROPER_UNKNOWN</td>
<td align="left">RECIPROCITY_UNKNOWN</td>
<td align="left">TENSE_UNKNOWN</td>
<td align="left">VOICE_UNKNOWN</td>
<td align="right">20</td>
<td align="left">P</td>
</tr>
</tbody>
</table>

<!---

```
#> # A tibble: 32 x 17
#>    content       beginOffset lemma       tag   aspect         case         form         gender         mood         number         person         proper         reciprocity         tense         voice         dependencyEdge_headTokenIndex dependencyEdge_label
#>    <chr>               <int> <chr>       <chr> <chr>          <chr>        <chr>        <chr>          <chr>        <chr>          <chr>          <chr>          <chr>               <chr>         <chr>                                 <int> <chr>               
#>  1 Google                  0 Google      NOUN  ASPECT_UNKNOWN CASE_UNKNOWN FORM_UNKNOWN GENDER_UNKNOWN MOOD_UNKNOWN SINGULAR       PERSON_UNKNOWN PROPER         RECIPROCITY_UNKNOWN TENSE_UNKNOWN VOICE_UNKNOWN                             7 NSUBJ               
#>  2 ,                       6 ,           PUNCT ASPECT_UNKNOWN CASE_UNKNOWN FORM_UNKNOWN GENDER_UNKNOWN MOOD_UNKNOWN NUMBER_UNKNOWN PERSON_UNKNOWN PROPER_UNKNOWN RECIPROCITY_UNKNOWN TENSE_UNKNOWN VOICE_UNKNOWN                             0 P                   
#>  3 headquartered           8 headquarter VERB  ASPECT_UNKNOWN CASE_UNKNOWN FORM_UNKNOWN GENDER_UNKNOWN MOOD_UNKNOWN NUMBER_UNKNOWN PERSON_UNKNOWN PROPER_UNKNOWN RECIPROCITY_UNKNOWN PAST          VOICE_UNKNOWN                             0 VMOD                
#>  4 in                     22 in          ADP   ASPECT_UNKNOWN CASE_UNKNOWN FORM_UNKNOWN GENDER_UNKNOWN MOOD_UNKNOWN NUMBER_UNKNOWN PERSON_UNKNOWN PROPER_UNKNOWN RECIPROCITY_UNKNOWN TENSE_UNKNOWN VOICE_UNKNOWN                             2 PREP                
#>  5 Mountain               25 Mountain    NOUN  ASPECT_UNKNOWN CASE_UNKNOWN FORM_UNKNOWN GENDER_UNKNOWN MOOD_UNKNOWN SINGULAR       PERSON_UNKNOWN PROPER         RECIPROCITY_UNKNOWN TENSE_UNKNOWN VOICE_UNKNOWN                             5 NN                  
#>  6 View                   34 View        NOUN  ASPECT_UNKNOWN CASE_UNKNOWN FORM_UNKNOWN GENDER_UNKNOWN MOOD_UNKNOWN SINGULAR       PERSON_UNKNOWN PROPER         RECIPROCITY_UNKNOWN TENSE_UNKNOWN VOICE_UNKNOWN                             3 POBJ                
#>  7 ,                      38 ,           PUNCT ASPECT_UNKNOWN CASE_UNKNOWN FORM_UNKNOWN GENDER_UNKNOWN MOOD_UNKNOWN NUMBER_UNKNOWN PERSON_UNKNOWN PROPER_UNKNOWN RECIPROCITY_UNKNOWN TENSE_UNKNOWN VOICE_UNKNOWN                             0 P                   
#>  8 unveiled               40 unveil      VERB  ASPECT_UNKNOWN CASE_UNKNOWN FORM_UNKNOWN GENDER_UNKNOWN INDICATIVE   NUMBER_UNKNOWN PERSON_UNKNOWN PROPER_UNKNOWN RECIPROCITY_UNKNOWN PAST          VOICE_UNKNOWN                             7 ROOT                
#>  9 the                    49 the         DET   ASPECT_UNKNOWN CASE_UNKNOWN FORM_UNKNOWN GENDER_UNKNOWN MOOD_UNKNOWN NUMBER_UNKNOWN PERSON_UNKNOWN PROPER_UNKNOWN RECIPROCITY_UNKNOWN TENSE_UNKNOWN VOICE_UNKNOWN                            11 DET                 
#> 10 new                    53 new         ADJ   ASPECT_UNKNOWN CASE_UNKNOWN FORM_UNKNOWN GENDER_UNKNOWN MOOD_UNKNOWN NUMBER_UNKNOWN PERSON_UNKNOWN PROPER_UNKNOWN RECIPROCITY_UNKNOWN TENSE_UNKNOWN VOICE_UNKNOWN                            11 AMOD                
#> # ... with 22 more rows
```
--->
#### Entities

"Entity Analysis provides information about entities in the text, which generally refer to named 'things' such as famous individuals, landmarks, common objects, etc... A good general practice to follow is that if something is a noun, it qualifies as an 'entity.'" \[[API Documentation](https://cloud.google.com/natural-language/docs/basics#entity_analysis)\]

-   `entity_type` indicates the type of entity (i.e., it classifies the entity as a person, location, consumer good, etc.).
-   `mid` provides a "machine-generated identifier" correspoding to the entity's [Google Knowledge Graph](https://www.google.com/intl/bn/insidesearch/features/search/knowledge.html) entry.
-   `wikipedia_url` provides the entity's [Wikipedia](https://www.wikipedia.org/) URL.
-   `salience` indicates the entity's importance to the entire text. Scores range from 0.0 (less important) to 1.0 (highly important).
-   Additional column definitions are outlined [here](https://cloud.google.com/natural-language/docs/basics#entity_analysis_response_fields).

``` r
analyzed$entities
```

<table>
<colgroup>
<col width="14%" />
<col width="8%" />
<col width="6%" />
<col width="32%" />
<col width="6%" />
<col width="14%" />
<col width="7%" />
<col width="8%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">name</th>
<th align="left">entity_type</th>
<th align="left">mid</th>
<th align="left">wikipedia_url</th>
<th align="right">salience</th>
<th align="left">content</th>
<th align="right">beginOffset</th>
<th align="left">mentions_type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Google</td>
<td align="left">ORGANIZATION</td>
<td align="left">/m/045c7b</td>
<td align="left"><a href="https://en.wikipedia.org/wiki/Google" class="uri">https://en.wikipedia.org/wiki/Google</a></td>
<td align="right">0.2557206</td>
<td align="left">Google</td>
<td align="right">0</td>
<td align="left">PROPER</td>
</tr>
<tr class="even">
<td align="left">users</td>
<td align="left">PERSON</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="right">0.1527633</td>
<td align="left">users</td>
<td align="right">152</td>
<td align="left">COMMON</td>
</tr>
<tr class="odd">
<td align="left">phone</td>
<td align="left">CONSUMER_GOOD</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="right">0.1311989</td>
<td align="left">phone</td>
<td align="right">65</td>
<td align="left">COMMON</td>
</tr>
<tr class="even">
<td align="left">Android</td>
<td align="left">CONSUMER_GOOD</td>
<td align="left">/m/02wxtgw</td>
<td align="left"><a href="https://en.wikipedia.org/wiki/Android_(operating_system)" class="uri">https://en.wikipedia.org/wiki/Android_(operating_system)</a></td>
<td align="right">0.1224526</td>
<td align="left">Android</td>
<td align="right">57</td>
<td align="left">PROPER</td>
</tr>
<tr class="odd">
<td align="left">Android</td>
<td align="left">CONSUMER_GOOD</td>
<td align="left">/m/02wxtgw</td>
<td align="left"><a href="https://en.wikipedia.org/wiki/Android_(operating_system)" class="uri">https://en.wikipedia.org/wiki/Android_(operating_system)</a></td>
<td align="right">0.1224526</td>
<td align="left">Android</td>
<td align="right">173</td>
<td align="left">PROPER</td>
</tr>
<tr class="even">
<td align="left">Sundar Pichai</td>
<td align="left">PERSON</td>
<td align="left">/m/09gds74</td>
<td align="left"><a href="https://en.wikipedia.org/wiki/Sundar_Pichai" class="uri">https://en.wikipedia.org/wiki/Sundar_Pichai</a></td>
<td align="right">0.1141411</td>
<td align="left">Sundar Pichai</td>
<td align="right">113</td>
<td align="left">PROPER</td>
</tr>
<tr class="odd">
<td align="left">Mountain View</td>
<td align="left">LOCATION</td>
<td align="left">/m/0r6c4</td>
<td align="left"><a href="https://en.wikipedia.org/wiki/Mountain_View,_California" class="uri">https://en.wikipedia.org/wiki/Mountain_View,_California</a></td>
<td align="right">0.1019596</td>
<td align="left">Mountain View</td>
<td align="right">25</td>
<td align="left">PROPER</td>
</tr>
<tr class="even">
<td align="left">Consumer Electronic Show</td>
<td align="left">EVENT</td>
<td align="left">/m/01p15w</td>
<td align="left"><a href="https://en.wikipedia.org/wiki/Consumer_Electronics_Show" class="uri">https://en.wikipedia.org/wiki/Consumer_Electronics_Show</a></td>
<td align="right">0.0703438</td>
<td align="left">Consumer Electronic Show</td>
<td align="right">78</td>
<td align="left">PROPER</td>
</tr>
<tr class="odd">
<td align="left">phones</td>
<td align="left">CONSUMER_GOOD</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="right">0.0338317</td>
<td align="left">phones</td>
<td align="right">181</td>
<td align="left">COMMON</td>
</tr>
<tr class="even">
<td align="left">keynote</td>
<td align="left">OTHER</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="right">0.0175884</td>
<td align="left">keynote</td>
<td align="right">139</td>
<td align="left">COMMON</td>
</tr>
</tbody>
</table>

#### Document sentiment

"Sentiment analysis attempts to determine the overall attitude (positive or negative) expressed within the text. Sentiment is represented by numerical `score` and `magnitude` values." \[[API Documentation](https://cloud.google.com/natural-language/docs/basics#sentiment_analysis)\]

-   `score` ranges from -1.0 (negative) to 1.0 (positive), and indicates to the "overall emotional leaning of the text".
-   `magnitude` "indicates the overall strength of emotion (both positive and negative) within the given text, between 0.0 and +inf. Unlike score, magnitude is not normalized; each expression of emotion within the text (both positive and negative) contributes to the text's magnitude (so longer text blocks may have greater magnitudes)."

A note on how to interpret these sentiment values is posted [here](https://cloud.google.com/natural-language/docs/basics#interpreting_sentiment_analysis_values).

``` r
analyzed$documentSentiment
```

|  magnitude|  score|
|----------:|------:|
|        0.6|    0.3|

#### Language

`language` indicates the detected language of the document. Only English ("en"), Spanish ("es") and Japanese ("ja") are currently supported by the API.

``` r
analyzed$language
#> [1] "en"
```
