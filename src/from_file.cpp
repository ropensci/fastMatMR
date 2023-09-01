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
    //
    cpp11::writable::doubles_matrix<> mat(nrow, ncols);
    for (size_t i = 0; i < nrow; ++i) {
        for (size_t j = 0; j < ncols; ++j) {
            mat(i, j) = vec[i + j * nrow];
        }
    }

    return mat;
}
