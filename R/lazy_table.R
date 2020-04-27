#  lazyplyr - a most lazy dplyr implementation for remote datasets
#
# Copyright (c) 2020 M.A.J. Klik
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
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
    if (class(col) != "lazy_column") {
      if (is.list(col)) {
        col_list <- col
      } else {
        stop("column must be defined as a named set of lazy_column objects, please see", " lazy_column() documentation")
      }
    }
  } else {
    sapply(col_list, function(col) {
      if (class(col) != "lazy_column") stop("column must be defined as a named set of lazy_column objects, please see",
      " lazy_column() documentation")
    })
  }

  if ("" %in% names(col_list)) {
    stop("all columns must be named")
  }

  res <- as.list(seq_len(length(col_list)))
  names(res) <- names(col_list)
  
  header <- as.data.frame(res)

  class(res) <- "lazy_table"
  attr(res, "meta") <- col_list
  attr(res, "cols") <- header

  res
}
