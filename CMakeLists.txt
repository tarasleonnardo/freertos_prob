cmake_minimum_required(VERSION 2.8)



set(TOOLCHAIN_PREF arm-none-eabi-)
#set(CMAKE_C_COMPILER ${TOOLCHAIN_PREF}gcc)

set(TOOLCHAIN_DIR "usr/arm-none-eabi/bin")

# Set desired compiler
include (CMakeForceCompiler)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR STM32L152)
CMAKE_FORCE_C_COMPILER   (${TOOLCHAIN_PREF}gcc GNU)
CMAKE_FORCE_CXX_COMPILER(${TOOLCHAIN_PREF}g++ GNU)


set(CMAKE_C_FLAGS "-c -g -O0 -ffunction-sections -fdata-sections -mthumb")


# Source files
set(SOURCE_EXE main.c)
set(SOURCE main.c)


add_executable(main ${SOURCE_EXE})


