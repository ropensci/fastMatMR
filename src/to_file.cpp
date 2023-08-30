#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <vector>

#include "cpp11.hpp"

#include "../inst/include/fast_matrix_market/fast_matrix_market.hpp"

namespace fmm = fast_matrix_market;

[[cpp11::register]] //
int vec_to_fmm(cpp11::doubles r_vec, std::string filename) {
  std::string mm;
  std::vector<double> std_vec(r_vec.size());
  std::copy(r_vec.begin(), r_vec.end(), std_vec.begin());
  fmm::matrix_market_header header(1, std_vec.size());
  // header.comment = std::string("comment");
  // Use C++17 filesystem to construct ofstream
  std::filesystem::path file_path(filename);
  std::ofstream os(file_path);

  if (!os.is_open()) {
    // Handle error
    return EXIT_FAILURE;
  }
  fmm::write_matrix_market_array(os, header, std_vec);
  os.close();
  return EXIT_SUCCESS;
}

[[cpp11::register]] //
int mat_to_fmm(cpp11::doubles_matrix<> r_mat,
               std::string filename) {
  // Get matrix dimensions
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
    return EXIT_FAILURE;
  }

  fmm::write_matrix_market_array(os, header, std_vec);
  os.close();
  return EXIT_SUCCESS;
}

[[cpp11::register]] //
int sparse_to_fmm(cpp11::sexp input, std::string filename) {
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
    return EXIT_FAILURE;
  }

  fmm::write_matrix_market_csc(os, header, p_vec, i_vec, x_vec, false);

  os.close();

  return EXIT_SUCCESS;
}
