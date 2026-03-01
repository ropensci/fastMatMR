## usethis namespace: start
#' @useDynLib fastMatMR, .registration = TRUE
## usethis namespace: end

# Internal helper: decompress a .gz file to a temporary .mtx file.
.maybe_decompress <- function(filename) {
  if (!grepl("\\.gz$", filename)) return(list(path = filename, cleanup = FALSE))
  tmp <- tempfile(fileext = ".mtx")
  input <- gzfile(filename, "rb")
  output <- file(tmp, "wb")
  on.exit({close(input); close(output)})
  repeat {
    chunk <- readBin(input, "raw", n = 65536L)
    if (length(chunk) == 0L) break
    writeBin(chunk, output)
  }
  list(path = tmp, cleanup = TRUE)
}

# Internal helper: compress a .mtx file to .gz.
.compress_to_gz <- function(source, dest) {
  input <- file(source, "rb")
  output <- gzfile(dest, "wb")
  on.exit({close(input); close(output)})
  repeat {
    chunk <- readBin(input, "raw", n = 65536L)
    if (length(chunk) == 0L) break
    writeBin(chunk, output)
  }
  unlink(source)
  invisible(TRUE)
}

#' @export fmm_to_vec
#' @rdname fmm_to_vec
#' @name fmm_to_vec
#' @title Convert Matrix Market File to Numeric Vector
#' @description This function reads a Matrix Market file and converts it to a
#'   numeric vector in R.
#' @param filename The name of the input Matrix Market file to be read.
#' @return A numeric vector containing the data read from the Matrix Market
#'   file.
#' @examples
#' # Create
#' sample_vec <- c(1, 2, 3)
#' temp_file_vec <- tempfile(fileext = ".mtx")
#' write_fmm(sample_vec, temp_file_vec)
#' # Read
#' vec <- fmm_to_vec(temp_file_vec)
fmm_to_vec <- function(filename) {
  expanded_filename <- path.expand(filename)
  info <- .maybe_decompress(expanded_filename)
  on.exit(if (info$cleanup) unlink(info$path))
  result <- cpp_fmm_to_vec(info$path)
  return(result)
}

#' @export fmm_to_mat
#' @rdname fmm_to_mat
#' @name fmm_to_mat
#' @title Convert Matrix Market File to Matrix
#' @description This function reads a Matrix Market file and converts it to a
#'   matrix in R.
#' @param filename The name of the input Matrix Market file to be read.
#' @return A matrix containing the data read from the Matrix Market file.
#' @examples
#' # Create
#' sample_mat <- matrix(c(1, 2, 3, 4), nrow = 2)
#' temp_file_mat <- tempfile(fileext = ".mtx")
#' write_fmm(sample_mat, temp_file_mat)
#' # Read
#' mat <- fmm_to_mat(temp_file_mat)
fmm_to_mat <- function(filename) {
  expanded_filename <- path.expand(filename)
  info <- .maybe_decompress(expanded_filename)
  on.exit(if (info$cleanup) unlink(info$path))
  result <- cpp_fmm_to_mat(info$path)
  return(result)
}

#' @export fmm_to_sparse_Matrix
#' @rdname fmm_to_sparse_Matrix
#' @name fmm_to_sparse_Matrix
#' @title Convert Matrix Market File to Sparse Matrix
#' @description This function reads a Matrix Market file and converts it to a
#'   sparse matrix in R using the Matrix package.
#' @param filename The name of the input Matrix Market file to be read.
#' @return A dgCMatrix object containing the data read from the Matrix Market
#'   file.
#' @examples
#' # Create
#' sample_sparse_mat <- Matrix::Matrix(c(1, 0, 0, 2), nrow = 2, sparse = TRUE)
#' temp_file <- tempfile(fileext = ".mtx")
#' write_fmm(sample_sparse_mat, temp_file)
#' # Read
#' sparse_mat <- fmm_to_sparse_Matrix(temp_file)
fmm_to_sparse_Matrix <- function(filename) {
  expanded_filename <- path.expand(filename)
  info <- .maybe_decompress(expanded_filename)
  on.exit(if (info$cleanup) unlink(info$path))
  result <- cpp_fmm_to_sparse_Matrix(info$path)
  return(result)
}

