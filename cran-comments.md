## Notes

Now [passes
UBSAN](https://builder.r-hub.io/status/fastMatMR_1.2.5.tar.gz-ab3cb8b02ef84c458cb948ef298b9ba5),
though with an `rhub` timeout, as noted on the [r-hub
tracker](https://github.com/r-hub/rhub/issues/448#issuecomment-793776145).

## R CMD check results

── fastMatMR 1.2.5: NOTE

  Build ID:   fastMatMR_1.2.5.tar.gz-fc2450e05dee412085c813071d9371fc
  Platform:   Windows Server 2022, R-devel, 64 bit
  Submitted:  1h 26m 36.8s ago
  Build time: 6m 33.7s

❯ checking CRAN incoming feasibility ... [16s] NOTE
  Maintainer: 'Rohit Goswami <rgoswami@ieee.org>'

  Days since last update: 1

❯ checking for non-standard things in the check directory ... NOTE
  Found the following files/directories:
    ''NULL''

❯ checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

0 errors ✔ | 0 warnings ✔ | 3 notes ✖

── fastMatMR 1.2.5: NOTE

  Build ID:   fastMatMR_1.2.5.tar.gz-400f6769960c4b95a384fc33494b2077
  Platform:   Ubuntu Linux 20.04.1 LTS, R-release, GCC
  Submitted:  1h 26m 36.8s ago
  Build time: 39m 32.6s

❯ checking CRAN incoming feasibility ... [7s/25s] NOTE
  Maintainer: ‘Rohit Goswami <rgoswami@ieee.org>’

  Days since last update: 1

❯ checking installed package size ... NOTE
    installed size is 12.4Mb
    sub-directories of 1Mb or more:
      libs  11.5Mb

❯ checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found

0 errors ✔ | 0 warnings ✔ | 3 notes ✖

── fastMatMR 1.2.5: NOTE

  Build ID:   fastMatMR_1.2.5.tar.gz-39503d069c94438aa0ba36bf4abfe2e8
  Platform:   Fedora Linux, R-devel, clang, gfortran
  Submitted:  1h 26m 36.8s ago
  Build time: 37m 12.8s

❯ checking CRAN incoming feasibility ... [8s/32s] NOTE
  Maintainer: ‘Rohit Goswami <rgoswami@ieee.org>’

  Days since last update: 1

❯ checking installed package size ... NOTE
    installed size is  6.5Mb
    sub-directories of 1Mb or more:
      libs   5.6Mb

❯ checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found

0 errors ✔ | 0 warnings ✔ | 3 notes ✖

── fastMatMR 1.2.5: PREPERROR

  Build ID:   fastMatMR_1.2.5.tar.gz-ab3cb8b02ef84c458cb948ef298b9ba5
  Platform:   Debian Linux, R-devel, GCC ASAN/UBSAN
  Submitted:  1h 26m 36.8s ago
  Build time: 1h 25m 42.9s
