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
