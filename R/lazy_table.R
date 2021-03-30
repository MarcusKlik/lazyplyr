# lazyplyr - a most lazy dplyr implementation for remote data frames
#
#  Copyright (C) 2021-present, Mark AJ Klik
#
#  This file is part of the lazyplyr R package.
#
#  This Source Code Form is subject to the terms of the Mozilla Public
#  License, v. 2.0. If a copy of the MPL was not distributed with this file,
#  You can obtain one at https://mozilla.org/MPL/2.0/.
#
#  https://www.mozilla.org/en-US/MPL/2.0/FAQ/
#
#  You can contact the author at:
#  - lazyplyr R package source repository : https://github.com/fstpackage/lazyplyr


#' Construct a lazy table
#'
#' @param lazy_table_impl implementation of a lazy_table class
#'
#' @description
#' Construct a lazy table by providing a `lazy_table_impl` class that can be used to access data. By providing the
#' interface class, data can be generated on the fly or retrieved from out-of-memory locations such as a disk.
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
