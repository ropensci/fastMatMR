"""ASV benchmarks for fastMatMR (R package, called via Rscript).

Each track_* method runs an Rscript that times the operation using
system.time() and prints the elapsed seconds to stdout. ASV records
the returned value across commits.
"""

import os
import subprocess
import tempfile


def _run_r(code):
    """Run R code via Rscript, return elapsed seconds from stdout."""
    result = subprocess.run(
        ["Rscript", "-e", code],
        capture_output=True, text=True, timeout=300,
    )
    if result.returncode != 0:
        raise RuntimeError(f"Rscript failed:\n{result.stderr}")
    return float(result.stdout.strip().split("\n")[-1])


class TrackSparseRead:
    """Benchmark sparse Matrix Market read via fmm_to_sparse_Matrix."""

    params = [100, 500, 1000]
    param_names = ["matrix_size"]
    unit = "seconds"

    def setup(self, matrix_size):
        self._tmpdir = tempfile.mkdtemp()
        self._mtx = os.path.join(self._tmpdir, "test.mtx")
        # Generate a sparse .mtx file using R
        _run_r(f"""
            library(Matrix)
            library(fastMatMR)
            set.seed(42)
            n <- {matrix_size}
            mat <- rsparsematrix(n, n, density = 0.3)
            write_fmm(mat, "{self._mtx}")
            cat("0\\n")
        """)

    def track_read_sparse(self, matrix_size):
        return _run_r(f"""
            library(fastMatMR)
            t <- system.time({{
                for (i in 1:5) fmm_to_sparse_Matrix("{self._mtx}")
            }})
            cat(t["elapsed"] / 5, "\\n")
        """)

    def teardown(self, matrix_size):
        import shutil
        shutil.rmtree(self._tmpdir, ignore_errors=True)


class TrackSparseWrite:
    """Benchmark sparse Matrix Market write via write_fmm."""

    params = [100, 500, 1000]
    param_names = ["matrix_size"]
    unit = "seconds"

    def setup(self, matrix_size):
        self._tmpdir = tempfile.mkdtemp()
        self._mtx = os.path.join(self._tmpdir, "out.mtx")

    def track_write_sparse(self, matrix_size):
        return _run_r(f"""
            library(Matrix)
            library(fastMatMR)
            set.seed(42)
            mat <- rsparsematrix({matrix_size}, {matrix_size}, density = 0.3)
            t <- system.time({{
                for (i in 1:5) write_fmm(mat, "{self._mtx}")
            }})
            cat(t["elapsed"] / 5, "\\n")
        """)

    def teardown(self, matrix_size):
        import shutil
        shutil.rmtree(self._tmpdir, ignore_errors=True)


class TrackDenseRead:
    """Benchmark dense matrix read via fmm_to_mat."""

    params = [100, 500]
    param_names = ["matrix_size"]
    unit = "seconds"

    def setup(self, matrix_size):
        self._tmpdir = tempfile.mkdtemp()
        self._mtx = os.path.join(self._tmpdir, "dense.mtx")
        _run_r(f"""
            library(fastMatMR)
            set.seed(42)
            mat <- matrix(rnorm({matrix_size} * {matrix_size}),
                          nrow = {matrix_size}, ncol = {matrix_size})
            mat_to_fmm(mat, "{self._mtx}")
            cat("0\\n")
        """)

    def track_read_dense(self, matrix_size):
        return _run_r(f"""
            library(fastMatMR)
            t <- system.time({{
                for (i in 1:5) fmm_to_mat("{self._mtx}")
            }})
            cat(t["elapsed"] / 5, "\\n")
        """)

    def teardown(self, matrix_size):
        import shutil
        shutil.rmtree(self._tmpdir, ignore_errors=True)


class TrackDenseWrite:
    """Benchmark dense matrix write via mat_to_fmm."""

    params = [100, 500]
    param_names = ["matrix_size"]
    unit = "seconds"

    def setup(self, matrix_size):
        self._tmpdir = tempfile.mkdtemp()
        self._mtx = os.path.join(self._tmpdir, "out.mtx")

    def track_write_dense(self, matrix_size):
        return _run_r(f"""
            library(fastMatMR)
            set.seed(42)
            mat <- matrix(rnorm({matrix_size} * {matrix_size}),
                          nrow = {matrix_size}, ncol = {matrix_size})
            t <- system.time({{
                for (i in 1:5) mat_to_fmm(mat, "{self._mtx}")
            }})
            cat(t["elapsed"] / 5, "\\n")
        """)

    def teardown(self, matrix_size):
        import shutil
        shutil.rmtree(self._tmpdir, ignore_errors=True)


