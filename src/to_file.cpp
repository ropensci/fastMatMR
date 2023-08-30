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
using namespace std::string_literals;

[[cpp11::register]]
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

[[cpp11::register]]
int mat_to_fmm(cpp11::doubles_matrix<> r_mat, std::string filename) {
    // Get matrix dimensions
    int nrows = r_mat.nrow();
    int ncols = r_mat.ncol();

    std::vector<double> std_vec(nrows * ncols);
    int k = 0;
    for(int i = 0; i < nrows; ++i) {
        for(int j = 0; j < ncols; ++j) {
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
