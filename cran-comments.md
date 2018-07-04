## Resubmission
This is a resubmission. In this version I have:

* Updated the LICENSE file to match CRAN format specifications.

* Fixed NOTEs resulting from the use of non-standard evaluation functions.

* Added link to in the DESCRIPTION file pointing to the package on Github.

* Use `warning` instead of `stop` when the API returns nothing
  for the `flatten_*` functions to operate upon.

* Added angle brackets around the links in the DESCRIPTION file.

* Made it clearer that the user's .Renviron file will only be
  edited if they call the `configure_googlenlp()` function directly.
  I also listed out alternative methods of authentication if the
  user prefers not to edit their .Renviron file.

* Added a `dontrun` wrapper to the `configure_googlenlp()` example.

## Test environments
* local OS X install, R 3.4.2
* Ubuntu 14.04.5 (on travis-ci), R 3.5.0

## R CMD check results
There were 0 ERRORs, 0 WARNINGs, and 0 NOTEs.

## Downstream dependencies
There are currently no downstream dependencies for this package.
