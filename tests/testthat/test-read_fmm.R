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

# --- error path tests ---

test_that("fmm_to_vec errors on non-existent file", {
  expect_error(fmm_to_vec("/no/such/path/fake.mtx"))
})

test_that("fmm_to_mat errors on non-existent file", {
  expect_error(fmm_to_mat("/no/such/path/fake.mtx"))
})

test_that("fmm_to_sparse_Matrix errors on non-existent file", {
  expect_error(fmm_to_sparse_Matrix("/no/such/path/fake.mtx"))
})

# --- precision and edge case tests ---

test_that("fmm_to_vec roundtrips double values with precision", {
  temp_path <- temp_path_fixture()
  dbl_vec <- c(1.5, -0.0001, 9999.9999)
  write_fmm(dbl_vec, temp_path("dbl_vec.mtx"))
  result <- fmm_to_vec(temp_path("dbl_vec.mtx"))
  expect_equal(result, dbl_vec)
})

test_that("fmm_to_mat roundtrips double values exactly", {
  temp_path <- temp_path_fixture()
  dbl_mat <- matrix(c(1.5, 2.7, -3.3, 4.1e10), nrow = 2)
  write_fmm(dbl_mat, temp_path("dbl_mat.mtx"))
  result <- fmm_to_mat(temp_path("dbl_mat.mtx"))
  expect_equal(result, dbl_mat)
})

test_that("fmm_to_vec roundtrips NaN values", {
  temp_path <- temp_path_fixture()
  nan_vec <- c(1.0, NaN, 3.0)
  write_fmm(nan_vec, temp_path("nan_vec.mtx"))
  result <- fmm_to_vec(temp_path("nan_vec.mtx"))
  expect_true(is.nan(result[2]))
  expect_equal(result[1], 1.0)
  expect_equal(result[3], 3.0)
})

test_that("fmm_to_mat roundtrips NaN values", {
  temp_path <- temp_path_fixture()
  nan_mat <- matrix(c(NaN, 2.0, 3.0, NaN), nrow = 2)
  write_fmm(nan_mat, temp_path("nan_mat.mtx"))
  result <- fmm_to_mat(temp_path("nan_mat.mtx"))
  expect_true(is.nan(result[1, 1]))
  expect_true(is.nan(result[2, 2]))
  expect_equal(result[2, 1], 2.0)
  expect_equal(result[1, 2], 3.0)
})

test_that("fmm_to_vec handles single-element vector", {
  temp_path <- temp_path_fixture()
  single_vec <- c(42.0)
  write_fmm(single_vec, temp_path("single_vec.mtx"))
  result <- fmm_to_vec(temp_path("single_vec.mtx"))
  expect_equal(result, single_vec)
})

test_that("fmm_to_mat handles 1x1 matrix", {
  temp_path <- temp_path_fixture()
  one_mat <- matrix(7.0, nrow = 1, ncol = 1)
  write_fmm(one_mat, temp_path("one_mat.mtx"))
  result <- fmm_to_mat(temp_path("one_mat.mtx"))
  expect_equal(result, one_mat)
})

test_that("fmm_to_sparse_Matrix handles larger sparse matrix", {
  temp_path <- temp_path_fixture()
  set.seed(42)
  n <- 50
  nnz <- 30
  rows <- sample(1:n, nnz, replace = TRUE)
  cols <- sample(1:n, nnz, replace = TRUE)
  vals <- runif(nnz, min = 1, max = 100)
  big_sparse <- sparseMatrix(i = rows, j = cols, x = vals, dims = c(n, n))
  write_fmm(big_sparse, temp_path("big_sparse.mtx"))
  result <- fmm_to_sparse_Matrix(temp_path("big_sparse.mtx"))
  expect_true(inherits(result, "dgCMatrix"))
  expect_equal(result@Dim, big_sparse@Dim)
})

test_that("fmm_to_vec roundtrips Inf values", {
  temp_path <- temp_path_fixture()
  inf_vec <- c(Inf, -Inf, 0.0)
  write_fmm(inf_vec, temp_path("inf_vec.mtx"))
  result <- fmm_to_vec(temp_path("inf_vec.mtx"))
  expect_equal(result[1], Inf)
  expect_equal(result[2], -Inf)
  expect_equal(result[3], 0.0)
})

test_that("fmm_to_sparse_Matrix roundtrips through write_fmm and back", {
  temp_path <- temp_path_fixture()
  sp <- sparseMatrix(
    i = c(1, 2, 3, 5),
    j = c(2, 3, 4, 5),
    x = c(10.5, 20.3, 30.1, 40.9),
    dims = c(5, 5)
  )
  write_fmm(sp, temp_path("sp_roundtrip.mtx"))
  result <- fmm_to_sparse_Matrix(temp_path("sp_roundtrip.mtx"))
  expect_equal(result@x, sp@x)
  expect_equal(result@i, sp@i)
  expect_equal(result@p, sp@p)
})

# --- gzip roundtrip tests ---

test_that("fmm_to_vec reads .mtx.gz files", {
  temp_path <- temp_path_fixture()
  vec <- c(1, 2, 3)
  write_fmm(vec, temp_path("vec.mtx.gz"))
  result <- fmm_to_vec(temp_path("vec.mtx.gz"))
  expect_equal(result, vec)
})

test_that("fmm_to_mat reads .mtx.gz files", {
  temp_path <- temp_path_fixture()
  mat <- matrix(c(1, 2, 3, 4), nrow = 2)
  write_fmm(mat, temp_path("mat.mtx.gz"))
  result <- fmm_to_mat(temp_path("mat.mtx.gz"))
  expect_equal(result, mat)
})

test_that("fmm_to_sparse_Matrix reads .mtx.gz files", {
  temp_path <- temp_path_fixture()
  sp <- Matrix::Matrix(c(1, 0, 0, 2), nrow = 2, sparse = TRUE)
  write_fmm(sp, temp_path("sp.mtx.gz"))
  result <- fmm_to_sparse_Matrix(temp_path("sp.mtx.gz"))
  expect_true(all(sp == result))
})

test_that("integer vector roundtrips through .mtx.gz", {
  temp_path <- temp_path_fixture()
  ivec <- c(1L, 2L, 3L)
  write_fmm(ivec, temp_path("ivec.mtx.gz"))
  result <- fmm_to_vec(temp_path("ivec.mtx.gz"))
  expect_equal(result, ivec)
})

test_that("integer matrix roundtrips through .mtx.gz", {
  temp_path <- temp_path_fixture()
  imat <- matrix(c(1L, 2L, 3L, 4L), nrow = 2)
  write_fmm(imat, temp_path("imat.mtx.gz"))
  result <- fmm_to_mat(temp_path("imat.mtx.gz"))
  expect_equal(result, imat)
})
