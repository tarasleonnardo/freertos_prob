# Test makefile


PRJ_ROOT_DIR = $(shell pwd)/
PRJ := blink
BLD_DIR := $(PRJ_ROOT_DIR)/build
FREERTOS_SRC_DIR := $(PRJ_ROOT_DIR)/Source
FREERTOS_PORT_SRC_DIR := $(PRJ_ROOT_DIR)/Source/portable/GCC_ARM_CM3

FREERTOS_LIB = $(BUILD_DIR)/freertos/freertos.a

TOOLCHAIN_PREF = arm-none-eabi-

CC=$(TOOLCHAIN_PREF)gcc
LD=$(TOOLCHAIN_PREF)gcc
AS=$(TOOLCHAIN_PREF)gcc

INCLUDE_DIRS:= -I$(PRJ_ROOT_DIR) \
               -I$(PRJ_ROOT_DIR)/CMSIS/CM3/CoreSupport \
               -I$(PRJ_ROOT_DIR)/CMSIS/CM3/DeviceSupport/ST/STM32L1xx \
               -I$(PRJ_ROOT_DIR)/Source/include \
               -I$(PRJ_ROOT_DIR)/Source/portable/GCC/ARM_CM3

C_FLAGS:= -g -Wall -mthumb -mcpu=cortex-m3 -ffunction-sections -fdata-sections

L_FLAGS:= --gc-sections,--print-output-format,--print-memory-usage
LD_SCRIPT:= $(PRJ_ROOT_DIR)/ld/STM32L152XE_FLASH.ld
#LD_SCRIPT= $(PRJ_ROOT_DIR)Blink.ld

A_FLAGS:= -x assembler



default: $(OBJ) $(SRC) $(BLD_DIR)/$(PRJ).elf Makefile
	

$(BLD_DIR)/$(PRJ).elf: $(BLD_DIR)/$(PRJ).elf Makefile $(BUILD_DIR)/freertos/%.o $(BUILD_DIR)/%.o
	$(LD) --specs=nosys.specs -Wl,$(L_FLAGS) -T $(LD_SCRIPT) -o $(BLD_DIR)/$(PRJ).elf $(OBJ)

$(BLD_DIR)/%.o : $(PRJ_ROOT_DIR)/%.c 
	$(CC) -c $(C_FLAGS) $< -o $@ $(INCLUDE_DIRS) 


$(BUILD_DIR)/freertos/%.o : $(FREERTOS_SRC_DIR)/%.c
	-mkdir $(BUILD_DIR)/freertos
	$(CC) -c $(C_FLAGS) $< -o $@ $(INCLUDE_DIRS)


$(BLD_DIR)/startup_stm32l1xx_md.oS : build_dir $(PRJ_ROOT_DIR)/startup_stm32l1xx_md.s.txt
	$(AS) -c $(A_FLAGS) $(PRJ_ROOT_DIR)/startup_stm32l1xx_md.s.txt -o $(BLD_DIR)/startup_stm32l1xx_md.oS

FREERTOS_SRC = $(FREERTOS_SRC_DIR)/%.c
FREERTOS_OBJ = $(BUILD_DIR)/freertos/%.o

# build freertos
$(FREERTOS_LIB) : $(FREERTOS_OBJ)

$(BUILD_DIR)/freertos/%.o : $(FREERTOS_SRC_DIR)/%.c
	$(CC) -c $(C_FLAGS) $< -o $@ $(INCLUDE_DIRS)

.PHONY: build_dir
build_dir:
	-mkdir $(BLD_DIR)

.PHONY: clean

clean:
	rm -f $(OBJ) $(PRJ).elf $(PRJ).hex
