# Downloads the declared version of google/glog and builds it.
# This is needed by Facebook folly.

include(ExternalProject)

### Download, configure and build double-conversion ###########################
ExternalProject_Add(google-glog
#  GIT_REPOSITORY ${_git_repo}
  GIT_REPOSITORY https://github.com/google/glog.git
  GIT_TAG ${_git_rev}

  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND autoreconf -ivf
            COMMAND ./configure --prefix=<INSTALL_DIR>

  BUILD_COMMAND $(MAKE) all

  INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/install
  INSTALL_COMMAND $(MAKE) install
          COMMAND ${CMAKE_COMMAND} -E echo > <INSTALL_DIR>/CMakeLists.txt
)

# cbdeps boilerplate
_ADD_PACKAGE_STEP()
