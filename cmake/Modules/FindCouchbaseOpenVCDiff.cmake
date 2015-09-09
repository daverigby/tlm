# Locate open-vcdiff library
# This module defines
#  OPEN_VCDIFF_FOUND, if false, do not try to link with open-vcdiff
#  OPEN_VCDIFF_LIBRARIES, Library path and libs
#  OPEN_VCDIFF_INCLUDE_DIR, where to find the headers

###SET(_openvcdiff_exploded ${CMAKE_BINARY_DIR}/tlm/deps/breakpad.exploded)
SET(_openvcdiff_exploded ${CMAKE_INSTALL_PREFIX})

FIND_PATH(OPEN_VCDIFF_INCLUDE_DIR google/vcencoder.h
          PATHS ${_openvcdiff_exploded}/include)

IF (WIN32)

  # RelWithDebInfo & MinSizeRel should use the Release libraries, otherwise use
  # the same directory as the build type.
  IF(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo" OR CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
    SET(_build_type "Release")
  ELSE(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo" OR CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
    SET(_build_type ${CMAKE_BUILD_TYPE})
  ENDIF(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo" OR CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
ELSE()
  # Can just use the same library for all build types
  SET(_build_type "")
ENDIF (WIN32)

FIND_LIBRARY(OPEN_VCDIFF_COMMON_LIBRARY
             NAMES vcdcom
             PATHS ${_openvcdiff_exploded}/lib/${_build_type})

FIND_LIBRARY(OPEN_VCDIFF_ENCODER_LIBRARY
             NAMES vcdenc
             PATHS ${_openvcdiff_exploded}/lib/${_build_type})

FIND_LIBRARY(OPEN_VCDIFF_DECODER_LIBRARY
             NAMES vcddec
             PATHS ${_openvcdiff_exploded}/lib/${_build_type})

SET(OPEN_VCDIFF_LIBRARIES ${OPEN_VCDIFF_COMMON_LIBRARY} ${OPEN_VCDIFF_ENCODER_LIBRARY} ${OPEN_VCDIFF_DECODER_LIBRARY})

IF (OPEN_VCDIFF_LIBRARIES AND OPEN_VCDIFF_INCLUDE_DIR)
  SET(OPEN_VCDIFF_FOUND true)
  MESSAGE(STATUS "Found open-vcdiff in ${OPEN_VCDIFF_INCLUDE_DIR} : ${OPEN_VCDIFF_LIBRARIES}")
ENDIF (OPEN_VCDIFF_LIBRARIES AND OPEN_VCDIFF_INCLUDE_DIR)

MARK_AS_ADVANCED(OPEN_VCDIFF_FOUND OPEN_VCDIFF_INCLUDE_DIR OPEN_VCDIFF_LIBRARIES)
