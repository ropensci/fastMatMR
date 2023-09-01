#include <chrono>
#include <cstdint>
#include <cstdlib>
#include<vector>
#include<iostream>
#include<cstring>
#include<filesystem>
#include<fstream>

#include "cpp11.hpp"

#include "../inst/include/fast_matrix_market/fast_matrix_market.hpp"

// TODO: Consider chunking

namespace fmm = fast_matrix_market;

[[cpp11::register]] //
cpp11::doubles fmm_to_vec(const std::string& filename) {
    std::ifstream file_stream;
    std::vector<double> vec;

    file_stream.open(filename, std::ios::binary);
    if (!file_stream) {
        throw std::runtime_error("Failed to open file: " + filename);
    }

    fmm::read_matrix_market_array(file_stream, vec);
    file_stream.close();

    return cpp11::doubles(vec);
}

[[cpp11::register]] //
cpp11::doubles_matrix<> fmm_to_mat(const std::string& filename) {
    std::ifstream file_stream;
    fmm::matrix_market_header header;
    std::vector<double> vec;

    file_stream.open(filename, std::ios::binary);
    if (!file_stream) {
        throw std::runtime_error("Failed to open file: " + filename);
    }

    fmm::read_matrix_market_array(file_stream, header, vec);
    file_stream.close();

    size_t nrow = header.nrows;
    size_t ncols = header.ncols;
    cpp11::writable::doubles_matrix<> mat(nrow, ncols);
    for (size_t i = 0; i < nrow; ++i) {
        for (size_t j = 0; j < ncols; ++j) {
            mat(i, j) = vec[i + j * nrow];
        }
    }

    return mat;
}


[[cpp11::register]] //
cpp11::sexp fmm_to_sparse_Matrix(const std::string& filename) {
    // TODO: Can speed this up by constructing from SEXP instead of via Matrix
    // constructor later
    // Instead of constructing a redundant triplet matrix and then coercing as
    // readMM does, this produces efficient sparse matrices
    using namespace cpp11::literals;
    
    // Initialize file stream and read header, row indices, column pointers, and values
    std::ifstream file_stream(filename, std::ios::binary);
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
    cpp11::writable::integers r_dim = {static_cast<int>(header.nrows), static_cast<int>(header.ncols)};

    // Create a sparseMartix using the Matrix package
    cpp11::function sparseMatrix_fn = cpp11::package("Matrix")["sparseMatrix"];
    cpp11::sexp dgCMatrix = sparseMatrix_fn("i"_nm = r_row_idx,
                                            "j"_nm = r_col_idx,
                                            "x"_nm = r_vals,
                                            "dims"_nm = r_dim,
                                            "repr"_nm = "C");
    return dgCMatrix;
}
