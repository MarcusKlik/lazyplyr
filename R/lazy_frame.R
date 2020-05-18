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


#' Define a lazy data frame
#'
#' @description A lazy frame is an implementation of the `lazy table` interface for data frames. This class serves
#' as an example for how to implement a `lazy table`. It wraps an existing data frame and implements the API using that
#' stored table.
#'
#' @param data_frame a data frame or equivalent such as a `tibble` or `data.table`
#'
#' @return object of class `lazy_frame` that provides an implementation for the `lazy table` API
#' @export
lazy_frame <- function(data_frame) {
  
  # define meta data
  meta <- list(data = data_frame)
  
  class(meta) <- "lazy_frame"
  
  meta
}


#' @export
read_row_index.lazy_frame <- function(lazy_frame, col_name, index) {  # nolint
  lazy_frame$data[[col_name]][index]
}


#' @export
read_row_range.lazy_frame <- function(lazy_frame, col_name, from, length) {  # nolint
  lazy_frame$data[[col_name]][from:(from + length - 1)]
}


#' @export
column_names.lazy_frame <- function(lazy_frame) {  # nolint
  colnames(lazy_frame$data)
}
