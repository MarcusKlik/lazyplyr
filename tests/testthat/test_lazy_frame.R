
context("lazy_frame")


test_that("constructor", {

  lf <- lazy_frame(
    X = 1:10,
    Y = LETTERS[2:11]
  )

  expect_equal(class(lf), "lazy_table")
})
