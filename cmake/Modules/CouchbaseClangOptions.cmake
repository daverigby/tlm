SET(CB_CLANG_DEBUG "-g")
SET(CB_CLANG_WARNINGS "-Qunused-arguments -Wall -pedantic -Wmissing-prototypes -Wmissing-declarations -Wredundant-decls -fno-strict-aliasing -Wno-overlength-strings")
SET(CB_CLANG_VISIBILITY "-fvisibility=hidden")
SET(CB_CLANG_THREAD "-pthread")
SET(CB_CLANG_LANG_VER "-std=gnu99")

# We want RelWithDebInfo to have the same optimization level as
# Release, only differing in whether debugging information is enabled.
SET(CMAKE_C_FLAGS_RELEASE        "-O3 -DNDEBUG")
SET(CMAKE_C_FLAGS_RELWITHDEBINFO "-O3 -DNDEBUG -g")
SET(CMAKE_C_FLAGS_DEBUG          "-O0 -g")

SET(CB_CXX_FLAGS_NO_OPTIMIZE     -O0)

IF ("${ENABLE_WERROR}" STREQUAL "YES")
   SET(CB_CLANG_WERROR "-Werror")
ENDIF()

FOREACH(dir ${CB_SYSTEM_HEADER_DIRS})
   SET(CB_CLANG_IGNORE_HEADER "${CB_CLANG_IGNORE_HEADER} -isystem ${dir}")
ENDFOREACH(dir ${CB_SYSTEM_HEADER_DIRS})

SET(CMAKE_C_FLAGS "${CB_CLANG_IGNORE_HEADER} ${CMAKE_C_FLAGS} ${CB_CLANG_DEBUG} ${CB_CLANG_LANG_VER} ${CB_CLANG_WARNINGS} ${CB_CLANG_VISIBILITY} ${CB_CLANG_THREAD} ${CB_CLANG_WERROR}")
SET(CMAKE_LINK_FLAGS "${CMAKE_LINK_FLAGS} ${CB_CLANG_LDFLAGS}")

# Enable color diagnostic output when using Ninja build generator
# (Clang fails to auto-detect it can use color).
IF (CMAKE_C_COMPILER_ID STREQUAL "Clang" AND CMAKE_GENERATOR STREQUAL "Ninja")
   SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fcolor-diagnostics")
ENDIF()
