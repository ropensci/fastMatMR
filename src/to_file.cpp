#include <cstdint>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <vector>

#include "cpp11.hpp"
#include "helpers.h"

#include "../inst/include/fast_matrix_market/fast_matrix_market.hpp"

namespace fmm = fast_matrix_market;

[[cpp11::register]] //
bool vec_to_fmm(cpp11::doubles r_vec, std::string filename) {
  std::string mm;
  std::vector<double> std_vec(r_vec.size());
  std::copy(r_vec.begin(), r_vec.end(), std_vec.begin());
  fmm::matrix_market_header header(1, std_vec.size());
  std::filesystem::path file_path(filename);
  std::ofstream os(file_path);
  if (!os.is_open()) {
    return false;
  }
  fmm::write_matrix_market_array(os, header, std_vec);
  os.close();
  return true;
}

[[cpp11::register]] //
bool intvec_to_fmm(cpp11::integers r_vec, std::string filename) {
  std::string mm;
  std::vector<int> std_vec(r_vec.size());
  std::copy(r_vec.begin(), r_vec.end(), std_vec.begin());
  fmm::matrix_market_header header(1, std_vec.size());
  std::filesystem::path file_path(filename);
  std::ofstream os(file_path);
  if (!os.is_open()) {
    return false;
  }
  fmm::write_matrix_market_array(os, header, std_vec);
  os.close();
  return true;
}

[[cpp11::register]] //
bool mat_to_fmm(cpp11::doubles_matrix<> r_mat,
               std::string filename) {
  int nrows = r_mat.nrow();
  int ncols = r_mat.ncol();
  std::vector<double> std_vec(nrows * ncols);
  int k = 0;
  for (int i = 0; i < nrows; ++i) {
    for (int j = 0; j < ncols; ++j) {
      std_vec[k++] = r_mat(i, j);
    }
  }
  fmm::matrix_market_header header(nrows, ncols);
  std::filesystem::path file_path(filename);
  std::ofstream os(file_path);
  if (!os.is_open()) {
    return false;
  }
  fmm::write_matrix_market_array(os, header, std_vec);
  os.close();
  return true;
}

[[cpp11::register]] //
bool intmat_to_fmm(cpp11::integers_matrix<> r_mat,
                   std::string filename) {
  int nrows = r_mat.nrow();
  int ncols = r_mat.ncol();
  std::vector<int> std_vec(nrows * ncols);
  int k = 0;
  for (int i = 0; i < nrows; ++i) {
    for (int j = 0; j < ncols; ++j) {
      std_vec[k++] = r_mat(i, j);
    }
  }
  fmm::matrix_market_header header(nrows, ncols);
  std::filesystem::path file_path(filename);
  std::ofstream os(file_path);
  if (!os.is_open()) {
    return false;
  }
  fmm::write_matrix_market_array(os, header, std_vec);
  os.close();
  return true;
}

[[cpp11::register]] //
bool sparse_Matrix_to_fmm(cpp11::sexp input, std::string filename) {
  if (!is_matrix_loaded()) {
    throw std::runtime_error(
        "The 'Matrix' package cannot be loaded. Please install "
        "it before using this function.");
  }
  std::vector<int> i_vec, p_vec; // not set for diagonal sparse matrices
  std::vector<double> x_vec =
      cpp11::as_cpp<std::vector<double>>(input.attr("x"));
  std::vector<int> dim_vec = cpp11::as_cpp<std::vector<int>>(input.attr("Dim"));
  fmm::matrix_market_header header(dim_vec[0], dim_vec[1]);
  // Check if the matrix is a diagonal matrix by its class
  std::string matrix_class =
      cpp11::as_cpp<std::string>(cpp11::as_sexp(input.attr("class")));
  if (matrix_class == "ddiMatrix") {
    std::vector<double> x_vec =
        cpp11::as_cpp<std::vector<double>>(cpp11::as_sexp(input.attr("x")));
    // Create i, p, x vectors for diagonal matrices
    for (int j = 0; j < dim_vec[1]; ++j) {
      p_vec.push_back(j);
      i_vec.push_back(j);
    }
    p_vec.push_back(dim_vec[1]);
  } else {
    p_vec = cpp11::as_cpp<std::vector<int>>(cpp11::as_sexp(input.attr("p")));
    i_vec = cpp11::as_cpp<std::vector<int>>(cpp11::as_sexp(input.attr("i")));
  }
  std::ofstream os(filename);
  if (!os.is_open()) {
    return false;
  }
  fmm::write_matrix_market_csc(os, header, p_vec, i_vec, x_vec, false);
  os.close();
  return true;
}
