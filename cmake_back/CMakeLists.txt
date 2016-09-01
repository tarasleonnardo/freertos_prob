cmake_minimum_required(VERSION 3.0.2)

###
# Set desired compiler
include (CMakeForceCompiler)

set(TOOLCHAIN_PREF arm-none-eabi-)
set(CMAKE_C_COMPILER ${TOOLCHAIN_PREF}gcc)

set(TOOLCHAIN_DIR "usr/arm-none-eabi/bin")
set(LINKER_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/ld/STM32L152XE_FLASH.ld")

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR STM32L152)

message("Cmake c compiler: " ${CMAKE_C_COMPILER})
CMAKE_FORCE_C_COMPILER  (${TOOLCHAIN_PREF}gcc GNU)
CMAKE_FORCE_CXX_COMPILER(${TOOLCHAIN_PREF}g++ GNU)


project(freertos_stm32l)

set(APP_NAME frtos_stm32l)

set(PRJ_ROOT ${CMAKE_CURRENT_SOURCE_DIR})

# Include directories
include_directories(freertos_stm32l PUBLIC
                    ${PRJ_ROOT}/CMSIS/CM3/DeviceSupport/ST
                    ${PRJ_ROOT}/CMSIS/CM3/DeviceSupport/ST/STM32L1xx
                    ${PRJ_ROOT}/CMSIS/CM3/CoreSupport
                    )

set(CMAKE_C_FLAGS "-std=c99 -g -O0 -Wall -mthumb -mcpu=cortex-m3 -ffunction-sections -fdata-sections")
message("CMAKE_C_FLAGS: " ${CMAKE_C_FLAGS})


set(CMAKE_C_LINK_FLAGS "-Wl,--print-memory-usage,--gc-sections,-nostdlib -T ${LINKER_SCRIPT}")
message("CMAKE_C_LINK_FLAGS: " ${CMAKE_LINK_FLAGS})

set(SRC
    ${PRJ_ROOT}/main.c 
    ${PRJ_ROOT}/system_stm32l1xx.c
    ${PRJ_ROOT}/startup_stm32l1xx_md.s.txt
   )

#    ${PRJ_ROOT}/CMSIS/CM3/CoreSupport/core_cm3.c
#    ${PRJ_ROOT}/CMSIS/CM3/DeviceSupport/ST/STM32L1xx/startup/arm/startup_stm32l1xx_md.s 

message("SRC: " ${SRC})

add_executable(${APP_NAME}.elf ${SRC})

# link_directories(${CMAKE_CURRENT_SOURCE_DIR}/ld)


#set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--print-memory-usage,--gc-sections")
message("Linker script: " ${LINKER_SCRIPT})
message("Cmake link executable: " ${CMAKE_C_LINK_EXECUTABLE})
message("Cmake compiler: " ${CMAKE_C_COMPILER})
message("Flags: " ${FCLAGS})
message("Shared linker flags init: " ${CMAKE_SHARED_LINKER_FLAGS_INIT})
message("Cmake link flags: " ${CMAKE_C_LINK_FLAGS})
message("Link flags: " ${LINK_FLAGS})
message("Objects: " ${OBJECTS})
message("Targer: " ${TARGET})
message("Link libraries: " ${LINK_LIBRARIES})
message("Cmake system name: " ${CMAKE_SYSTEM_NAME})
