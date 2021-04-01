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
#' @param lazy_table_impl a custom class for which all the `lazy_table` generics are implemented:
#'
#' * read_row_index
#' * read_row_range
#' * column_names
#'
#' These generic functions are required for a `lazy_table` to be able to implement the full dplyr syntax.
#'
#' @description
#' Construct a lazy table by providing a `lazy_table_impl` class that can be used to access data. By providing the
#' interface class, data can be generated on the fly or retrieved from out-of-memory locations such as a disk.
#'
#' @return a lazy table
#' @export
#' @md
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
