# Support for building with UndefinedBehaviourSanitizer (ubsan) -
# http://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html

INCLUDE(CheckCCompilerFlag)
INCLUDE(CheckCXXCompilerFlag)
INCLUDE(CMakePushCheckState)

OPTION(CB_UNDEFINEDSANITIZER "Enable UndefinedBehaviourSanitizer."
       OFF)

IF (CB_UNDEFINEDSANITIZER)
    CMAKE_PUSH_CHECK_STATE(RESET)
    SET(CMAKE_REQUIRED_FLAGS "-fsanitize=undefined") # Also needs to be a link flag for test to pass
    CHECK_C_COMPILER_FLAG("-fsanitize=undefined" HAVE_FLAG_SANITIZE_UNDEFINED_C)
    CHECK_CXX_COMPILER_FLAG("-fsanitize=undefined" HAVE_FLAG_SANITIZE_UNDEFINED_CXX)
    CMAKE_POP_CHECK_STATE()

    IF ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
      # Clang requires an external symbolizer program.
      FIND_PROGRAM(LLVM_SYMBOLIZER
                   NAMES llvm-symbolizer
                         llvm-symbolizer-3.8
                         llvm-symbolizer-3.7
                         llvm-symbolizer-3.6)

      IF(NOT LLVM_SYMBOLIZER)
        MESSAGE(WARNING "UndefinedBehaviourSanitizer failed to locate an llvm-symbolizer program. Stack traces may lack symbols.")
      ENDIF()
    ENDIF()

    IF(HAVE_FLAG_SANITIZE_UNDEFINED_C AND HAVE_FLAG_SANITIZE_UNDEFINED_CXX)
        SET(UNDEFINED_SANITIZER_FLAG "-fsanitize=undefined")

        # Need -fno-omit-frame-pointer to allow the backtraces to be symbolified.
        SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${UNDEFINED_SANITIZER_FLAG} -fno-omit-frame-pointer")
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${UNDEFINED_SANITIZER_FLAG} -fno-omit-frame-pointer")
        SET(CMAKE_CGO_LDFLAGS "${CMAKE_CGO_LDFLAGS} ${UNDEFINED_SANITIZER_FLAG}")

        # TC/jemalloc cause issues with AddressSanitizer - force
        # the use of the system allocator.
#        SET(COUCHBASE_MEMORY_ALLOCATOR system CACHE STRING "Memory allocator to use")

        # Configure CTest's MemCheck to AddressSanitizer.
#        SET(MEMORYCHECK_TYPE AddressSanitizer)

#        ADD_DEFINITIONS(-DADDRESS_SANITIZER)

        # Override the normal ADD_TEST macro to set the ASAN_OPTIONS
        # environment variable - this allows us to specify the
        # suppressions file to use.
        FUNCTION(ADD_TEST name)
            IF(${ARGV0} STREQUAL "NAME")
               SET(_name ${ARGV1})
            ELSE()
               SET(_name ${ARGV0})
            ENDIF()
            _ADD_TEST(${ARGV})
            SET_TESTS_PROPERTIES(${_name} PROPERTIES ENVIRONMENT
                                 "UBSAN_SYMBOLIZER_PATH=${LLVM_SYMBOLIZER}")
        ENDFUNCTION()

        MESSAGE(STATUS "UndefinedBehaviourSanitizer enabled.")
    ELSE()
        MESSAGE(FATAL_ERROR "CB_UNDEFINEDSANITIZER enabled but compiler doesn't support UndefinedBehaviourSanitizer - cannot continue.")
    ENDIF()
ENDIF()

