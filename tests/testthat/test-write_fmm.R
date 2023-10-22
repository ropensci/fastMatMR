library(Matrix) # for sparseMatrix

test_that("write_fmm works with numeric vectors", {
  temp_path <- temp_path_fixture()

  vec <- c(1, 2, 3)
  expect_true(write_fmm(vec, temp_path("vector.mtx")))
})

test_that("write_fmm works with numeric matrices", {
  temp_path <- temp_path_fixture()

  mat <- matrix(c(1, 2, 3, 4), nrow = 2)
  expect_true(write_fmm(mat, temp_path("matrix.mtx")))
})

test_that("write_fmm works with sparseMatrix objects", {
  temp_path <- temp_path_fixture()

  sp_mat <- sparseMatrix(i = c(1, 3), j = c(2, 4), x = 7:8)
  expect_true(write_fmm(sp_mat, temp_path("sparse.mtx")))
})

test_that("write_fmm fails with unsupported types", {
  temp_path <- temp_path_fixture()

  df <- data.frame(a = c(1, 2), b = c(3, 4))
  expect_error(write_fmm(df, temp_path("df.mtx")), "Unsupported input type*")
  char_vec <- c("a", "b", "c")
  expect_error(write_fmm(char_vec, temp_path("char_vec.mtx")), "Invalid input*")
})

test_that("Sparse matrix roundtrip equivalence", {
  temp_path <- temp_path_fixture()

  original_spmat <- Matrix(c(1, 0, 3, 2), nrow = 2, sparse = TRUE)
  write_fmm(original_spmat, temp_path("sparse.mtx"))
  read_spmat <- Matrix::readMM(temp_path("sparse.mtx"))
  expect_true(all(original_spmat == read_spmat))
})

test_that("Sparse matrix diagonal equivalence", {
  temp_path <- temp_path_fixture()

  original_spmat <- Matrix::Matrix(c(1, 0, 0, 2), nrow = 2, sparse = TRUE)
  write_fmm(original_spmat, temp_path("sparse.mtx"))
  read_spmat <- Matrix::readMM(temp_path("sparse.mtx"))
  expect_true(all(original_spmat == read_spmat))
})
