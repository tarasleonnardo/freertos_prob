# Test makefile

APP_NAME := frtos_app

PRJ_ROOT_DIR = $(shell pwd)/
PRJ := blink
BLD_DIR := $(PRJ_ROOT_DIR)/build

CD_BUILD_DIR := cd $(BLD_DIR)

# Common toolchain settings
TOOLCHAIN_PREF = arm-none-eabi-

CC=$(TOOLCHAIN_PREF)gcc
LD=$(TOOLCHAIN_PREF)gcc
AS=$(TOOLCHAIN_PREF)gcc
AR=$(TOOLCHAIN_PREF)ar
OBJCOPY=$(TOOLCHAIN_PREF)objcopy

C_FLAGS:= -g -Wall -mthumb -mcpu=cortex-m3 -ffunction-sections -fdata-sections
L_FLAGS:= --gc-sections,--print-output-format,--print-memory-usage
LD_SCRIPT:= $(PRJ_ROOT_DIR)/ld/STM32L152XE_FLASH.ld
LD_LIB_PATH := /usr/arm-none-eabi/lib/thumb
A_FLAGS:= -x assembler

##############################################################################
##############################################################################

default: $(APP_NAME).elf
	echo Success.

##############################################################################
##############################################################################
### Build FreeRTOS lib ###

FREERTOS_SRC_DIR := $(PRJ_ROOT_DIR)/Source
FREERTOS_PORT_SRC_DIR := $(PRJ_ROOT_DIR)/Source/portable/GCC/ARM_CM3
FREERTOS_MEM_MNG_SRC_DIR := $(PRJ_ROOT_DIR)/Source/portable/MemMang
FREERTOS_BLD_DIR := $(BLD_DIR)/freertos
FREERTOS_LIB_NAME := $(FREERTOS_BLD_DIR)/freertos.a

FREERTOS_INCLUDE_DIRS:= -I$(PRJ_ROOT_DIR) \
                        -I$(FREERTOS_SRC_DIR) \
                        -I$(FREERTOS_SRC_DIR)/include \
                        -I$(FREERTOS_SRC_DIR)/portable/GCC/ARM_CM3

