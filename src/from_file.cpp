#include <chrono>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <vector>

#include "cpp11.hpp"
#include "helpers.h"

#include "../inst/include/fast_matrix_market/fast_matrix_market.hpp"

// TODO: Consider chunking

namespace fmm = fast_matrix_market;

[[cpp11::register]] //
cpp11::doubles
cpp_fmm_to_vec(const std::string &filename) {
  std::ifstream file_stream;
  std::vector<double> vec;

  file_stream.open(filename);
  if (!file_stream) {
    throw std::runtime_error("Failed to open file: " + filename);
  }

  fmm::read_matrix_market_array(file_stream, vec);
  file_stream.close();

  return cpp11::doubles(vec);
}

[[cpp11::register]] //
cpp11::doubles_matrix<>
cpp_fmm_to_mat(const std::string &filename) {
  std::ifstream file_stream;
  fmm::matrix_market_header header;
  std::vector<double> vec;

  file_stream.open(filename);
  if (!file_stream) {
    throw std::runtime_error("Failed to open file: " + filename);
  }

  fmm::read_matrix_market_array(file_stream, header, vec);
  file_stream.close();

  size_t nrows = header.nrows;
  size_t ncols = header.ncols;
  cpp11::writable::doubles_matrix<> mat(nrows, ncols);
  // Fill in the writable matrix in column-major order
  for (size_t j = 0; j < ncols; ++j) {
    for (size_t i = 0; i < nrows; ++i) {
      mat(i, j) = vec[j + i * ncols];
    }
  }
  return mat;
}

[[cpp11::register]] //
cpp11::sexp
cpp_fmm_to_sparse_Matrix(const std::string &filename) {
  // Check if the Matrix package is loaded
  if (!is_matrix_loaded()) {
    throw std::runtime_error(
        "The 'Matrix' package cannot be loaded. Please install "
        "it before using this function.");
  }
  // TODO: Can speed this up by constructing from SEXP instead of via Matrix
  // constructor later
  using namespace cpp11::literals;

  // Initialize file stream and read header, row indices, column pointers, and
  // values
  std::ifstream file_stream(filename);
  if (!file_stream.is_open()) {
    throw std::runtime_error("Failed to open file: " + filename);
  }
  fmm::matrix_market_header header;
  std::vector<size_t> row_idx, col_idx;
  std::vector<double> vals;

  // Read the matrix data from the file
  fmm::read_matrix_market_triplet(file_stream, header, row_idx, col_idx, vals);

  // Increase the indices to change to one-based indexing.
  std::transform(row_idx.begin(), row_idx.end(), row_idx.begin(),
                 [](size_t val) { return val + 1; });
  std::transform(col_idx.begin(), col_idx.end(), col_idx.begin(),
                 [](size_t val) { return val + 1; });

  // Convert to R-compatible types
  cpp11::writable::integers r_row_idx(row_idx.begin(), row_idx.end());
  cpp11::writable::integers r_col_idx(col_idx.begin(), col_idx.end());
  cpp11::writable::doubles r_vals(vals.begin(), vals.end());
  cpp11::writable::integers r_dim = {static_cast<int>(header.nrows),
                                     static_cast<int>(header.ncols)};

  // Create a sparseMartix using the Matrix package
  cpp11::function sparseMatrix_fn = cpp11::package("Matrix")["sparseMatrix"];
  cpp11::sexp dgCMatrix =
      sparseMatrix_fn("i"_nm = r_row_idx, "j"_nm = r_col_idx, "x"_nm = r_vals,
                      "dims"_nm = r_dim, "repr"_nm = "C");
  return dgCMatrix;
}
