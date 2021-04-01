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


#' Define a lazy data frame
#'
#' @param ... columns for the lazy_frame or a data frame (or equivalent)
#'
#' @description A lazy frame is an implementation of the `lazy table` interface for data frames. This class serves
#' as an example for how to implement a `lazy table`. It wraps an existing data frame and implements the API using a
#' data frame stored in memory.
#'
#' @return object of class `lazy_frame` that provides an implementation for the `lazy table` API
#' @export
lazy_frame <- function(...) {

  args <- list(...)

  # arguments can be a single data frame or multiple columns
  if (length(args) == 1 && is.data.frame(args[[1]])) {
    meta <- as.data.frame(args)
  } else {
    meta <- data.frame(...)
  }

  lazy_table_impl <- structure(list(data = meta), class = "lazy_frame")

  lazy_table(lazy_table_impl)
}


#' @export
read_row_index.lazy_frame <- function(x, col_name, index) {  # nolint
  x$data[[col_name]][index]
}


#' @export
read_row_range.lazy_frame <- function(x, col_name, from, length) {  # nolint
  x$data[[col_name]][from:(from + length - 1)]
}


#' @export
column_names.lazy_frame <- function(x) {  # nolint
  colnames(x$data)
}
