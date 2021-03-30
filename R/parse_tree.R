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


#' restructure an expression for use with sub-setting methods `read_column` and `subset_vec`
#'
#' @param e expression to restructure
#' @param col_symbols vector with the symbol names of variables that can be subsetted
#'
#' @return a lazy table or vector
#' @export
parse_tree <- function(e, col_symbols) {

  e <- enexpr(e)

  tree <- parse_sub_tree(e, col_symbols)

  tree[[2]]
}


parse_sub_tree <- function(e, col_symbols) {  # nolint

  # check for constants
  if (is_syntactic_literal(e)) {
    return(list(FALSE, e))
  }

  # check for known column names
  if (is_symbol(e)) {

    col <- as_string(e)
    if (col %in% col_symbols) {
      return(list(TRUE, call2("read_column", e, expr(index), expr(length))))
    }

    return(list(FALSE, e))
  }

  if (is.call(e)) {

    # check for known methods
    method_name <- as_string(e[[1]])
    nr_of_args <- length(e) - 1

    method_hit <- method_table %>%
      filter(.data$Method == method_name & .data$NrOfArgs == nr_of_args)

    # unknown method, substitute only with full column reads
    if (nrow(method_hit) == 0) {
      return(list(FALSE, substitute_sub_tree(e, col_symbols)))
    }

    # single argument operator
    if (method_hit$Type == "so") {

      # parse arguments
      arg1 <- e[[2]]
      arg1 <- parse_sub_tree(expr(!!arg1), col_symbols)

      e[[2]] <- arg1[[2]]

      # nothing to subset
      if (!arg1[[1]]) {
        return(list(FALSE, e))
      }

      return(list(TRUE, e))
    }

    # dual argument operator
    if (method_hit$Type == "bo") {

      # parse arguments
      arg1 <- e[[2]]
      arg2 <- e[[3]]
      arg1 <- parse_sub_tree(expr(!!arg1), col_symbols)
      arg2 <- parse_sub_tree(expr(!!arg2), col_symbols)

      # both arguments are not subsettable
      if (!arg1[[1]] && !arg2[[1]]) {
        return(list(FALSE, e))
      }

      # first argument not subsettable
      if (!arg1[[1]]) {
        arg1[[2]] <- call2("subset_vec", arg1[[2]], expr(index), expr(length))
      }

      if (!arg2[[1]]) {
        arg2[[2]] <- call2("subset_vec", arg2[[2]], expr(index), expr(length))
      }

      e[[2]] <- arg1[[2]]
      e[[3]] <- arg2[[2]]

      return(list(TRUE, e))
    }

    stop("unknown function type")
  }

  return(list(FALSE, e))
}


substitute_sub_tree <- function(e, col_symbols) {

  # check for constants
  if (is_syntactic_literal(e)) {
    return(e)
  }

  # check for known column names
  if (is_symbol(e)) {

    col <- as_string(e)
    if (col %in% col_symbols) {
      return(call2("read_column", e, expr(NULL)))
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
