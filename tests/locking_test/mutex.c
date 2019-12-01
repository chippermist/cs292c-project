#include <stdint.h>

uint32_t lock;
uint32_t count;

int32_t increment_count(uint32_t x) {
  if(lock != 0) return -1;
  lock++;
  count = count+x;
  while(1) {}
  lock--;
  return 0;
}

int32_t get_count(uint32_t x) {
  if(lock != 0) return -1;
  lock++;
  x = count;
  lock--;
  return 0;
}
