ENTRY(kernel_main)

SECTIONS
{
  . = 0x7E00;

  .text : {
    *(.text)
  }

  .rodata : {
    *(.rodata)
  }

  .data : {
    *(.data)
  }

  .bss : {
    *(.bss)
  }
}

MEMORY
{
  text (rx) : ORIGIN = 0x7E00, LENGTH = 64K
  rodata (r) : ORIGIN = 0x8E00, LENGTH = 64K
  data (rw) : ORIGIN = 0x9E00, LENGTH = 64K
  bss  (rw) : ORIGIN = 0xAE00, LENGTH = 64K
}
