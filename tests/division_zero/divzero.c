#include <stdint.h>

uint32_t division(uint32_t x, uint32_t y) {
  if (y != 0) 
 	  return x / y;
  return 0;
}

uint32_t division_bug(uint32_t x, uint32_t y) {
  return x/y;
}
