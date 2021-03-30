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


#' Read data from a lazy column
#'
#' @param lazy_col a lazy column
#' @param index an integer vector specifying the index to use from the vector, a single integer specifying
#' the starting index position of the subset or NULL. If a single integer is used, length should be equal to
#' the total number of elements. If NULL, the full column will be read.
#' @param length total number of elements required or NULL if parameter index is set to a integer vector
#'
#' @return a subset of a lazy_column
#' @export
read_column <- function(lazy_col, index, length) {

}


#' Subset vector using special semantics
#'
#' @param vec vector to subset
#' @param index an integer vector specifying the elements to use from the vector, a single integer specifying
#' the starting index position of the subset or NULL. If a single integer is used, length should be equal to the
#' total number of elements. If NULL, the full column will be read.
#' @param length total number of elements required or NULL if parameter index is set to a integer vector
#'
#' @return a subset of vector `vec`
#' @export
subset_vec <-  function(vec, index, length) {
  # full column
  if (is.null(index) || length(vec) == 1) {
    return(vec)
  }

  # range
  if (is.null(length)) {
    return(vec[index])
  }

  vec[index:(index + length - 1)]
}
