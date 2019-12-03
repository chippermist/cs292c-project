#include <stdint.h>

uint32_t lock;
uint32_t count;

void set_count_value(uint32_t x) {
    count = x;
}

uint32_t get_count_value(void) {
    return count;
}

void set_lock_value(uint32_t x) {
    lock = x;
}

uint32_t get_lock_value(void) {
    return lock;
}

int32_t increment_count(uint32_t x) {
  if(lock != 0) return -1;
  lock++;
  count = count+x;
  // while(1) {}
  lock--;
  return 0;
}

int32_t get_count(void) {
  if(lock != 0) return -1;
  lock++;
  int x = count;
  lock--;
  return 0;
}
