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


#' Define a lazy column
#'
#' @description
#' A 'lazy table' consists of one or more lazy columns. Each of these columns is a wrapper around a lazy column
#' implementation class `lazy_col_impl` that can be used to access column data. The implementation class does not
#' need to store column data in memory, but can use offline data storage instead (such as a file or database).
#'
#' @param lazy_col_impl custom metadata needed to define the column data
#'
#' @return a lazy column
#'
#' @export
lazy_column <- function(lazy_col_impl) {

  col <- list(
    meta = lazy_col_impl
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

  tibble(
    Test = "full read",
    Type = typeof(res),
    IsVector = is.vector(res),
    Length = length(res),
    Result = "oke"
  )
}