FREERTOS_SRC := $(wildcard $(FREERTOS_SRC_DIR)/*.c) 
FREERTOS_SRC += $(wildcard $(FREERTOS_PORT_SRC_DIR)/*.c)
FREERTOS_SRC += $(wildcard $(FREERTOS_MEM_MNG_SRC_DIR)/*.c)

FREERTOS_OBJ := $(notdir $(FREERTOS_SRC:.c=.o))

#.SILENT:

############################################################################## 

$(FREERTOS_LIB_NAME): $(FREERTOS_SRC)
	echo
	echo
	echo "compilling freertos objects: $(FREERTOS_OBJ)"
	echo
	-@mkdir $(BLD_DIR)
	-@mkdir $(FREERTOS_BLD_DIR)
	echo
	cd $(FREERTOS_BLD_DIR) && \
	$(CC) -c $(C_FLAGS) $(FREERTOS_SRC) $(FREERTOS_INCLUDE_DIRS) && \
	echo "Archiving $(FREERTOS_LIB_NAME)" && \
	$(AR) rcs $(FREERTOS_LIB_NAME) $(FREERTOS_OBJ)

# Build FreeRTOS lib end
##############################################################################
##############################################################################
### Build bsp lib ###
BSP_SRC_DIR := $(PRJ_ROOT_DIR)/system
BSP_BLD_DIR := $(BLD_DIR)/bsp
BSP_LIB_NAME := $(BSP_BLD_DIR)/bsp.a

BSP_INCLUDE_DIRS:= -I$(PRJ_ROOT_DIR)/system \
                   -I$(PRJ_ROOT_DIR)/CMSIS/CM3/CoreSupport \
                   -I$(PRJ_ROOT_DIR)/CMSIS/CM3/DeviceSupport/ST/STM32L1xx
                                    
BSP_SRC := $(wildcard $(BSP_SRC_DIR)/*.c)
BSP_OBJ := $(notdir $(BSP_SRC:.c=.o))

BSP_STARTUP := $(BSP_SRC_DIR)/startup_stm32l1xx_md.s.txt
BSP_STARTUP_O := $(BSP_BLD_DIR)/startup_stm32l1xx_md.so

##############################################################################

$(BSP_LIB_NAME): $(BSP_SRC) $(BSP_STARTUP_O) 
	echo "Prerequisites: $(BSP_SRC) $(BSP_STARTUP)"
	echo
	echo "Compilling bsp objects: $(BSP_OBJ)"
	echo
	@-mkdir $(BLD_DIR)
	@-mkdir $(BSP_BLD_DIR)
	echo
	cd $(BSP_BLD_DIR) && \
	$(CC) -c $(C_FLAGS) $(BSP_SRC) $(BSP_INCLUDE_DIRS) && \
	echo "Archiving $(BSP_LIB_NAME)" && \
	$(AR) rcs $(BSP_LIB_NAME) $(BSP_OBJ) $(BSP_STARTUP_O)

$(BSP_STARTUP_O): $(BSP_STARTUP)
	echo
	echo
	echo "Compilling the startup file"
	@-mkdir $(BLD_DIR)
	@-mkdir $(BSP_BLD_DIR)
	echo
	$(AS) -c -g $(A_FLAGS) -o $(BSP_STARTUP_O) $(BSP_STARTUP)

# Build bsp lib end ###
##############################################################################
##############################################################################
### Build the application lib ###
APP_LIB_SRC_DIR := $(PRJ_ROOT_DIR)
APP_LIB_BLD_DIR := $(BLD_DIR)/app
APP_LIB_NAME := $(APP_LIB_BLD_DIR)/app.a

APP_LIB_INCLUDE_DIRS:= -I$(PRJ_ROOT_DIR) \
                         $(BSP_INCLUDE_DIRS) \
                         $(FREERTOS_INCLUDE_DIRS)

APP_LIB_SRC := $(wildcard $(APP_LIB_SRC_DIR)/*.c)
APP_LIB_OBJ := $(notdir $(APP_LIB_SRC:.c=.o))


##############################################################################

$(APP_LIB_NAME): $(APP_LIB_SRC)
	echo
	echo
	echo "Compilling application files: $(APP_LIB_SRC)"
	echo
	-@mkdir $(BLD_DIR)
	-@mkdir $(APP_LIB_BLD_DIR)
	echo
	cd $(APP_LIB_BLD_DIR) && \
	$(CC) -c $(C_FLAGS) $(APP_LIB_SRC) $(APP_LIB_INCLUDE_DIRS) && \
	echo "Archiving $(APP_LIB_NAME)" && \
	$(AR) rcs $(APP_LIB_NAME) $(APP_LIB_OBJ)

### Build the application lib ###
##############################################################################
##############################################################################
LINK_LIBRARIES := -l:$(notdir $(FREERTOS_LIB_NAME)) -l:$(notdir $(BSP_LIB_NAME)) -l:$(notdir $(APP_LIB_NAME))
LINK_PATHES := -L $(dir $(FREERTOS_LIB_NAME)) -L $(dir $(BSP_LIB_NAME)) -L $(dir $(APP_LIB_NAME))

APP_HEADERS := $(wildcard $(APP_LIB_INCLUDE_DIRS)/*.h)

$(APP_NAME).elf: $(FREERTOS_LIB_NAME) $(BSP_LIB_NAME) $(APP_LIB_NAME) $(APP_HEADERS)
	echo Linking the application
	-@mkdir $(BLD_DIR)
	cd $(BLD_DIR) && \
	$(LD) -Wl,$(L_FLAGS) -T $(LD_SCRIPT) -o $(APP_NAME).elf -Wl,--start-group $(APP_LIB_NAME) $(FREERTOS_LIB_NAME) $(BSP_LIB_NAME) -lc -Wl,--end-group -L $(LD_LIB_PATH) && \
	echo Creating $(APP_NAME).hex && \
	$(OBJCOPY) -O ihex $(APP_NAME).elf $(APP_NAME).hex

##############################################################################
##############################################################################

.PHONY: clean
clean:
	-rm -r -f $(BLD_DIR)/*
