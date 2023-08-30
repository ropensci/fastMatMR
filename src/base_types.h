#pragma once
#include <vector>
#include <cstdint>
#ifndef BASE_TYPES_H_
#define BASE_TYPES_H_

template<typename IT, typename VT>
struct triplet_matrix {
    int64_t nrows = 0, ncols = 0;
    std::vector<IT> rows;
    std::vector<IT> cols;
    std::vector<VT> vals;
};

template <typename VT>
struct array_matrix {
    int64_t nrows = 0, ncols = 0;
    std::vector<VT> vals;
};

#endif // BASE_TYPES_H_
