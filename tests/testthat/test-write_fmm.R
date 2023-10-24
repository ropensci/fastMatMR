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

test_that("intvec_to_fmm works with integer vectors", {
  temp_path <- temp_path_fixture()

  intvec <- c(1L, 2L, 3L)
  expect_true(intvec_to_fmm(intvec, temp_path("intvector.mtx")))
})

test_that("intmat_to_fmm works with integer matrices", {
  temp_path <- temp_path_fixture()

  intmat <- matrix(c(1L, 2L, 3L, 4L), nrow = 2)
  expect_true(intmat_to_fmm(intmat, temp_path("intmatrix.mtx")))
})

test_that("write_fmm works with integer vectors", {
  temp_path <- temp_path_fixture()

  intvec <- c(1L, 2L, 3L)
  expect_true(write_fmm(intvec, temp_path("write_intvector.mtx")))
})

test_that("write_fmm works with integer matrices", {
  temp_path <- temp_path_fixture()

  intmat <- matrix(c(1L, 2L, 3L, 4L), nrow = 2)
  expect_true(write_fmm(intmat, temp_path("write_intmatrix.mtx")))
})

test_that("Integer matrix roundtrip equivalence", {
  temp_path <- temp_path_fixture()

  original_intmat <- matrix(c(1L, 2L, 3L, 4L), nrow = 2)
  write_fmm(original_intmat, temp_path("int_sparse.mtx"))
  read_intmat <- fmm_to_sparse_Matrix(temp_path("int_sparse.mtx"))
  expect_true(all(original_intmat == read_intmat))
})

test_that("sparse_Matrix_to_fmm works with sparse numeric matrices", {
  temp_path <- temp_path_fixture()

  sparse_mat <- Matrix::Matrix(c(1, 0, 0, 2), nrow = 2, sparse = TRUE)
  expect_true(sparse_Matrix_to_fmm(sparse_mat, temp_path("direct_sparse.mtx")))
})
