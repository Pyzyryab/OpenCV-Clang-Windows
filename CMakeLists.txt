# ----------------------------------------------------------------------------
#  Root CMake file for this example project
#
#  Find more details on the README.md of the project
#
#  Alex Vergara (Pyzyrab), 2023
# ----------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.5)
project(opencv_example_project CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/install)

# The toolchain file that will be used later to pass our project configuration also to the OpenCV build
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/clang-x86_64_windows_gnu.cmake)


# ------- Project variables -------

set(PROJECT_BUILD_DIRECTORY     ${CMAKE_CURRENT_SOURCE_DIR}/build)
set(PROJECT_INSTALL_DIRECTORY   ${CMAKE_CURRENT_SOURCE_DIR}/install)

# Set the installation directory
set(OpenCV_INSTALL_DIR ${PROJECT_INSTALL_DIRECTORY}/opencv)
# Set the OpenCV build dir
set(OpenCV_BUILD_DIR ${PROJECT_BUILD_DIRECTORY}/opencv/build)
# Set the OpenCV_DIR, required to found the installation
set(OpenCV_DIR ${OpenCV_INSTALL_DIR})

# Attempt to find OpenCV in quiet mode. This will allow us to skip CMake code 
# in the consecutive iterations of the build process
find_package(OpenCV QUIET)

# Autogenerating the installation directories
if(NOT EXISTS ${PROJECT_INSTALL_DIRECTORY})
    execute_process(COMMAND mkdir ${PROJECT_INSTALL_DIRECTORY})
    message(STATUS "install folder created")
endif()

if(NOT EXISTS ${OpenCV_INSTALL_DIR})
    execute_process(COMMAND mkdir ${OpenCV_INSTALL_DIR})
endif()


# Check if OpenCV was found
if(OpenCV_FOUND)
    message(STATUS "OpenCV found. Version: ${OpenCV_VERSION}")
else()
    message(WARNING "OpenCV not found. Cloning the project, building it and installing it")
endif()

if(NOT OPENCV_FOUND)
    # Download and extract OpenCV sources
    message(STATUS "Downloading from GitHub OpenCV")
    execute_process(
        COMMAND git clone --branch 4.6.0 --single-branch https://github.com/opencv/opencv.git
        WORKING_DIRECTORY ${PROJECT_BUILD_DIRECTORY}
    )
    execute_process(COMMAND mkdir ${OpenCV_BUILD_DIR})

    # Configure the later build of OpenCV
    message(STATUS "Configuring the build and installation of OpenCV")
    execute_process(
        COMMAND cmake -G "Ninja"
                    -DCMAKE_INSTALL_PREFIX=${OpenCV_INSTALL_DIR}
                    -DBUILD_TESTS=OFF
                    -DBUILD_PERF_TESTS=OFF
                    -DBUILD_EXAMPLES=OFF
                    -DBUILD_opencv_apps=OFF
                    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
                    -DWITH_ADE=OFF
                    -Wno-dev
                    -S ${CMAKE_CURRENT_SOURCE_DIR}/build/opencv
                    -B ${OpenCV_BUILD_DIR}
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )

    # Build and install OpenCV using execute_process
    message(STATUS "Building and installing OpenCV")
    execute_process(
        COMMAND cmake --build . --target install
        WORKING_DIRECTORY ${OpenCV_BUILD_DIR}
    )
else()
    message (STATUS "OpenCV installation found. Version: ${OpenCV_VERSION}. Path: ${OpenCV_DIR}")
endif()

# Find the OpenCV build/installation, so their own variables for the include/link are correctly set up
find_package(OpenCV REQUIRED)

# A little bit of debug information about the OpenCV installation 
message(STATUS "OpenCV_INCLUDE_DIRS ${OpenCV_INCLUDE_DIRS}")
message(STATUS "OpenCV_LIBS ${OpenCV_LIBS}")
message(STATUS "OpenCV build and installation finished. Launching the build of the example project")

# Declare the executable target built from your sources
add_executable(opencv_example main.cpp)

# Adding the OpenCV needed headers
target_include_directories(opencv_example PRIVATE ${OpenCV_INCLUDE_DIRS})

# Link your application with OpenCV libraries
target_link_libraries(opencv_example PRIVATE  ${OpenCV_LIBS})
