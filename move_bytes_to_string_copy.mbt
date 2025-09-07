///|
/// 
///  Access moved bytes is undefined behavior
pub fn move_bytes_to_string(bytes : Bytes) -> String {
  string_of_bytes(bytes, 0, bytes.length())
}