class TrackGzipRoundtrip:
    """Benchmark gzip-compressed .mtx.gz read/write."""

    params = [100, 500]
    param_names = ["matrix_size"]
    unit = "seconds"

    def setup(self, matrix_size):
        self._tmpdir = tempfile.mkdtemp()
        self._mtx_gz = os.path.join(self._tmpdir, "test.mtx.gz")
        try:
            _run_r(f"""
                library(Matrix)
                library(fastMatMR)
                set.seed(42)
                mat <- rsparsematrix({matrix_size}, {matrix_size}, density = 0.3)
                write_fmm(mat, "{self._mtx_gz}")
                cat("0\\n")
            """)
        except RuntimeError:
            raise NotImplementedError("gzip support not available")

    def track_read_gzip(self, matrix_size):
        return _run_r(f"""
            library(fastMatMR)
            t <- system.time({{
                for (i in 1:5) fmm_to_sparse_Matrix("{self._mtx_gz}")
            }})
            cat(t["elapsed"] / 5, "\\n")
        """)

    def track_write_gzip(self, matrix_size):
        return _run_r(f"""
            library(Matrix)
            library(fastMatMR)
            set.seed(42)
            mat <- rsparsematrix({matrix_size}, {matrix_size}, density = 0.3)
            out <- "{os.path.join(self._tmpdir, 'out.mtx.gz')}"
            t <- system.time({{
                for (i in 1:5) write_fmm(mat, out)
            }})
            cat(t["elapsed"] / 5, "\\n")
        """)

    def teardown(self, matrix_size):
        import shutil
        shutil.rmtree(self._tmpdir, ignore_errors=True)


class TrackSpamRoundtrip:
    """Benchmark spam sparse matrix read/write."""

    params = [100, 500]
    param_names = ["matrix_size"]
    unit = "seconds"

    def setup(self, matrix_size):
        self._tmpdir = tempfile.mkdtemp()
        self._mtx = os.path.join(self._tmpdir, "spam.mtx")
        try:
            _run_r("""
                library(fastMatMR)
                library(spam)
                if (!exists("fmm_to_spam", where = asNamespace("fastMatMR")))
                    stop("fmm_to_spam not available")
                cat("0\\n")
            """)
            _run_r(f"""
                library(Matrix)
                library(fastMatMR)
                set.seed(42)
                mat <- rsparsematrix({matrix_size}, {matrix_size}, density = 0.3)
                write_fmm(mat, "{self._mtx}")
                cat("0\\n")
            """)
        except RuntimeError:
            raise NotImplementedError("spam support not available")

    def track_read_spam(self, matrix_size):
        return _run_r(f"""
            library(fastMatMR)
            t <- system.time({{
                for (i in 1:5) fmm_to_spam("{self._mtx}")
            }})
            cat(t["elapsed"] / 5, "\\n")
        """)

    def track_write_spam(self, matrix_size):
        return _run_r(f"""
            library(spam)
            library(fastMatMR)
            set.seed(42)
            n <- {matrix_size}
            vals <- rnorm(as.integer(n * n * 0.3))
            nz <- length(vals)
            ij <- unique(cbind(sample(n, nz, TRUE), sample(n, nz, TRUE)))
            sp <- spam(list(i = ij[,1], j = ij[,2],
                            values = vals[seq_len(nrow(ij))]),
                       nrow = n, ncol = n)
            out <- "{os.path.join(self._tmpdir, 'out.mtx')}"
            t <- system.time({{
                for (i in 1:5) spam_to_fmm(sp, out)
            }})
            cat(t["elapsed"] / 5, "\\n")
        """)

    def teardown(self, matrix_size):
        import shutil
        shutil.rmtree(self._tmpdir, ignore_errors=True)


class TrackSparseMRoundtrip:
    """Benchmark SparseM matrix.csr read/write."""

    params = [100, 500]
    param_names = ["matrix_size"]
    unit = "seconds"

    def setup(self, matrix_size):
        self._tmpdir = tempfile.mkdtemp()
        self._mtx = os.path.join(self._tmpdir, "sparsem.mtx")
        try:
            _run_r("""
                library(fastMatMR)
                library(SparseM)
                if (!exists("fmm_to_SparseM", where = asNamespace("fastMatMR")))
                    stop("fmm_to_SparseM not available")
                cat("0\\n")
            """)
            _run_r(f"""
                library(Matrix)
                library(fastMatMR)
                set.seed(42)
                mat <- rsparsematrix({matrix_size}, {matrix_size}, density = 0.3)
                write_fmm(mat, "{self._mtx}")
                cat("0\\n")
            """)
        except RuntimeError:
            raise NotImplementedError("SparseM support not available")

    def track_read_sparsem(self, matrix_size):
        return _run_r(f"""
            library(fastMatMR)
            t <- system.time({{
                for (i in 1:5) fmm_to_SparseM("{self._mtx}")
            }})
            cat(t["elapsed"] / 5, "\\n")
        """)

    def track_write_sparsem(self, matrix_size):
        return _run_r(f"""
            library(SparseM)
            library(fastMatMR)
            set.seed(42)
            n <- {matrix_size}
            dense <- matrix(0, n, n)
            nz <- as.integer(n * n * 0.3)
            idx <- sample(n * n, nz)
            dense[idx] <- rnorm(nz)
            csr <- as.matrix.csr(dense)
            out <- "{os.path.join(self._tmpdir, 'out.mtx')}"
            t <- system.time({{
                for (i in 1:5) SparseM_to_fmm(csr, out)
            }})
            cat(t["elapsed"] / 5, "\\n")
        """)

    def teardown(self, matrix_size):
        import shutil
        shutil.rmtree(self._tmpdir, ignore_errors=True)
