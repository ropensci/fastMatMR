## usethis namespace: start
#' @useDynLib fastMatMR, .registration = TRUE
## usethis namespace: end
#' @export vec_to_fmm
#' @export mat_to_fmm
#' @export sparse_to_fmm
NULL

#' Convert Various Numeric Types to Matrix Market Format
#'
#' This function takes different types of numeric inputs—vectors, matrices, and
#' sparse matrices— and converts them into Matrix Market files. The output file
#' is written to disk.
#'
#' @param input A numeric object to be converted. This can be a numeric vector,
#'   a matrix, or a sparse matrix.  @param fname The name of the output file
#'   where the Matrix Market formatted data will be saved.  It is recommended to
#'   use a filename ending with ".mtx" for clarity.
#'
#' @return This function has no return value. It writes a Matrix Market
#'   formatted file to disk.
#'
#' @examples
#' \dontrun{
#' vec <- c(1, 2, 3)
#' mat <- matrix(c(1, 2, 3, 4), nrow = 2)
#' sparse_mat <- Matrix::Matrix(c(1, 0, 0, 2), nrow = 2, sparse = TRUE)
#' ## Diagonal ^-
#' sparse_mat <- Matrix::Matrix(c(1, 1, 0, 2), nrow = 2, sparse = TRUE)
#' ## And not diagonal -^
#'
#' write_fmm(vec, "vector.mtx")
#' write_fmm(mat, "matrix.mtx")
#' write_fmm(sparse_mat, "sparse_matrix.mtx")
#' }
#'
#' @export
write_fmm <- function(input, fname = "out.mtx") {
  if (is.vector(input)) {
    return(vec_to_fmm(input, fname)) # nolint. C++ function.
  } else if (is.matrix(input)) {
    return(mat_to_fmm(input, fname)) # nolint. C++ function.
  } else if (inherits(input, "sparseMatrix")) {
    return(sparse_to_fmm(input, fname)) # nolint. C++ function.
  } else {
    stop(
      paste(
        "Unsupported input type.",
        "Accepted types are numeric vector, matrix, and sparseMatrix."
      )
    )
  }
}
