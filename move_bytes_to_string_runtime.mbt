///|
fn[A] unsafe_cast_to_ptr(x : A) -> Ptr = "%identity"

///|
fn[A] moonbit_reinterpret_as_pointer(x : A) -> Ptr {
  let ptr : Ptr = unsafe_cast_to_ptr(x)
  moonbit_decref(ptr)
  ptr
}

///|
fn unsafe_bytes_to_string(bytes : Bytes) -> String = "%identity"

///|
const UInt16_elem_size_shift = 1

///|
/// 
///  Access moved bytes is undefined behavior
/// 
/// change MoonBit header's meta data to UInt16 array and return as String type
/// 
pub fn move_bytes_to_string(bytes : Bytes) -> String {
  let ptr = moonbit_reinterpret_as_pointer(bytes)
  let header = moonbit_make_array_header(
    Moonbit_BLOCK_KIND_VAL_ARRAY,
    UInt16_elem_size_shift,
    bytes.length() >> UInt16_elem_size_shift,
  )
  moonbit_set_array_header(ptr, header)
  unsafe_bytes_to_string(bytes)
}
