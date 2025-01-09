// Code specific to the rocket-chip platform

#include "platform.h"
#include "uart.h"
#include "clint.h"
#include "cheshire_regs.h"
#include "util.h"

// =========
// DRAM Base
// =========

char const* HEAP_BASE = (char const*) 0x80001000;

// ==============
// Console output
// ==============

// Character buffer
/*static char consoleBuffer[64] __attribute__((aligned(64)));
static uint64_t consoleBufferLen = 0;*/

/*void flush()
{
  volatile uint64_t cmd[8] __attribute__((aligned(64)));

  if (consoleBufferLen > 0) {
    cmd[0] = 64; // Write system call
    cmd[1] = 1;  // To stdout
    cmd[2] = (uint64_t) consoleBuffer;
    cmd[3] = consoleBufferLen;

    asm volatile (
      "fence                    \n"
      "csrw   0x7c0, %0         \n"
      "1:                       \n"
      "csrrw  a0, 0x7c1, 0      \n"
      "beqz   a0, 1b            \n"
    : // output operands 
    : // input operands 
      "r"(cmd)
    : // clobbered registers 
      "a0"
    );

    consoleBufferLen = 0;
  }
}*/
/*void flush()
{
  //consoleBuffer[consoleBufferLen++] = '\0';
  print_uart(consoleBuffer,consoleBufferLen);
  consoleBufferLen = 0;

}*/
void put_char(char c)
{

  /*consoleBuffer[consoleBufferLen++] = c;
  if (c == '\n' || consoleBufferLen == sizeof(consoleBuffer)) flush();*/
  write_serial(c);
}

void plat_exit(int code)
{
  uart_write_flush();
  *reg32((void*)0x3000000, CHESHIRE_SCRATCH_2_REG_OFFSET) = (code << 1) | 1;
  asm volatile ("fence");
}

void plat_init_uart()
{
  uint32_t rtc_freq = *reg32((void*)0x3000000, CHESHIRE_RTC_FREQ_REG_OFFSET);
  uint64_t reset_freq = clint_get_core_freq(rtc_freq, 2500);
  init_uart(reset_freq, 115200);
}
