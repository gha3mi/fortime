cmake_minimum_required(VERSION 3.18)
project(fortime LANGUAGES Fortran)

# Metadata
set(PROJECT_VERSION "0.6.1")
set(PROJECT_LICENSE "BSD 3-Clause License")
set(PROJECT_AUTHOR "Seyed Ali Ghasemi")

# Fortran settings
enable_language(Fortran)
set(CMAKE_Fortran_STANDARD 2008)
set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/mod)

# Dependencies
include(FetchContent)

# FACE dependency
FetchContent_Declare(
  FACE
  GIT_REPOSITORY https://github.com/szaghi/FACE.git
)
FetchContent_MakeAvailable(FACE)

# forunittest (only for testing)
FetchContent_Declare(
  forunittest
  GIT_REPOSITORY https://github.com/gha3mi/forunittest.git
  GIT_TAG main
)
FetchContent_MakeAvailable(forunittest)

# Source files
file(GLOB_RECURSE SOURCES src/*.f90)
set_source_files_properties(${SOURCES} PROPERTIES Fortran_PREPROCESS ON)

add_library(fortime ${SOURCES})
target_include_directories(fortime PUBLIC ${CMAKE_Fortran_MODULE_DIRECTORY})
target_link_libraries(fortime PUBLIC FACE)

# Optional: Enable OpenMP support
find_package(OpenMP)
if(OpenMP_Fortran_FOUND)
  target_link_libraries(fortime PUBLIC OpenMP::OpenMP_Fortran)
  target_compile_definitions(fortime PUBLIC USE_OMP)
endif()

# Optional: Enable MPI support
find_package(MPI)
if(MPI_Fortran_FOUND)
  target_link_libraries(fortime PUBLIC MPI::MPI_Fortran)
  target_compile_definitions(fortime PUBLIC USE_MPI)
endif()

# Examples
file(GLOB EXAMPLES example/example*.f90)
foreach(example_file ${EXAMPLES})
    get_filename_component(example_name ${example_file} NAME_WE)
    add_executable(${example_name} ${example_file})
    target_link_libraries(${example_name} PRIVATE fortime)
endforeach()

# Tests (if any)
enable_testing()
file(GLOB TEST_SOURCES test/test*.f90)
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
