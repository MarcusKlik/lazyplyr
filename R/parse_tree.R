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


#' Wraps a single argument operator or function
#'
#' @param method method to wrap
#' @param vec1 a vector, must have length equal to 1 or the length of vec2
#' @param index an integer vector specifying the indices to use from the vector, a single integer specifying
#' the starting index position of the subset or NULL. If a single integer is used, length should be equal to the total number
#' of elements. If NULL, the full column will be read.
#' @param length total number of elements required or NULL if parameter index is set to a integer vector
#'
#' @return
#' @export
op1 <- function(method, vec1, index, length = NULL) {

  # full column
  if (is.null(index)) {
    return(method(vec1))
  }
  
  # index vector
  if (is.null(length)) {
    if (length(vec1) == 1) {
      return(method(vec1))
    } else {
      return(method(vec1[index]))
    }
  }

  # range
  if (length(vec1) == 1) {
    return(method(vec1))
  }

  method(vec1[index:(index + length - 1)])
}


#' Wraps a binary operator to enable subset results
#'
#' @param method method to wrap
#' @param vec1 a vector, must have length equal to 1 or the length of vec2
#' @param vec2 a vector, must have length equal to 1 or the length of vec1
#' @param index an integer vector specifying the indices to use from the vector, a single integer specifying
#' the starting index position of the subset or NULL. If a single integer is used, length should be equal to the total number
#' of elements. If NULL, the full column will be read.
#' @param length total number of elements required or NULL if parameter index is set to a integer vector
#'
#' @return
#' @export
op2 <- function(method, vec1, vec2, index, length = NULL) {
  
  # full column
  if (is.null(index)) {
    return(method(vec1, vec2))
  }
  
  # index vector
  if (is.null(length)) {
    if (length(vec1) == 1) {
      
      if (length(vec2) == 1) {
        return(method(vec1, vec2))
      } else {
        return(method(vec1, vec2[index]))
      }
    }
    
    if (length(vec2) == 1) {
      return(method(vec1[index], vec2))
    }
    return(method(vec1[index], vec2[index]))
  }
  
  # range
  if (length(vec1) == 1) {
    
    if (length(vec2) == 1) {
      return(method(vec1, vec2))
    } else {
      return(method(vec1, vec2[index:(index + length - 1)]))
    }
  }
  
  if (length(vec2) == 1) {
    return(method(vec1[index:(index + length - 1)], vec2))
  }
  
  method(vec1[index:(index + length - 1)], vec2[index:(index + length - 1)])
}


#' wrap a table or vector
#'
#' @param obj a data.frame, tibble, data.table or vector object
#'
#' @return a lazy table or vector
#' @export
parse_tree <- function(lazy_tbl, e) {
  col_symbols <- names(lazy_tbl)
  
  tree <- parse_sub_tree(e, col_symbols)

  tree[[2]]
}


#' Title
#'
#' @param e 
#' @param col_symbols 
#'
#' @return
#' @export
#'
#' @examples
parse_sub_tree <- function(e, col_symbols) {

  # check for known column names
  if (is_symbol(e)) {

    col <- as_string(e)
    if (col %in% col_symbols) {
      return(list(TRUE, call2("lazyplyr::read_column", e, expr(index), expr(length))))
    }

    return(list(FALSE, e))
  }

  if (is.call(e)) {

    # check for known methods
    method_name <- as_string(e[[1]])

    method_hit <- method_table %>%
      filter(Method == method_name)

    # unknown method, substitute only with full column reads
    if (nrow(method_hit) == 0) {
      return(list(FALSE, substitute_sub_tree(e, col_symbols)))
    }

    # binary operator
    if (method_hit$Type == "so") {

      # parse arguments
      arg1 <- parse_sub_tree(e[[2]], col_symbols)

      # nothing to subset
      if (!arg1[[1]]) {
        return(list(FALSE, e))
      }

      return(list(TRUE, call2(lazyplyr::op1, e[[1]], arg1, expr(index), expr(length))))
    }

    # binary operator
    if (method_hit$Type == "bo") {

      # parse arguments
      arg1 <- parse_sub_tree(e[[2]], col_symbols)
      arg2 <- parse_sub_tree(e[[3]], col_symbols)

      if (!arg1[[1]] && !args2[[1]]) {
        return(list(FALSE, e))
      }

      return(list(TRUE, call2(lazyplyr::op2, e[[1]], arg1, arg2, expr(index), expr(length))))
    }

    stop("unknown function type")
  }
  
  return(list(FALSE, e))
}


#' Title
#'
#' @param e 
#' @param col_symbols 
#'
#' @return
#' @export
#'
#' @examples
substitute_sub_tree <- function(e, col_symbols) {
  
  # check for known column names
  if (is_symbol(e)) {
    
    col <- as_string(e)
    if (col %in% col_symbols) {
      return(call2("lazyplyr::read_column", e, expr(NULL)))
    }
    
    return(e)
  }
  
  if (is.call(e)) {

    # substitute sub trees
    if (length(e) == 1) {
      return(e)
    }

    res <- as.list(rep(1, length(e)))
    res[[1]] <- e[[1]]
    for (pos in 2:length(e)) {

      # substitute argument
      res[[pos]] <- substitute_sub_tree(e[[pos]], col_symbols)
    }

    return(as.call(res))
  }

  return(e)
}
