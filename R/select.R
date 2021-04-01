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


#' @export
select.lazy_table <- function(.data, ...) {  # nolint

  selector <- attr(.data, "cols")
  col_list <- attr(.data, "meta")

  # select
  cols <- tidyselect::eval_select(expr(c(...)), selector)
  selector <- selector[cols]
  colnames(selector) <- names(cols)

  res <- as.list(selector)

  attr(res, "cols") <- selector
  attr(res, "meta") <- col_list
  class(res) <- "lazy_table"

  res
}


#' @export
dplyr::rename


#' @export
rename.lazy_table <- function(.data, ...) {  # nolint

  tidyselect::eval_rename(..., .data)
}
