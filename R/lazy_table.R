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


#' A lazy table
#'
#' @param ... lazy table columns defined as a set of named lazy columns
#'
#' @return a lazy table
#' @export
lazy_table <- function(...) {

  col_list <- list(...)

  if (length(col_list) == 1) {
    col <- col_list[[1]]
    if (class(col) != "lazycolumn") {
      if (is.list(col)) col_list <- col
    } else {
      stop("column must be defined as a named set of lazy_column objects, please see", " lazy_column() documentation")
    }
  } else {
    sapply(col_list, function(col) {
      if (class(col) != "lazycolumn") stop("column must be defined as a named set of lazy_column objects, please see",
      " lazy_column() documentation")
    })
  }

  if ("" %in% names(col_list)) {
    stop("all columns must be named")
  }

  class(col_list) <- "lazytable"

  attr(col_list, "meta") <- list(
    B = 20
  )  
  
  col_list
}
