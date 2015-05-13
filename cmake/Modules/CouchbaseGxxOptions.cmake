SET(CB_GXX_DEBUG "-g")
SET(CB_GXX_WARNINGS "-Wall -Wredundant-decls -fno-strict-aliasing")
SET(CB_GXX_VISIBILITY "-fvisibility=hidden")
SET(CB_GXX_THREAD "-pthread")

# We want RelWithDebInfo to have the same optimization level as
# Release, only differing in whether debugging information is enabled.
SET(CMAKE_CXX_FLAGS_RELEASE        "-O3 -DNDEBUG")
SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O3 -DNDEBUG -g")

IF ("${ENABLE_WERROR}" STREQUAL "YES")
   SET(CB_GXX_WERROR "-Werror")
ENDIF()

if (${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 4.7)
  if (${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 4.4.6)
      SET(CB_CXX_LANG_VER "")
      MESSAGE(WARNING "The C++ compiler is too old and don't support C++11")
  else ()
      SET(CB_CXX_LANG_VER "-std=c++0x")
      SET(CB_GNU_CXX11_OPTION "-std=gnu++0x")
  endif()
ELSE ()
  SET(COMPILER_SUPPORTS_CXX11 true)
  SET(CB_CXX_LANG_VER "-std=c++11")
  SET(CB_GNU_CXX11_OPTION "-std=gnu++11")
ENDIF()

INCLUDE(CouchbaseCXXVersion)

if (${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS 4.5)
  SET(CB_CXX_PEDANTIC "")
ELSE ()
  SET(CB_CXX_PEDANTIC "-pedantic")
ENDIF()

FOREACH(dir ${CB_SYSTEM_HEADER_DIRS})
   SET(CB_GNU_CXX_IGNORE_HEADER "${CB_GNU_CXX_IGNORE_HEADER} -isystem ${dir}")
ENDFOREACH(dir ${CB_SYSTEM_HEADER_DIRS})

IF (CB_CODE_COVERAGE)
  SET(CB_GXX_COVERAGE "--coverage")
ENDIF ()

SET(CMAKE_CXX_FLAGS "${CB_GNU_CXX_IGNORE_HEADER} ${CMAKE_CXX_FLAGS} ${CB_CXX_LANG_VER} ${CB_GXX_DEBUG} ${CB_GXX_WARNINGS} ${CB_CXX_PEDANTIC} ${CB_GXX_VISIBILITY} ${CB_GXX_THREAD} ${CB_GXX_WERROR} ${CB_GXX_COVERAGE}")
