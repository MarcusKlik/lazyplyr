
context("lazy_frame")

lazy_table_impl <- structure(
  list(data =
         data.frame(
           X = 1:10,
           Y = LETTERS[2:11]
         )),
  class = "lazy_test"
)


test_that("constructor", {
  expect_error(lazy_table(lazy_table_impl))
})


column_names.lazy_test <- function(x) {  # nolint
  "column"
}


read_row_index.lazy_test <- function(x, col_name, index) {  # nolint
  NULL
}


read_row_range.lazy_test <- function(x, col_name, from, length) {  # nolint
  NULL
}
