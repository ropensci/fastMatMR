#include <cstdint>
#include <cstdlib>
#include<vector>
#include<iostream>
#include<cstring>

#include "cpp11.hpp"
#include "base_types.h"

#include "fast_matrix_market/fast_matrix_market.hpp"

namespace fmm = fast_matrix_market;

[[cpp11::register]]
int test_fmm() {
    // Create a matrix
    triplet_matrix<int64_t, double> triplet;

    triplet.nrows = 4;
    triplet.ncols = 4;

    triplet.rows = {1, 2, 3, 3};
    triplet.cols = {0, 1, 2, 3};
    triplet.vals = {1.0, 5, 2E5, 19};

    std::string mm;

    // Write triplet to Matrix Market. Use std::ostringstream to write to a string.
    {
        std::ostringstream oss;

        // The `nrows` and `ncols` below are a brace initialization of the header.
        // If you are interested in the other aspects of the Matrix Market header then
        // construct an instance of fast_matrix_market::matrix_market_header.
        // This is how you would manipulate the comment field: header.comment = std::string("comment");
        // You may also set header.field = fast_matrix_market::pattern to write a pattern file (only indices, no values).
        // Non-pattern field types (integer, real, complex) are deduced from the template type and cannot be overriden.

        fmm::write_matrix_market_triplet(
                oss,
                {triplet.nrows, triplet.ncols},
                triplet.rows, triplet.cols, triplet.vals);

        mm = oss.str();
        std::cout << mm << std::endl << std::endl;
    }
    return EXIT_SUCCESS;
}
