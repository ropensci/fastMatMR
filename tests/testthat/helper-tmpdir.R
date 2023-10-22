# Create a fixture for temporary directory management
temp_path_fixture <- function() {
  temp_dir <- tempfile()
  dir.create(temp_dir)

  # Return function to get a file path in the temporary directory
  function(filename) {
    file.path(temp_dir, filename)
  }
}
