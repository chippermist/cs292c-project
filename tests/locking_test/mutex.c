#include <stdint.h>

uint32_t lock;
uint32_t count;

/**
  * Set the value of count
  **/
void set_count_value(uint32_t x) {
    count = x;
}

/**
  * Get the value of count
  **/
uint32_t get_count_value(void) {
    return count;
}

/**
  * Set the value of lock
  **/
void set_lock_value(uint32_t x) {
    lock = x;
}

/**
  * Get the value of lock
  **/
uint32_t get_lock_value(void) {
    return lock;
}

/**
  * Set
  **/
int32_t increment_count(uint32_t x) {
  if(get_lock_value() != 0) return -1;
  lock++;
  count = count+x;
  // while(x) {}
  lock--;
  return 0;
}

/**
  * Get
  **/
int32_t get_count(void) {
  // this is because it cannot detect deadlocks using wait() 
  if(get_lock_value() != 0) return -1;
  int x;
  lock++;
  x = count;
  lock--;
  return x;
}
