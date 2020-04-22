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


#' @export
dplyr::`%>%`


#' @export
dplyr::select
#' @export
select.lazy_table <- function(.data, ...) {  # nolint

  col_data <- attr(.data, "cols")
  cols <- tidyselect::eval_select(expr(c(...)), col_data)

  selection <- col_data[cols]
  colnames(selection) <- names(cols)
  
  attr(.data, "cols") <- selection
  .data
}


#' @export
dplyr::rename
#' @export
rename.lazy_table <- function(.data, ...) {  # nolint

  tidyselect::eval_rename(..., .data)
}
