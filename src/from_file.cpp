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

    return cpp11::doubles(vec);
}
