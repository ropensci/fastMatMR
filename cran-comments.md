## Resubmission

This package was archived on 2024-08-19 due to non-API C calls
(`SETLENGTH`, `SET_GROWABLE_BIT`, `SET_TRUELENGTH`) originating from
the cpp11 package headers. This release requires cpp11 >= 0.5.0, which
removed those non-API calls.

## R CMD check results

0 errors | 0 warnings | 1 note

The installed package size note is expected due to the vendored
fast_matrix_market C++ header-only library.
