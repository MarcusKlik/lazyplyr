# lazyplyr - a most lazy dplyr implementation for remote datasets
#
# Copyright (c) 2020 M.A.J. Klik
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#  You can contact the author at:
#  - lazyplyr R package source repository : https://github.com/fstpackage/lazyplyr


#' Define a lazy column
#'
#' @description
#' A 'lazy table' consists of one or more lazy columns. Each of these columns is a wrapper around a lazy column
#' implementation class `lazy_col_impl` that can be used to access column data. The implementation class does not
#' need to store column data in memory, but can use offline data storage instead (such as a file or database).
#'
#' @param lazy_col_impl custom metadata needed to define the column data
#'
#' @return
#' a lazy column
#' @export
lazy_column <- function(lazy_col_impl) {

  col <- list(
    meta = meta
  )

  class(col) <- "lazy_column"

  col
}


#' Default lazy column implementation
#'
#' @param lazy_col a custom lazy column
#' @param index an integer vector specifying the indices to use from the vector or a single integer specifying
#' the starting index position of the subset. If a single integer is used, length should be equal to the total number
#' of elements.
#' @param length total number of elements required or NULL if parameter index is set to a integer vector
#'
#' @return
#' @export
read_column.lazy_column <- function(lazy_col, index, length) {  # nolint

  # full column
  if (is.null(index)) {
    return(lazy_col$meta)
  }

  # range
  if (is.null(length)) {
    return(lazy_col$meta[index])
  }

  lazy_col$meta[index:(index + length - 1)]
}


#' Test a custom implemented lazy column
#'
#' @param lazy_col a custom lazy_column
#'
#' @return TRUE if the tests were successful, FALSE otherwise
#' @export
lazy_column_test <- function(lazy_col) {

  res <- read_column(lazy_col, NULL, NULL)
  meta <- data.frame(
    Test = "full read",
    Type = typeof(res),
    IsVector = is.vector(res),
    Length = length(res),
    Result = "oke"
  )

  as_tibble(meta)
}
