///|
#external
priv type Ptr

///|
extern "c" fn moonbit_make_array_header(
  kind : Int,
  elem_size_shift : Int,
  len : Int,
) -> Int = "illusory0x0_moonbit_make_array_header"

///|
extern "c" fn moonbit_decref(ptr : Ptr) = "moonbit_decref"

///|
extern "c" fn moonbit_set_array_header(array : Ptr, header : Int) = "illusory0x0_moonbit_set_array_header"

///|
const Moonbit_BLOCK_KIND_VAL_ARRAY = 2
