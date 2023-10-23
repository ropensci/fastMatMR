library(Matrix) # for sparseMatrix

test_that("fmm_to_vec returns correct output", {
  temp_path <- temp_path_fixture()

  example_vec <- c(1, 2, 3)
  write_fmm(example_vec, temp_path("example_vec.mtx"))

  result_vec <- fmm_to_vec(temp_path("example_vec.mtx"))
  expect_equal(result_vec, example_vec)
})

test_that("fmm_to_mat returns correct output", {
  temp_path <- temp_path_fixture()

  example_mat <- matrix(runif(n = 6, min = 1, max = 20), nrow = 3)
  write_fmm(example_mat, temp_path("example_mat.mtx"))

  result_mat <- fmm_to_mat(temp_path("example_mat.mtx"))
  expect_equal(result_mat, example_mat, tolerance = 1e-7)
})

test_that("fmm_to_sparse_Matrix returns correct output", {
  temp_path <- temp_path_fixture()

  example_sparse_mat <- sparseMatrix(
    i = c(1, 3, 2, 4),
    j = c(1, 3, 3, 4),
    x = c(4, 3, 1, 6)
  )
  writeMM(example_sparse_mat, temp_path("example_sparse_mat.mtx"))

  result_sparse_mat <- fmm_to_sparse_Matrix(temp_path("example_sparse_mat.mtx"))
  expect_equal(result_sparse_mat@x, example_sparse_mat@x)
  expect_equal(result_sparse_mat@i, example_sparse_mat@i)
  expect_equal(result_sparse_mat@p, example_sparse_mat@p)
  expect_equal(result_sparse_mat@Dim, example_sparse_mat@Dim)
})

test_that("fmm_to_vec returns correct output for integer vectors", {
  temp_path <- temp_path_fixture()

  example_intvec <- c(1L, 2L, 3L)
  write_fmm(example_intvec, temp_path("example_intvec.mtx"))

  result_intvec <- fmm_to_vec(temp_path("example_intvec.mtx"))
  expect_equal(result_intvec, example_intvec)
})

test_that("fmm_to_mat returns correct output for integer matrices", {
  temp_path <- temp_path_fixture()

  example_intmat <- matrix(c(1L, 2L, 3L, 4L, 5L, 6L), nrow = 3)
  write_fmm(example_intmat, temp_path("example_intmat.mtx"))

  result_intmat <- fmm_to_mat(temp_path("example_intmat.mtx"))
  expect_equal(result_intmat, example_intmat)
})

test_that("fmm_to_sparse_Matrix reads Matrix Market file correctly", {
  temp_path <- temp_path_fixture()
  original_sparsemat <- Matrix::Matrix(c(1, 0, 0, 2), nrow = 2, sparse = TRUE)
  writeMM(original_sparsemat, temp_path("test_sparse_matrix.mtx"))
  read_sparsemat <- fmm_to_sparse_Matrix(temp_path("test_sparse_matrix.mtx"))
  expect_true(inherits(read_sparsemat, "dgCMatrix"))
  expect_true(all(original_sparsemat == read_sparsemat))
})
