cmake_minimum_required(VERSION 3.18)

# Metadata
file(READ "${CMAKE_SOURCE_DIR}/VERSION" PROJECT_VERSION_STRING)
string(STRIP "${PROJECT_VERSION_STRING}" PROJECT_VERSION)
set(PROJECT_VERSION ${PROJECT_VERSION})
set(PROJECT_AUTHOR "Seyed Ali Ghasemi")
set(PROJECT_MAINTAINER "info@gha3mi.com")
set(PROJECT_LICENSE "BSD-3-Clause")
project(fortime VERSION ${PROJECT_VERSION} LANGUAGES Fortran)

# Fortran settings
set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/mod)

# Options
option(FORTIME_BUILD_EXAMPLES "Build fortime examples" OFF)
option(FORTIME_BUILD_TESTS "Build fortime tests" OFF)

# Dependencies
include(FetchContent)

# FACE dependency
FetchContent_Declare(
  FACE
  GIT_REPOSITORY https://github.com/szaghi/FACE.git
)
FetchContent_MakeAvailable(FACE)

# Source files
file(GLOB_RECURSE SOURCES
  src/*.f90
  src/*.F90)

set_source_files_properties(${SOURCES} PROPERTIES Fortran_PREPROCESS ON)

add_library(fortime ${SOURCES})
target_include_directories(fortime PUBLIC ${CMAKE_Fortran_MODULE_DIRECTORY})
target_link_libraries(fortime PUBLIC FACE)

# Optional: OpenMP support
find_package(OpenMP)
if(OpenMP_Fortran_FOUND)
  target_link_libraries(fortime PUBLIC OpenMP::OpenMP_Fortran)
  target_compile_definitions(fortime PUBLIC USE_OMP)
  message(STATUS "OpenMP support enabled")
else()
  message(STATUS "OpenMP not found — building without OpenMP support")
endif()

# Optional: MPI support
find_package(MPI)
if(MPI_Fortran_FOUND)
  target_link_libraries(fortime PUBLIC MPI::MPI_Fortran)
  target_compile_definitions(fortime PUBLIC USE_MPI)
  message(STATUS "MPI support enabled")
else()
  message(STATUS "MPI not found — building without MPI support")
endif()

# Examples (optional)
if(FORTIME_BUILD_EXAMPLES)
  file(GLOB EXAMPLES
    example/*.f90
    example/*.F90)

  foreach(example_file ${EXAMPLES})
    get_filename_component(example_name ${example_file} NAME_WE)
    add_executable(${example_name} ${example_file})
    target_link_libraries(${example_name} PRIVATE fortime)
  endforeach()
endif()

# Tests (optional)
if(FORTIME_BUILD_TESTS)
  enable_testing()
  FetchContent_Declare(
    forunittest
    GIT_REPOSITORY https://github.com/gha3mi/forunittest.git
    GIT_TAG main
  )
  FetchContent_MakeAvailable(forunittest)

  file(GLOB TEST_SOURCES
    test/*.f90
    test/*.F90)

  foreach(test_file ${TEST_SOURCES})
    get_filename_component(test_name ${test_file} NAME_WE)
    set_source_files_properties(${test_file} PROPERTIES Fortran_PREPROCESS ON)
    add_executable(${test_name} ${test_file})
    target_link_libraries(${test_name} PRIVATE fortime forunittest)
    set_target_properties(${test_name} PROPERTIES
      Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/mod/test
      RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/test
    )
    add_test(NAME ${test_name} COMMAND ${CMAKE_BINARY_DIR}/test/${test_name})
  endforeach()
endif()
