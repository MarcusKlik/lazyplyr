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


#' wrap a table or vector
#'
#' @param obj a data.frame, tibble, data.table or vector object
#'
#' @return a lazy table or vector
#' @export
wrap <- function(obj) {

  if (is.vector(obj)) {
    return(lazy_column(obj))
  }

  if (!is.data.frame(obj)) {
    stop("obj must be a data.frame (or equivalent) or a vector")
  }

  res <- lapply(obj, function(col) {
    lazy_column(col)
  })

  lazy_table(res)
}
