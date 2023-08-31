library(testthat)
library(Matrix) # for sparseMatrix

test_that("write_fmm works with numeric vectors", {
  vec <- c(1, 2, 3)
  expect_true(write_fmm(vec, "vector.mtx"))
})

test_that("write_fmm works with numeric matrices", {
  mat <- matrix(c(1, 2, 3, 4), nrow = 2)
  expect_true(write_fmm(mat, "matrix.mtx"))
})

test_that("write_fmm works with sparseMatrix objects", {
  sp_mat <- sparseMatrix(i = c(1, 3), j = c(2, 4), x = 7:8)
  expect_true(write_fmm(sp_mat, "sparse.mtx"))
})

test_that("write_fmm fails with unsupported types", {
  df <- data.frame(a = c(1, 2), b = c(3, 4))
  expect_error(write_fmm(df), "Unsupported input type*")
  char_vec <- c("a", "b", "c")
  expect_error(write_fmm(char_vec), "Invalid input*")
})

test_that("Sparse matrix roundtrip equivalence", {
  original_spmat <- Matrix(c(1, 0, 3, 2), nrow = 2, sparse = TRUE)
  write_fmm(original_spmat, "sparse.mtx")
  read_spmat <- Matrix::readMM("sparse.mtx")
  expect_true(all(original_spmat == read_spmat))
})

test_that("Sparse matrix diagonal equivalence", {
  original_spmat <- sparse_mat <- Matrix::Matrix(c(1, 0, 0, 2),
    nrow = 2, sparse = TRUE
  )
  write_fmm(original_spmat, "sparse.mtx")
  read_spmat <- Matrix::readMM("sparse.mtx")
  expect_true(all(original_spmat == read_spmat))
})
