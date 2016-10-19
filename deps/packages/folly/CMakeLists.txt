# Downloads the declared version of Facebook folly and builds it.

# First, download the dependencies of folly itselff. Set
# CMAKE_INSTALL_PREFIX to a local directory to dump in there, and add
# that directory to CMAKE_PREFIX_PATH.
SET (_folly_deps_install "${CMAKE_CURRENT_BINARY_DIR}/dep-install")
SET (_orig_install_prefix "${CMAKE_INSTALL_PREFIX}")
SET (CMAKE_INSTALL_PREFIX "${_folly_deps_install}")

DECLARE_DEP (double-conversion VERSION 2.0.1-cb1 PLATFORMS centos6 centos7 debian7 debian8 macosx suse11.2 ubuntu12.04 ubuntu14.04 windows_msvc)
DECLARE_DEP (gflags VERSION 2.1.2-cb1 PLATFORMS centos6 centos7 debian7 debian8 macosx suse11.2 ubuntu12.04 ubuntu14.04 windows_msvc)
DECLARE_DEP (google-glog VERSION 9581b3-cb1 PLATFORMS centos6 centos7 debian7 debian8 macosx suse11.2 ubuntu12.04 ubuntu14.04 windows_msvc)
DECLARE_DEP (libevent VERSION 2.0.22-cb1 PLATFORMS macosx)
DECLARE_DEP (libevent VERSION 2.0.22-cb2 PLATFORMS centos6 centos7 debian7 debian8 freebsd sunos suse11.2 ubuntu12.04 ubuntu14.04)

SET (CMAKE_INSTALL_PREFIX "${_orig_install_prefix}")

SET (_folly_CPPFLAGS "-I${_folly_deps_install}/include -I${CMAKE_CURRENT_BINARY_DIR}/google-glog.exploded/include -I${CMAKE_CURRENT_BINARY_DIR}/libevent.exploded/include")
SET (_folly_CXXFLAGS "-Wl,-rpath=${_folly_deps_install}/lib -Wl,-rpath=${CMAKE_CURRENT_BINARY_DIR}/google-glog.exploded/lib")
SET (_folly_LDFLAGS "-L${_folly_deps_install}/lib -L${CMAKE_CURRENT_BINARY_DIR}/google-glog.exploded/lib")

include(ExternalProject)

### Download, configure and build folly  ####################################
ExternalProject_Add(folly
#  GIT_REPOSITORY ${_git_repo}
  GIT_REPOSITORY https://github.com/facebook/folly.git
  GIT_TAG ${_git_rev}

  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND cd folly && autoreconf -ivf -I/usr/share/aclocal
            COMMAND cd folly && ./configure CPPFLAGS=${_folly_CPPFLAGS}
                                            CXXFLAGS=${_folly_CXXFLAGS}
                                            LDFLAGS=${_folly_LDFLAGS}
	                                    --prefix=<INSTALL_DIR>

  BUILD_COMMAND $(MAKE) -C folly -j4

  INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/install
  INSTALL_COMMAND $(MAKE) -C folly install

  COMMAND ${CMAKE_COMMAND} -E echo FILE "(COPY lib DESTINATION \"\${CMAKE_INSTALL_PREFIX}\")" > <INSTALL_DIR>/CMakeLists.txt
)

# cbdeps boilerplate
_ADD_PACKAGE_STEP()
