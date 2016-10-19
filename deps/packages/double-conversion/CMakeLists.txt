# Downloads the declared version of google/double-conversion and builds it.
# This is needed by Facebook folly.

include(ExternalProject)

### Download, configure and build double-conversion ###########################
ExternalProject_Add(double-conversion
#  GIT_REPOSITORY ${_git_repo}
  GIT_REPOSITORY https://github.com/google/double-conversion.git
  GIT_TAG ${_git_rev}

  BUILD_IN_SOURCE 1
  CMAKE_ARGS -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>

  INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/install
  INSTALL_COMMAND $(MAKE) install
          COMMAND ${CMAKE_COMMAND} -E echo FILE "(COPY lib include DESTINATION \"\${CMAKE_INSTALL_PREFIX}\")" > <INSTALL_DIR>/CMakeLists.txt
)

# cbdeps boilerplate
_ADD_PACKAGE_STEP()