#' @export fmm_to_spam
#' @rdname fmm_to_spam
#' @name fmm_to_spam
#' @title Convert Matrix Market File to spam Sparse Matrix
#' @description This function reads a Matrix Market file and converts it to a
#'   sparse matrix using the spam package.
#' @param filename The name of the input Matrix Market file to be read.
#' @return A spam object containing the data read from the Matrix Market file.
#' @examplesIf requireNamespace("spam", quietly = TRUE)
#' sample_sparse <- Matrix::Matrix(c(1, 0, 0, 2), nrow = 2, sparse = TRUE)
#' tmp <- tempfile(fileext = ".mtx")
#' write_fmm(sample_sparse, tmp)
#' sp <- fmm_to_spam(tmp)
fmm_to_spam <- function(filename) {
  if (!requireNamespace("spam", quietly = TRUE)) {
    stop("Package 'spam' is required for this function.")
  }
  dgc <- fmm_to_sparse_Matrix(filename)
  tri <- Matrix::summary(dgc)
  spam::spam(
    list(i = tri$i, j = tri$j, values = tri$x),
    nrow = nrow(dgc), ncol = ncol(dgc)
  )
}

#' @export spam_to_fmm
#' @rdname spam_to_fmm
#' @name spam_to_fmm
#' @title Convert a spam Sparse Matrix to Matrix Market Format
#' @description This function takes a spam sparse matrix and converts it into a
#'   Matrix Market file.
#' @param input A spam sparse matrix to be converted.
#' @param filename The name of the output file where the Matrix Market formatted
#'   data will be saved.
#' @return A boolean indicating success or failure. Writes a MTX file to disk.
#' @examplesIf requireNamespace("spam", quietly = TRUE)
#' sp <- spam::spam(c(1, 0, 0, 2), nrow = 2)
#' spam_to_fmm(sp, tempfile(fileext = ".mtx"))
spam_to_fmm <- function(input, filename) {
  if (!requireNamespace("spam", quietly = TRUE)) {
    stop("Package 'spam' is required for this function.")
  }
  if (!requireNamespace("Matrix", quietly = TRUE)) {
    stop("Package 'Matrix' is required for this function.")
  }
  trip <- spam::triplet(input)
  dgc <- Matrix::sparseMatrix(
    i = trip$indices[, 1],
    j = trip$indices[, 2],
    x = trip$values,
    dims = input@dimension
  )
  sparse_Matrix_to_fmm(dgc, filename)
}

#' @export fmm_to_SparseM
#' @rdname fmm_to_SparseM
#' @name fmm_to_SparseM
#' @title Convert Matrix Market File to SparseM matrix.csr
#' @description This function reads a Matrix Market file and converts it to a
#'   matrix.csr object using the SparseM package.
#' @param filename The name of the input Matrix Market file to be read.
#' @return A matrix.csr object containing the data read from the Matrix Market
#'   file.
#' @examplesIf requireNamespace("SparseM", quietly = TRUE)
#' sample_sparse <- Matrix::Matrix(c(1, 0, 0, 2), nrow = 2, sparse = TRUE)
#' tmp <- tempfile(fileext = ".mtx")
#' write_fmm(sample_sparse, tmp)
#' csr <- fmm_to_SparseM(tmp)
fmm_to_SparseM <- function(filename) {
  if (!requireNamespace("SparseM", quietly = TRUE)) {
    stop("Package 'SparseM' is required for this function.")
  }
  dgc <- fmm_to_sparse_Matrix(filename)
  tri <- Matrix::summary(dgc)
  nr <- dgc@Dim[1]
  ord <- order(tri$i, tri$j)
  ra <- tri$x[ord]
  ja <- as.integer(tri$j[ord])
  ia <- c(1L, cumsum(tabulate(tri$i[ord], nbins = nr)) + 1L)
  methods::new("matrix.csr", ra = ra, ja = ja, ia = ia, dimension = dgc@Dim)
}

