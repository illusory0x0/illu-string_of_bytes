///|
typealias Int as Ptr

///|
fn moonbit_make_array_header(
  kind : Int,
  elem_size_shift : Int,
  len : Int,
) -> Int = "$moonbit.make_array_header"

///|
fn moonbit_decref(ptr : Ptr) = "$moonbit.decref"

///|
extern "wasm" fn moonbit_set_array_header(array : Ptr, header : Int) =
  #| (func (param $array i32) (param $header i32)
  #|     (local.get $array)
  #|     (local.get $header)
  #|     (i32.store offset=4 align=1)
  #| )
  #|

///|
const Moonbit_BLOCK_KIND_VAL_ARRAY = 1
