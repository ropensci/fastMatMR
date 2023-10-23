#include "helpers.h"
#include "cpp11.hpp"

bool is_matrix_loaded() {
  SEXP matrixNamespace = R_FindNamespace(Rf_mkString("Matrix"));
  if (matrixNamespace == R_UnboundValue) {
    return false;
  }
  return true;
}
