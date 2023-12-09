# OpenCV with Clang on Windows - Tutorial Project Documentation

## Overview

Welcome to the `OpenCV with Clang on Windows`. This **Tutorial Project** aims to provide as a comprehensive guide the process of building OpenCV from scratch
using our favorite `C++` tools here on [**Zero Day Code**](https://github.com/zerodaycode).

The provided CMakeLists.txt file and toolchain file configure the project and specify the build environment.

### Project Purpose

The primary objective of this project is to showcase the step-by-step process of integrating **OpenCV** into a **C++** project using **CMake**,
and built it from source with the latest **C++** standard, using **Clang** as compiler, **LLD** as linker, and the gorgeous **LIBC++** LLVM's implementation
of the **C++** standard library under a Windows environment.

Also, the main goal is to integrate the build and installation of **OpenCV** directly in our **CMake** setup, without having to first download a prebuilt suite
for your target operating system, or to download the sources and built them from scratch before build your projects.
The latest version available at the time of writting of the LLVM tools is `17.0.2`.

### Considerations

As you may see, the toolchain provided file targets directly a `Windows` setup. Even tho, if you want, you can just use it for the same purposes on `Unix Distributions`. Here won't cover such case, but is a very easy set-up considering the tools that we want to use for the
`Windows integration`, and almost of the tools you can get it via terminal on your favourite distro with your package manager.

> **NOTE**: We will be using the *Clang64* terminal provided with the **MSYS2** installation, and **git bash** as the terminal choosen for the development of the project.

## Project Structure

- **CMakeLists.txt**: The main configuration file for CMake, defining how the project should be built.
  
- **toolchain.cmake**: Specifies the toolchain and compiler options, ensuring compatibility and providing necessary flags.

- **main.cpp**: The driver code

## Requisites

Before building the project, we need to install certain software:

- **MSYS2**: *MSYS2* is a collection of tools and libraries providing you with an easy-to-use environment for building, installing and running native Windows software.
You can read more about [MSYS2 here](https://www.msys2.org) if you're not familiar with it.
Then, or if not, download the latest installer available, directly linked in that page.

Now that you have installed **MSYS2** on your host machine, let us going to get the rest of our requirements. For that, we are going to use the `Clang64` environment provided
with **MSYS2**.

Why? Well, there's already a few advantages picking this environment:

- Only uses *LLVM* tools, *LLD* as a linker, *LIBC++* as a *C++* standard library
- Clang provides ASAN support
- Native support for TLS (Thread-local storage)
- *LLD* is faster than *LD*, but does not support all the features *LD* supports
- Some tools lack feature parity with equivalent *GNU* tools
- Supports *ARM64/AArch64* architecture on *Windows 10/11*

So, open that terminal prompt, and update the system with:

```bash
pacman -Syu
```

After the full upgrade, we can start finally to junk our dependencies.

- **CMake**: CMake is an open-source cross-platform build system. It provides a set of tools for configuring, building, testing, and packaging software projects.
You have [here](https://www.msys2.org/docs/cmake/) a great guide about how to get **CMake** working on **MSYS2**. But, instead, let's gonna do
a minor modification, to directly installing it on the **Clang64** environment.

    ```bash
    pacman -S mingw-w64-clang-x86_64-cmake
    ```

- **Ninja**: Ninja is a build system designed for speed and simplicity. It focuses on providing fast and efficient builds by minimizing unnecessary recompilation and linking. Ninja is often used as the underlying build tool for projects configured with CMake.

    ```bash
    pacman -S mingw-w64-clang-x86_64-ninja
    ```

- **Clang**: Clang is a compiler front end for the C, C++, and Objective-C programming languages. It is part of the LLVM (Low-Level Virtual Machine) project and aims to provide a fast, efficient, and versatile compiler infrastructure. Clang is known for its emphasis on providing helpful diagnostics and its modular architecture.

    ```bash
    pacman -S mingw-w64-clang-x86_64-clang
    ```

- **LLVM**: LLVM, which stands for Low-Level Virtual Machine, is a collection of modular and reusable compiler and toolchain technologies. It includes a set of libraries and tools for building compilers, optimizers, runtime environments, and more. LLVM is designed to be language-agnostic and is widely used in various programming language implementations.

    ```bash
    pacman -S mingw-w64-clang-x86_64-llvm
    pacman -S mingw-w64-clang-x86_64-llvm-libs
    ```

### Now let's gonna power our **Clang** installation with some nice to have tools.

- **Clang Analyzer**: Clang is a compiler front end for the C, C++, and Objective-C programming languages. It is part of the LLVM (Low-Level Virtual Machine) project and aims to provide a fast, efficient, and versatile compiler infrastructure. Clang is known for its emphasis on providing helpful diagnostics and its modular architecture.
This one isn't required for run this project.

    ```bash
    pacman -S mingw-w64-clang-x86_64-clang-analyzer
    ```

- **lld**: lld is the LLVM linker, and it is part of the LLVM project. It serves as a replacement for traditional linkers like GNU ld. lld is designed to be fast, with a focus on minimizing link times while providing compatibility with a wide range of object file formats and platforms. This is already provided with the Clang installation. If not:

    ```bash
    pacman -S mingw-w64-clang-x86_64-lld
    ```

- **libc++**: libc++ is the C++ Standard Library implementation for LLVM. It is designed to be modern, efficient, and standards-compliant. libc++ is part of the LLVM project and is often used as the standard C++ library with the Clang compiler. It provides the runtime support necessary for C++ programs, including containers, algorithms, and other fundamental components. This is already provided with the Clang installation. If not:

    ```bash
    pacman -S mingw-w64-clang-x86_64-libc++
    ```

- **libunwind**: The library for *unwind* used by LLVM

    ```bash
    pacman -S mingw-w64-x86_64-libunwind
    ```

#### More extra tools

- **Clang Tools Extra**:

    ```bash
    pacman -S mingw-w64-clang-x86_64-clang-tools-extra
    ```

- **Clang Compiler Runtime**: For example, if you want to run the build with sanitizers `-fsanitize=...` [more info](https://clang.llvm.org/docs/Toolchain.html#sanitizer-runtime)

    ```bash
    pacman -S pacman -S mingw-w64-clang-x86_64-compiler-rt
    ```

- **GCC Compat**: Powering our compiler with extra compatibility for the *GCC* world

    ```bash
    pacman -S mingw-w64-clang-x86_64-gcc-compat
    ```

- **Clang Tidy**: Clang's static source code analyzer (Provided with the Clang installation)

- **Clang Format**: Clang source code formatter (Provided with the Clang installation)

#### And finally

- **Git**: for fetching **OpenCV**. Go ahead and download the latest available version for Windows.

## Building the Project

1. Clone the project repository:

    ```bash
    git clone https://github.com/your_username/opencv_example_project.git
    ```

2. Navigate to the project directory:

    ```bash
    cd opencv_example_project
    ```

3. Create a build directory, and then navigate to it:

    ```bash
    mkdir build
    cd build
    ```

4. Configure and build the project:

    ```bash
    cmake -G "Ninja" -DCMAKE_TOOLCHAIN_FILE=./clang-x86_64_windows_gnu.cmake .. cmake --build .
    ```

## Project Configuration

### OpenCV Integration

The project uses OpenCV for computer vision functionalities. It fetches the OpenCV repository (version 4.6.0) from GitHub during the build process.

> With the set of tools described here, it's imposible to make the project compiler because **Clang** refuses to build the **OpenCV** code for versions `> 4.6.0` due to an incredible amount
of source code errors.

### C++ Standard

The project is configured to use **C++23** as the standard for compiling the code. This enables us to write our own code having the latest features of the standard available (if Clang has already implemented them).

### Toolchain Configuration

The toolchain file (`toolchain.cmake`) specifies the compiler and linker options, ensuring compatibility with MSYS64 and setting flags for exception handling, RTTI, and the C++ standard library.

## Building the Example

The example project demonstrates the integration of OpenCV in a simple C++ application (`main.cpp`). It showcases how to configure the project to use OpenCV and link the application with the necessary OpenCV libraries.

## Running the example

There's and extremely important step that we have to do before run our generated binary.
We need to add the **OpenCV** installation to the **PATH**, in concrete, the binary folder,
where the generated `.dll` files lives. Without having them in the **PATH**, we will encounter
runtime errors at the very beginning of the problem, and we could not execute successfully our program.

Here's how you can set the *PATH* variable before running your executable in a command prompt or script, and then, just run our program:

```bash
export PATH=$PATH:/path/to/opencv/libs
./build/opencv_example.exe
```

Replace `/path/to/opencv/libs` with the actual path to the directory containing the **OpenCV** dynamic libraries *(DLLs)*. If you're on *Windows* and using *Command Prompt*, the syntax is slightly different

```batch
set PATH=%PATH%;C:\path\to\opencv\libs
cd build
opencv_example.exe
```

If you want to make this change permanently, you can add the OpenCV library path to the system's PATH environment variable through system settings.

Note: Ensure that you include the path to the directory containing the **OpenCV** *DLLs*, not the *DLL* files themselves.

Additionally, make sure to adjust the PATH before running your executable each time, or set it permanently, so your executable can find the necessary OpenCV libraries at runtime.

## Conclusion

This documentation provides an in-depth overview of how we can use our favourite **LLVM** tools for building a project that depends on **OpenCV** without having to build from scracth / download and install it before hand in a *Windows* operating system.

its structure, build process, and configuration options. The project's purpose as a test case for building **OpenCV** using **CMake** is emphasized, and developers are encouraged to explore the source code to gain insights into the integration process. If any issues arise, refer to the provided documentation or seek assistance from the **OpenCV** and **CMake** communities. 

***Happy coding!***
