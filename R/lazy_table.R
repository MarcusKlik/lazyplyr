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


#' Construct a lazy table
#'
#' @description
#' Construct a lazy table by providing a `lazy_table_impl` class that can be used to access data. By providing the
#' interface class, data can be generated on the fly or retrieved from out-of-memory locations such as a disk.
#'
#' @param ... lazy table columns defined as a set of named lazy columns
#'
#' @return a lazy table
#' @export
lazy_table <- function(lazy_table_impl) {

  # test API here

  # get column names
  col_names <- column_names(lazy_table_impl)

  meta <- list(
    lt_impl = lazy_table_impl,
    cols = col_names
  )

  res <- as.list(seq_len(length(col_names)))
  names(res) <- col_names

  header <- as.data.frame(res)

  class(res) <- "lazy_table"
  attr(res, "meta") <- meta
  attr(res, "cols") <- header

  res
}


#' Read data from a lazy column
#'
#' @param lazy_table_impl a custom object with a lazy table API such as a `lazy_frame` (see method `lazy_frame()`)
#' @param col_name lazy table column to retrieve data from
#' @param index integer vector specifying the index to use from the vector, a single integer specifying
#' the starting index position of the subset or NULL. If a single integer is used, length should be equal to
#' the total number of elements. If NULL, the full column will be read.
#'
#' @return a subset of a single lazy table column vector
#' @export
read_row_index <- function(lazy_table_impl, col_name, index) {
  UseMethod("read_row_index", lazy_table_impl)
}


#' Read data from a lazy column
#'
#' @param lazy_frame an object generated with `lazy_frame()`
#' @param col_name lazy table column to retrieve data from
#' @param from starting element
#' @param length length of the vector returned
#'
#' @return a subset of a single lazy table column vector
#' @export
#' @rdname read_row_index
read_row_range <- function(lazy_table_impl, col_name, from, length) {
  UseMethod("read_row_range", lazy_table_impl)
}


#' Get column names
#'
#' @param lazy_table_impl a custom object with a lazy table API such as a `lazy_frame` (see method `lazy_frame()`)
#'
#' @return character vector of column names
#' @export
column_names <- function(lazy_table_impl) {
  UseMethod("column_names", lazy_table_impl)
}
