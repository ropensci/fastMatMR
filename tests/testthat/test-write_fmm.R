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

# --- SparseM tests ---

test_that("SparseM roundtrip works via write_fmm dispatcher", {
  skip_if_not_installed("SparseM")
  temp_path <- temp_path_fixture()
  csr <- SparseM::as.matrix.csr(matrix(c(1, 0, 0, 2), nrow = 2))
  expect_true(write_fmm(csr, temp_path("sparsem.mtx")))
  result <- fmm_to_SparseM(temp_path("sparsem.mtx"))
  expect_true(inherits(result, "matrix.csr"))
  expect_equal(result@ra, csr@ra)
  expect_equal(result@ja, csr@ja)
  expect_equal(result@ia, csr@ia)
  expect_equal(result@dimension, csr@dimension)
})

test_that("SparseM_to_fmm and fmm_to_SparseM roundtrip", {
  skip_if_not_installed("SparseM")
  temp_path <- temp_path_fixture()
  csr <- SparseM::as.matrix.csr(matrix(c(5, 0, 3, 0, 0, 7, 0, 1, 0), nrow = 3))
  expect_true(SparseM_to_fmm(csr, temp_path("sparsem_direct.mtx")))
  result <- fmm_to_SparseM(temp_path("sparsem_direct.mtx"))
  expect_equal(result@ra, csr@ra)
  expect_equal(result@ja, csr@ja)
  expect_equal(result@ia, csr@ia)
  expect_equal(result@dimension, csr@dimension)
})

# --- direct C++ wrapper tests ---

test_that("vec_to_fmm works with double vectors directly", {
  temp_path <- temp_path_fixture()
  dbl_vec <- c(1.1, 2.2, 3.3)
  expect_true(vec_to_fmm(dbl_vec, temp_path("direct_dbl_vec.mtx")))
})

test_that("mat_to_fmm works with double matrices directly", {
  temp_path <- temp_path_fixture()
  dbl_mat <- matrix(c(1.1, 2.2, 3.3, 4.4), nrow = 2)
  expect_true(mat_to_fmm(dbl_mat, temp_path("direct_dbl_mat.mtx")))
})

# --- write_fmm dispatcher tests ---

test_that("write_fmm dispatches correctly for double vector", {
  temp_path <- temp_path_fixture()
  dbl_vec <- c(10.5, 20.5, 30.5)
  expect_true(write_fmm(dbl_vec, temp_path("dispatch_dbl_vec.mtx")))
  result <- fmm_to_vec(temp_path("dispatch_dbl_vec.mtx"))
  expect_equal(result, dbl_vec)
})

test_that("write_fmm dispatches correctly for integer vector", {
  temp_path <- temp_path_fixture()
  int_vec <- c(10L, 20L, 30L)
  expect_true(write_fmm(int_vec, temp_path("dispatch_int_vec.mtx")))
  result <- fmm_to_vec(temp_path("dispatch_int_vec.mtx"))
  expect_equal(result, int_vec)
})

test_that("write_fmm dispatches correctly for double matrix", {
  temp_path <- temp_path_fixture()
  dbl_mat <- matrix(c(1.5, 2.5, 3.5, 4.5), nrow = 2)
  expect_true(write_fmm(dbl_mat, temp_path("dispatch_dbl_mat.mtx")))
  result <- fmm_to_mat(temp_path("dispatch_dbl_mat.mtx"))
  expect_equal(result, dbl_mat)
})

test_that("write_fmm dispatches correctly for integer matrix", {
  temp_path <- temp_path_fixture()
  int_mat <- matrix(c(10L, 20L, 30L, 40L), nrow = 2)
  expect_true(write_fmm(int_mat, temp_path("dispatch_int_mat.mtx")))
  result <- fmm_to_mat(temp_path("dispatch_int_mat.mtx"))
  expect_equal(result, int_mat)
})

test_that("write_fmm dispatches correctly for sparse matrix", {
  temp_path <- temp_path_fixture()
  sp <- sparseMatrix(i = c(1, 2), j = c(2, 3), x = c(5.5, 6.6), dims = c(3, 3))
  expect_true(write_fmm(sp, temp_path("dispatch_sparse.mtx")))
  result <- fmm_to_sparse_Matrix(temp_path("dispatch_sparse.mtx"))
  expect_equal(result@x, sp@x)
})

# --- error path tests ---

