# Contributing to `fastMatMR`

Thank you for considering contributing to `fastMatMR`! We appreciate your
interest in making this project better.

## Code of Conduct

Please read and adhere to our [Code of Conduct](https://ropensci.org/code-of-conduct/) to maintain
a safe, welcoming, and inclusive environment.

## Types of Contributions

We welcome various forms of contributions:

- **Bug Reports**: Feel free to report any bugs you encounter.
- **Documentation**: Typos, clarity issues, or missing guides—your help is
  welcome here.
- **Feature Discussions/Requests**: Got an idea? Open an issue to discuss its
  potential.
- **Code Contributions**: All code contributions are welcome.

## Using Co-Authored-By in Git Commits

We encourage the use of [co-authored
commits](https://docs.github.com/en/github/committing-changes-to-your-project/creating-a-commit-with-multiple-authors)
for collaborative efforts. This helps in giving credit to all contributors for
their work.

```markdown
Co-authored-by: name <name@example.com>
Co-authored-by: another-name <another-name@example.com>
```

## Development

Your contributions make this project better for everyone. Thank you for
participating!

### Local Development

Often it is useful to have [pixi](https://prefix.dev/) handle the dependencies:

```bash
pixi shell
```

A `pre-commit` job is set up on CI to enforce consistent styles. It is advisable
to set it up locally as well using [pipx](https://pypa.github.io/pipx/) for
isolation:

```bash
# Run before committing
pipx run pre-commit run --all-files
# Or install the git hook to enforce this
pipx run pre-commit install
```

For working with packages with compiled extensions, instead of `devtools::load_all()` it can be more useful to run this instead:

```{r eval=FALSE}
devtools::clean_dll()
cpp11::cpp_register()
devtools::document()
devtools::load_all()
```

Also don't forget to recreate the `readme` file:
```{r eval=FALSE}
devtools::build_readme()
```

If you find that `pre-commit` for R is flaky, you can consider the following commands:

```bash
find . \( -path "./.pixi" -o -path "./renv" \) -prune -o -type f -name "*.R" -exec Rscript -e 'library(styler); style_file("{}")' \;
Rscript -e 'library(lintr); lintr::lint_package(".")'
```

#### Tests

Tests and checks are run on the CI, however locally one can use:

```bash
Rscript -e 'devtools::test()'
```


#### Documentation

Ideally each change should be documented. Major changes should be `vignettes`,
and minor ones can be added to `newsfragments`.

Benchmark vignettes are pre-computed via:

```bash
Rscript tools/rebuild-benchmarks.R
```

Which makes it faster to build the package and run checks.


## CRAN Submission and Updates

Before submitting or updating the package on CRAN, follow these steps to ensure a smooth submission process:

1. **Document changes and recreate**:
   - Update documentation, and recreate vignettes.
     ```r
     urlchecker::url_check()
     devtools::document()
     devtools::build_readme()
     ## Will take a while
     Rscript tools/rebuild-benchmarks.R
     ```

2. **Check the package**:
   - This runs various checks to make sure the package is CRAN-ready.
     ```r
     devtools::check(remote = TRUE, manual = TRUE)
     ## devtools::install_github('r-lib/revdepcheck')
     revdepcheck::revdep_check(num_workers = 4)
     ```

3. **Test on various platforms**:
   - Before submission, it's beneficial to test your package on different platforms. The commented lines are used to populate `cran_comments.md`.
     ```r
     res_cran <- rhub::check_for_cran()   # Tests on multiple platforms
     ## res_cran$cran_summary()
     ubsan <- rhub::check_with_sanitizers() # A post-submission CRAN check
     devtools::check_win_devel()  # Specifically for Windows
     devtools::check_mac_release() # Mac only
     ```

4. **Adhere to best practices**:
   - Using the `goodpractice` package can help ensure you're following best practices for R package development.
     ```r
     goodpractice::gp()
     ```

5. **Bump the package version**:
   - Depending on the extent and nature of changes, adjust the version of your package. Remember semantic versioning conventions.
     ```r
     # Use "major", "minor", or "patch" based on the changes
     fledge::bump_version("patch")
     ```

6. **Submit to CRAN**:
   - Once all checks pass and you've ensured the quality of your package, it's time to submit.
     ```r
     devtools::release()
     ```

For more detailed information on the CRAN submission and update process, refer to the following resources:
- [Releasing a package](https://r-pkgs.org/release.html#sec-release-process)
- [How to Develop an R Package and Submit to CRAN (Mannheim University)](https://www.mzes.uni-mannheim.de/socialsciencedatalab/article/r-package/)