#' @export SparseM_to_fmm
#' @rdname SparseM_to_fmm
#' @name SparseM_to_fmm
#' @title Convert a SparseM matrix.csr to Matrix Market Format
#' @description This function takes a SparseM matrix.csr and converts it into a
#'   Matrix Market file.
#' @param input A matrix.csr object to be converted.
#' @param filename The name of the output file where the Matrix Market formatted
#'   data will be saved.
#' @return A boolean indicating success or failure. Writes a MTX file to disk.
#' @examplesIf requireNamespace("SparseM", quietly = TRUE)
#' csr <- SparseM::as.matrix.csr(matrix(c(1, 0, 0, 2), nrow = 2))
#' SparseM_to_fmm(csr, tempfile(fileext = ".mtx"))
SparseM_to_fmm <- function(input, filename) {
  if (!requireNamespace("SparseM", quietly = TRUE)) {
    stop("Package 'SparseM' is required for this function.")
  }
  if (!requireNamespace("Matrix", quietly = TRUE)) {
    stop("Package 'Matrix' is required for this function.")
  }
  dims <- input@dimension
  rows <- rep(seq_len(dims[1]), diff(input@ia))
  dgc <- Matrix::sparseMatrix(i = rows, j = input@ja, x = input@ra, dims = dims)
  sparse_Matrix_to_fmm(dgc, filename)
}

#' @export vec_to_fmm
#' @rdname vec_to_fmm
#' @name vec_to_fmm
#' @title Convert a Numeric Vector to Matrix Market Format
#' @description This function takes a numeric vector and converts it into a
#'   Matrix Market output file.
#' @param input A numeric vector to be converted.
#' @param filename The name of the output file where the Matrix Market formatted
#'   data will be saved.
#' @return A boolean indicating success or failure. Writes a MTX file to disk.
#' @examples
#' vec <- c(1, 2, 3)
#' vec_to_fmm(vec, tempfile(fileext = ".mtx"))
NULL

#' @export intvec_to_fmm
#' @rdname intvec_to_fmm
#' @name intvec_to_fmm
#' @title Convert a numeric integer vector to Matrix Market Format
#' @description This function takes a numeric intvector and converts it into a
#'   Matrix Market output file.
#' @param input A numeric integer vector to be converted.
#' @param filename The name of the output file where the Matrix Market formatted
#'   data will be saved.
#' @return A boolean indicating success or failure. Writes a MTX file to disk.
#' @examples
#' intvec <- c(1L, 2L, 3L)
#' intvec_to_fmm(intvec, tempfile(fileext = ".mtx"))
NULL

#' @export mat_to_fmm
#' @rdname mat_to_fmm
#' @name mat_to_fmm
#' @title Convert a Numeric Matrix to Matrix Market Format
#' @description This function takes a numeric matrix and converts it into a
#'   Matrix Market file.
#' @param input A numeric matrix to be converted.
#' @param filename The name of the output file where the Matrix Market formatted
#'   data will be saved.
#' @return A boolean indicating success or failure. Writes a MTX file to disk.
#' @examples
#' mat <- matrix(c(1, 2, 3, 4), nrow = 2)
#' mat_to_fmm(mat, tempfile(fileext = ".mtx"))
NULL

#' @export intmat_to_fmm
#' @rdname intmat_to_fmm
#' @name intmat_to_fmm
#' @title Convert a Numeric Matrix to Matrix Market Format
#' @description This function takes a numeric matrix and converts it into a
#'   Matrix Market file.
#' @param input A numeric matrix to be converted.
#' @param filename The name of the output file where the Matrix Market formatted
#'   data will be saved.
#' @return A boolean indicating success or failure. Writes a MTX file to disk.
#' @examples
#' intmat <- matrix(c(1L, 2L, 3L, 4L), nrow = 2)
#' intmat_to_fmm(intmat, tempfile(fileext = ".mtx"))
NULL

