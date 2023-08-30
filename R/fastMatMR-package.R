## usethis namespace: start
#' @useDynLib fastMatMR, .registration = TRUE
## usethis namespace: end
#' @export vec_to_fmm
#' @export mat_to_fmm
NULL

#' Convert Various Numeric Types to Matrix Market Format
#'
#' This function takes different types of numeric inputs—vectors, matrices, and sparse matrices—
#' and converts them into Matrix Market files. The output file is written to disk.
#'
#' @param input A numeric object to be converted. This can be a numeric vector, a matrix, or a sparse matrix.
#' @param fname The name of the output file where the Matrix Market formatted data will be saved.
#'             It is recommended to use a filename ending with ".mtx" for clarity.
#'
#' @return This function has no return value. It writes a Matrix Market formatted file to disk.
#'
#' @examples
#' \dontrun{
#' vec <- c(1, 2, 3)
#' mat <- matrix(c(1, 2, 3, 4), nrow = 2)
#'
#' writeFMM(vec, "vector.mtx")
#' writeFMM(mat, "matrix.mtx")
#' }
#'
#' @export
writeFMM <- function(input, fname = "out.mtx") {
  if (is.vector(input)) {
    return(vec_to_fmm(input, fname))
  } else if (is.matrix(input)) {
    return(mat_to_fmm(input, fname))
  } else {
    stop("Unsupported input type. Accepted types are numeric vector, matrix.")
  }
}
