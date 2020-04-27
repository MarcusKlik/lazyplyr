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


#' Read data from a lazy column
#'
#' @param lazy_col a lazy column
#' @param index an integer vector specifying the indices to use from the vector, a single integer specifying
#' the starting index position of the subset or NULL. If a single integer is used, length should be equal to the total number
#' of elements. If NULL, the full column will be read.
#' @param length total number of elements required or NULL if parameter index is set to a integer vector
#'
#' @return
#' @export
#'
#' @examples
read_column <- function(lazy_col, index, length) {
  UseMethod("read_column")
}
