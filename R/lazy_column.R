#  lazyplyr - a most lazy dplyr implementation for remote datasets
#
#  Copyright (C) 2019-present, Mark AJ Klik
#
#  This file is part of the lazyplyr R package.
#
#  The lazyplyr R package is free software: you can redistribute it and/or modify it
#  under the terms of the GNU Affero General Public License version 3 as
#  published by the Free Software Foundation.
#
#  The lazyplyr R package is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License
#  for more details.
#
#  You should have received a copy of the GNU Affero General Public License along
#  with the lazyplyr R package. If not, see <http://www.gnu.org/licenses/>.
#
#  You can contact the author at:
#  - lazyplyr R package source repository : https://github.com/fstpackage/lazyplyr


#' A lazy column
#'
#' @param meta custom metadata needed to define the column data
#'
#' @return a lazy column
#' @export
lazy_column <- function(meta) {

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
#'
#' @examples
read_column.lazy_column <- function(lazy_col, index, length) {

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
#' @return TRUE if the teste were succesfull, FALSE otherwise
#' @export
#'
#' @examples
lazy_column_test <- function(lazy_col) {

  res <- read_column(lazy_col, NULL, NULL)
  meta <- data.frame(Test = "full read", Type = typeof(res), IsVector = is.vector(res), Length = length(res), Result = "oke")

  as_tibble(meta)
}
