## Resubmission
This is a resubmission. In this version I have:

* Updated the LICENSE file to match CRAN format specifications.

* Added angle brackets around the link in the DESCRIPTION file.

* Made it clearer that the user's .Renviron file will only be
  edited if they call the `configure_googlenlp()` function directly.
  I also listed out alternative methods of authentication if the
  user prefers not to edit their .Renviron file.

* Added a dontrun wrapper to the `configure_googlenlp()` example.

## Test environments
* local OS X install, R 3.4.2
* Ubuntu 14.04.5 (on travis-ci), R 3.5.0

## R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE:

* checking R code for possible problems ... NOTE
  flatten_entities : <anonymous>: no visible binding for global variable ‘.’
  flatten_entities : <anonymous>: no visible binding for global variable ‘mid’
  flatten_entities : <anonymous>: no visible binding for global variable ‘wikipedia_url’
  ...
  
  These are all unquoted field/column names used in the flatten_* functions.

## Downstream dependencies
There are currently no downstream dependencies for this package.
