library(testthat)
library(Matrix)

# Create a test file for fmm_to_vec
example_vec <- c(1, 2, 3)
write_fmm(example_vec, "example_vec.mtx")

# Create a test file for fmm_to_mat
example_mat <- matrix(runif(n = 6, min = 1, max = 20), nrow = 3)
write_fmm(example_mat, "example_mat.mtx")

# Create a test file for fmm_to_sparse_Matrix
example_sparse_mat <- sparseMatrix(i = c(1, 3, 2, 4),
                                   j = c(1, 3, 3, 4),
                                   x = c(4, 3, 1, 6))
writeMM(example_sparse_mat, "example_sparse_mat.mtx")

# Test for fmm_to_vec
test_that("fmm_to_vec returns correct output", {
  result_vec <- fmm_to_vec("example_vec.mtx")
  expect_equal(result_vec, example_vec)
})

# Test for fmm_to_mat
test_that("fmm_to_mat returns correct output", {
  result_mat <- fmm_to_mat("example_mat.mtx")
  expect_equal(result_mat, example_mat, tolerance = 1e-7)
})

# Test for fmm_to_sparse_Matrix
test_that("fmm_to_sparse_Matrix returns correct output", {
  result_sparse_mat <- fmm_to_sparse_Matrix("example_sparse_mat.mtx")
  expect_equal(result_sparse_mat@x, example_sparse_mat@x)
  expect_equal(result_sparse_mat@i, example_sparse_mat@i)
  expect_equal(result_sparse_mat@p, example_sparse_mat@p)
  expect_equal(result_sparse_mat@Dim, example_sparse_mat@Dim)
})

# Clean up test files
file.remove("example_vec.mtx")
file.remove("example_mat.mtx")
file.remove("example_sparse_mat.mtx")
