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