test_that("write_fmm errors with list input", {
  temp_path <- temp_path_fixture()
  expect_error(write_fmm(list(1, 2, 3), temp_path("list.mtx")))
})

test_that("write_fmm errors with logical vector", {
  temp_path <- temp_path_fixture()
  expect_error(write_fmm(c(TRUE, FALSE), temp_path("logical.mtx")))
})

# --- roundtrip precision tests ---

test_that("vec_to_fmm roundtrip preserves values", {
  temp_path <- temp_path_fixture()
  original <- c(0.0, -1.5, 1e-15, 1e15)
  vec_to_fmm(original, temp_path("vec_roundtrip.mtx"))
  result <- fmm_to_vec(temp_path("vec_roundtrip.mtx"))
  expect_equal(result, original)
})

test_that("mat_to_fmm roundtrip preserves values", {
  temp_path <- temp_path_fixture()
  original <- matrix(c(0.0, -1.5, 1e-15, 1e15), nrow = 2)
  mat_to_fmm(original, temp_path("mat_roundtrip.mtx"))
  result <- fmm_to_mat(temp_path("mat_roundtrip.mtx"))
  expect_equal(result, original)
})

test_that("write_fmm uses default filename argument", {
  temp_path <- temp_path_fixture()
  vec <- c(1, 2, 3)
  outfile <- temp_path("explicit_name.mtx")
  expect_true(write_fmm(vec, outfile))
  expect_true(file.exists(outfile))
})

test_that("intvec_to_fmm roundtrip preserves integer values", {
  temp_path <- temp_path_fixture()
  original <- c(0L, -1L, 100L, 999L)
  intvec_to_fmm(original, temp_path("intvec_roundtrip.mtx"))
  result <- fmm_to_vec(temp_path("intvec_roundtrip.mtx"))
  expect_equal(result, original)
})

test_that("intmat_to_fmm roundtrip preserves integer matrix values", {
  temp_path <- temp_path_fixture()
  original <- matrix(c(0L, -1L, 100L, 999L), nrow = 2)
  intmat_to_fmm(original, temp_path("intmat_roundtrip.mtx"))
  result <- fmm_to_mat(temp_path("intmat_roundtrip.mtx"))
  expect_equal(result, original)
})

# --- gzip write tests ---

test_that("write_fmm produces a valid .gz file", {
  temp_path <- temp_path_fixture()
  vec <- c(1, 2, 3)
  expect_true(write_fmm(vec, temp_path("vec.mtx.gz")))
  expect_true(file.exists(temp_path("vec.mtx.gz")))
  raw <- readBin(temp_path("vec.mtx.gz"), "raw", n = 2)
  expect_equal(raw, as.raw(c(0x1f, 0x8b)))
})

test_that("write_fmm to .mtx.gz works for all types", {
  temp_path <- temp_path_fixture()
  expect_true(write_fmm(c(1, 2), temp_path("v.mtx.gz")))
  expect_true(write_fmm(c(1L, 2L), temp_path("iv.mtx.gz")))
  expect_true(write_fmm(matrix(1:4, 2), temp_path("im.mtx.gz")))
  expect_true(write_fmm(matrix(c(1, 2, 3, 4), 2), temp_path("m.mtx.gz")))
  sp <- Matrix::Matrix(c(1, 0, 0, 2), nrow = 2, sparse = TRUE)
  expect_true(write_fmm(sp, temp_path("sp.mtx.gz")))
})

# --- spam support tests ---

test_that("spam roundtrip works via write_fmm dispatcher", {
  skip_if_not_installed("spam")
  temp_path <- temp_path_fixture()
  sp <- spam::spam(c(1, 0, 0, 2), nrow = 2)
  expect_true(write_fmm(sp, temp_path("spam.mtx")))
  result <- fmm_to_spam(temp_path("spam.mtx"))
  expect_true(inherits(result, "spam"))
  expect_equal(as.matrix(result), as.matrix(sp))
})

test_that("spam_to_fmm and fmm_to_spam work directly", {
  skip_if_not_installed("spam")
  temp_path <- temp_path_fixture()
  sp <- spam::spam(c(1, 0, 0, 2), nrow = 2)
  expect_true(spam_to_fmm(sp, temp_path("spam_direct.mtx")))
  result <- fmm_to_spam(temp_path("spam_direct.mtx"))
  expect_true(inherits(result, "spam"))
  expect_equal(as.matrix(result), as.matrix(sp))
})
