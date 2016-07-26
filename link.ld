/* Entry Point */

ENTRY(Reset_Handler)

_estack = 0x20014000;    /* end of RAM */


/* Specify the memory areas */
MEMORY
{
FLASH (rx)      : ORIGIN = 0x8000000, LENGTH = 512K
RAM (xrw)      : ORIGIN = 0x20000000, LENGTH = 80K
}

/* Define output sections */
SECTIONS
{
  .isr_vector :
  {
    . = ALIGN(4);

    KEEP(*(.isr_vector))
		KEEP(*(.init)) 
		KEEP(*(.fini)) 

		/* .rodata sections (constants, strings, etc.) */
    *(.rodata)         
		*(.rodata*)

		/* .text sections (code) */
		*(.text)           
		*(.text.*)

		. = ALIGN(4);
  } > FLASH



  /* used by the startup to initialize data */
  _sidata = LOADADDR(.data);

  /* Initialized data sections goes into RAM, load LMA copy after code */
  .data :
  {
    . = ALIGN(4);
    _sdata = .;        /* create a global symbol at data start */
		*(.data)
		*(.data*)
    . = ALIGN(4);
    _edata = .;        /* define a global symbol at data end */
  } >RAM AT> FLASH

	/* ZI data */
	.bss :
	{
		. = ALIGN(4);
		_sbss = .; /* Start of bss */
		*(.bss)
		*(.bss*)
		*(COMMON)
		. = ALIGN(4);
		_ebss = .; /* The end of bss */
	} > RAM
}