#' @export sparse_Matrix_to_fmm
#' @rdname sparse_Matrix_to_fmm
#' @name sparse_Matrix_to_fmm
#' @title Convert a Sparse Numeric Matrix to Matrix Market Format
#' @description This function takes a sparse numeric matrix and converts it into
#'   a Matrix Market file.
#' @param input A sparse numeric matrix to be converted.
#' @param filename The name of the output file where the Matrix Market formatted
#'   data will be saved.
#' @return A boolean indicating success or failure. Writes a MTX file to disk.
#' @examples
#' sparse_mat <- Matrix::Matrix(c(1, 0, 0, 2), nrow = 2, sparse = TRUE)
#' sparse_Matrix_to_fmm(sparse_mat, tempfile(fileext = ".mtx"))
NULL

#' Convert Various Numeric Types to Matrix Market Format
#'
#' This function takes different types of numeric inputs—vectors, matrices, and
#' sparse matrices— and converts them into Matrix Market files. The output file
#' is written to disk.
#'
#' @param input A numeric object to be converted. This can be a numeric vector,
#'   a matrix, or a sparse matrix.
#' @param filename The name of the output file
#'   where the Matrix Market formatted data will be saved.  It is recommended to
#'   use a filename ending with ".mtx" for clarity.
#'
#' @return A boolean indicating success or failure. Writes a MTX file to disk.
#'
#' @examples
#' vec <- c(1, 2, 3)
#' mat <- matrix(c(1, 2, 3, 4), nrow = 2)
#' sparse_mat_diag <- Matrix::Matrix(c(1, 0, 0, 2), nrow = 2, sparse = TRUE)
#' ## Diagonal ^-
#' sparse_mat <- Matrix::Matrix(c(1, 1, 0, 2), nrow = 2, sparse = TRUE)
#' ## And not diagonal -^
#' write_fmm(vec, tempfile(fileext = ".mtx"))
#' write_fmm(mat, tempfile(fileext = ".mtx"))
#' write_fmm(sparse_mat_diag, tempfile(fileext = ".mtx"))
#' write_fmm(sparse_mat, tempfile(fileext = ".mtx"))
#'
#' @export
write_fmm <- function(input, filename = "out.mtx") {
  # Expand the ~ character to the full path
  expanded_fname <- path.expand(filename)
  gz <- grepl("\\.gz$", expanded_fname)
  if (gz) {
    actual_fname <- tempfile(fileext = ".mtx")
  } else {
    actual_fname <- expanded_fname
  }
  if (is.vector(input)) {
    if (is.integer(input)) {
      ret <- intvec_to_fmm(input, actual_fname) # nolint. C++ function.
    } else {
      ret <- vec_to_fmm(input, actual_fname) # nolint. C++ function.
    }
  } else if (is.matrix(input)) {
    if (is.integer(input)) {
      ret <- intmat_to_fmm(input, actual_fname) # nolint. C++ function.
    } else {
      ret <- mat_to_fmm(input, actual_fname) # nolint. C++ function.
    }
  } else if (inherits(input, "sparseMatrix")) {
    ret <- sparse_Matrix_to_fmm(input, actual_fname) # nolint. C++ function.
  } else if (inherits(input, "spam")) {
    ret <- spam_to_fmm(input, actual_fname)
  } else if (inherits(input, "matrix.csr")) {
    ret <- SparseM_to_fmm(input, actual_fname)
  } else {
    stop(
      paste(
        "Unsupported input type.",
        "Accepted types are numeric vector,",
        " integer vector, matrix, sparseMatrix, and matrix.csr."
      )
    )
  }
  if (gz) .compress_to_gz(actual_fname, expanded_fname)
  return(ret)
}
