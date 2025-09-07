#include <moonbit.h> 
#include <stdint.h>


void illusory0x0_moonbit_set_array_header(void* array, uint32_t meta) {
  struct moonbit_object* obj = Moonbit_object_header(array);
  obj->meta = meta;
}

int32_t illusory0x0_moonbit_make_array_header(int32_t kind, int32_t elem_size_shift, int32_t length) {
  return Moonbit_make_array_header(kind,  elem_size_shift,  length);
}