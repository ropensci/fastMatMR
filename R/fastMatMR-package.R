## usethis namespace: start
#' @useDynLib fastMatMR, .registration = TRUE
## usethis namespace: end

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
  result <- cpp_fmm_to_vec(expanded_filename)
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
  result <- cpp_fmm_to_mat(expanded_filename)
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
  result <- cpp_fmm_to_sparse_Matrix(expanded_filename)
  return(result)
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
  if (is.vector(input)) {
    if (is.integer(input)) {
      return(intvec_to_fmm(input, expanded_fname)) # nolint. C++ function.
    } else {
      return(vec_to_fmm(input, expanded_fname)) # nolint. C++ function.
    }
  } else if (is.matrix(input)) {
    if (is.integer(input)) {
      return(intmat_to_fmm(input, expanded_fname)) # nolint. C++ function.
    } else {
      return(mat_to_fmm(input, expanded_fname)) # nolint. C++ function.
    }
  } else if (inherits(input, "sparseMatrix")) {
    return(sparse_Matrix_to_fmm(input, expanded_fname)) # nolint. C++ function.
  } else {
    stop(
      paste(
        "Unsupported input type.",
        "Accepted types are numeric vector,",
        " integer vector, matrix, and sparseMatrix."
      )
    )
  }
}
