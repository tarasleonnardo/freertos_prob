# Test makefile


PRJ_ROOT_DIR=$(shell pwd)/
PRJ:=blink
BLD_DIR=$(PRJ_ROOT_DIR)/build

TOOLCHAIN_PREF=arm-none-eabi-

CC=$(TOOLCHAIN_PREF)gcc
LD=$(TOOLCHAIN_PREF)gcc
AS=$(TOOLCHAIN_PREF)gcc

INCLUDE_DIRS:= -I$(PRJ_ROOT_DIR) \
               -I$(PRJ_ROOT_DIR)/CMSIS/CM3/CoreSupport \
               -I$(PRJ_ROOT_DIR)/CMSIS/CM3/DeviceSupport/ST/STM32L1xx \
               -I$(PRJ_ROOT_DIR)/Source/include

C_FLAGS:= -g -Wall -mthumb -mcpu=cortex-m3 -ffunction-sections -fdata-sections

L_FLAGS:= --gc-sections,--print-output-format,--print-memory-usage
LD_SCRIPT:= $(PRJ_ROOT_DIR)/ld/STM32L152XE_FLASH.ld
#LD_SCRIPT= $(PRJ_ROOT_DIR)Blink.ld

A_FLAGS:= -x assembler

OBJ= $(BLD_DIR)/main.o \
     $(BLD_DIR)/startup_stm32l1xx_md.oS \
     $(BLD_DIR)/system_stm32l1xx.o


default: $(OBJ) $(BLD_DIR)/$(PRJ).elf Makefile
	

$(BLD_DIR)/$(PRJ).elf: $(OBJ) $(BLD_DIR)/$(PRJ).elf Makefile
	$(LD) --specs=nosys.specs -Wl,$(L_FLAGS) -T $(LD_SCRIPT) -o $(BLD_DIR)/$(PRJ).elf $(OBJ)

$(BLD_DIR)/main.o : build_dir $(PRJ_ROOT_DIR)/main.c 
	$(CC) -c $(C_FLAGS) $(PRJ_ROOT_DIR)/main.c -o $(BLD_DIR)/main.o -I $(INCLUDE_DIRS) 

$(BLD_DIR)/system_stm32l1xx.o : build_dir $(PRJ_ROOT_DIR)/system_stm32l1xx.c
	$(CC) -c $(C_FLAGS) $(PRJ_ROOT_DIR)/system_stm32l1xx.c -o $(BLD_DIR)/system_stm32l1xx.o $(INCLUDE_DIRS)

$(BLD_DIR)/startup_stm32l1xx_md.oS : build_dir $(PRJ_ROOT_DIR)/startup_stm32l1xx_md.s.txt
	$(AS) -c $(A_FLAGS) $(PRJ_ROOT_DIR)/startup_stm32l1xx_md.s.txt -o $(BLD_DIR)/startup_stm32l1xx_md.oS

.PHONY: build_dir
build_dir:
	-mkdir $(BLD_DIR)

.PHONY: clean

clean:
	rm -f $(OBJ) $(PRJ).elf $(PRJ).hex
