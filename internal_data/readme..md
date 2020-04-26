
# method table

This table is used as an internal dataset to lazyplyr. When updated, 'methods.csv' should be compiled into an internal dataset 'R/sysdata.rda' by running:

``` r
method_table <- read.csv2("methods.csv",stringsAsFactors = FALSE)
usethis::use_data(method_table, internal = TRUE, overwrite = TRUE)
```
