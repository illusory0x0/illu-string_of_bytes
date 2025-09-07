///|
#owned(bytes)
pub fn string_of_bytes(
  bytes : Bytes,
  byte_offset : Int,
  byte_length : Int,
) -> String = "$moonbit.unsafe_bytes_sub_string"
