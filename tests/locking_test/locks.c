#include <stdint.h>

uint32_t test_lock(uint32_t a, uint32_t b) {
  uint32_t lock = 0;
  lock++;
  uint32_t res = a + b;
  lock--;
  return res;
}
