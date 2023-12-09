# ----------------------------------------------------------------------------
#  Toolchain CMake file for this example project
#
#  Find more details on the README.md of the project
#
#  Alex Vergara (Pyzyrab), 2023
# ----------------------------------------------------------------------------

# Assuming that you already have a LLVM installation in your path...
set(CMAKE_C_COMPILER "clang.exe")
set(CMAKE_CXX_COMPILER "clang++.exe")

# Set the triple-target
set(CMAKE_CXX_COMPILER_TARGET x86_64-windows-gnu)

# Linker flags
set(CMAKE_EXE_LINKER_FLAGS_INIT "-fuse-ld=lld -stdlib=libc++ -lc++abi -lunwind -funwind-tables -fexceptions -frtti")
set(CMAKE_MODULE_LINKER_FLAGS_INIT "-fuse-ld=lld")
set(CMAKE_SHARED_LINKER_FLAGS_INIT "-fuse-ld=lld")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++ -lunwind -funwind-tables -fexceptions -frtti") # TODO as variables
