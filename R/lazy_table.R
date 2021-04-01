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


# test for existence of generic function
has_generic <- function(generic, class_name) {
  gen_function <- paste0(generic, ".", class_name)
  exists(gen_function, mode = "function")
}


#' Construct a lazy table
#'
#' @param lazy_table_impl a custom class for which all the `lazy_table` generics are implemented:
#'
#' * read_row_index
#' * read_row_range
#' * column_names
#'
#' These generic functions are required for a `lazy_table` to be able to implement the full dplyr syntax.
#'
#' @description
#' Construct a lazy table by providing a `lazy_table_impl` class that can be used to access data. By providing the
#' interface class, data can be generated on the fly or retrieved from out-of-memory locations such as a disk.
#'
#' @return a lazy table
#' @export
#' @md
lazy_table <- function(lazy_table_impl) {

  attrs <- attributes(lazy_table_impl)

  if (!("class" %in% names(attrs))) {
    stop("parameter lazy_table_impl must have a class")
  }

  # class test
  class_name <- class(lazy_table_impl)
  if (length(class_name) != 1) {
    stop("single class attribute expected, but found ", length(class_name))
  }

  # test API
  txt_ok <- crayon::green("ok")
  txt_nok <- crayon::red("not-ok")

  test <- crayon::bold("Test")
  res <- crayon::bold("Res")
  res_message <- crayon::bold("Message")

  generics <- c(
    "column_names",
    "read_row_index",
    "read_row_range"
  )

  generic_args <- c(
    "(x)",
    "(x, col_name, index)",
    "(x, col_name, from, length)"
  )

  for (count in seq_len(length(generics))) {
    generic <- generics[count]
    test <- c(test, crayon::black(paste0(generic, generic_args[count])))
    pass <- has_generic(generic, class_name)
    res <- c(res, ifelse(pass, txt_ok, txt_nok))
    res_message <- c(res_message, ifelse(pass, "",
      crayon::black(paste0("generic '", paste0(generic, ".", class_name), "' not found"))))
  }

  if (sum(res == txt_nok) > 0) {
    message(crayon::italic("Some of the required generics are missing:\n"))

    test %>%
      pillar::align() %>%
      paste(
        res %>%
          pillar::align(),
        res_message %>%
          pillar::align(),
        sep = " | "
      ) %>%
      paste(collapse = "\n") %>%
      message("\n")

    stop("missing generics, please implement all required generic functions for class '", class_name, "'")
  }

  # get column names
  col_names <- column_names(lazy_table_impl)

  meta <- list(
    lt_impl = lazy_table_impl,
    cols = col_names
  )

  res <- as.list(seq_len(length(col_names)))
  names(res) <- col_names

  header <- as.data.frame(res)

  class(res) <- "lazy_table"
  attr(res, "meta") <- meta
  attr(res, "cols") <- header

  res
}
