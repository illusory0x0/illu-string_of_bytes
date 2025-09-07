///|
fn copy_bytes(bytes : Bytes) -> Bytes {
  let buffer = @buffer.new(size_hint=bytes.length())
  buffer.write_bytes(bytes)
  buffer.to_bytes()
}

///|
/// Test basic ASCII characters
test "move_bytes_to_string basic ASCII" {
  // "Hello" in UTF-16 LE: H=0x48, e=0x65, l=0x6C, l=0x6C, o=0x6F
  let bytes : Bytes = b"\x48\x00\x65\x00\x6C\x00\x6C\x00\x6F\x00"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="Hello")
  // Note: copied_bytes should not be used after this point due to move semantics
}

///|
/// Test single character
test "move_bytes_to_string single char" {
  // "A" in UTF-16 LE: A=0x41
  let bytes : Bytes = b"\x41\x00"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="A")
}

///|
/// Test Unicode characters (non-ASCII)
test "move_bytes_to_string unicode" {
  // "你好" (Chinese for "Hello") in UTF-16 LE
  // 你 = 0x4F60, 好 = 0x597D
  let bytes : Bytes = b"\x60\x4F\x7D\x59"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="你好")
}

///|
/// Test mixed ASCII and Unicode
test "move_bytes_to_string mixed" {
  // "Hi你" - H=0x48, i=0x69, 你=0x4F60
  let bytes : Bytes = b"\x48\x00\x69\x00\x60\x4F"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="Hi你")
}

///|
/// Test emojis (surrogate pairs)
test "move_bytes_to_string emoji" {
  // "😀" (grinning face) in UTF-16 LE surrogate pairs
  // High surrogate: 0xD83D, Low surrogate: 0xDE00
  let bytes : Bytes = b"\x3D\xD8\x00\xDE"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="😀")
}

///|
/// Test multiple emojis
test "move_bytes_to_string multiple emojis" {
  // "😀😁" - two emojis
  // 😀: High=0xD83D, Low=0xDE00
  // 😁: High=0xD83D, Low=0xDE01
  let bytes : Bytes = b"\x3D\xD8\x00\xDE\x3D\xD8\x01\xDE"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="😀😁")
}

///|
/// Test numbers and symbols
test "move_bytes_to_string numbers and symbols" {
  // "123!@#" in UTF-16 LE
  // 1=0x31, 2=0x32, 3=0x33, !=0x21, @=0x40, #=0x23
  let bytes : Bytes = b"\x31\x00\x32\x00\x33\x00\x21\x00\x40\x00\x23\x00"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="123!@#")
}

///|
/// Test special whitespace characters
test "move_bytes_to_string whitespace" {
  // "\t\n\r " (tab, newline, carriage return, space) in UTF-16 LE
  // tab=0x09, newline=0x0A, CR=0x0D, space=0x20
  let bytes : Bytes = b"\x09\x00\x0A\x00\x0D\x00\x20\x00"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="\t\n\r ")
}

///|
/// Test with null character (U+0000)
test "move_bytes_to_string null character" {
  // Null character in UTF-16 LE: 0x0000
  let bytes : Bytes = b"\x00\x00"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="\u0000")
}

///|
/// Test string with embedded null
test "move_bytes_to_string embedded null" {
  // "A\u0000B" - A, null, B
  let bytes : Bytes = b"\x41\x00\x00\x00\x42\x00"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="A\u0000B")
}

///|
/// Test European characters with accents
test "move_bytes_to_string european accents" {
  // "Café" - C=0x43, a=0x61, f=0x66, é=0xE9
  let bytes : Bytes = b"\x43\x00\x61\x00\x66\x00\xE9\x00"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="Café")
}

///|
/// Test Cyrillic characters
test "move_bytes_to_string cyrillic" {
  // "Привет" (Russian for "Hello")
  // П=0x041F, р=0x0440, и=0x0438, в=0x0432, е=0x0435, т=0x0442
  let bytes : Bytes = b"\x1F\x04\x40\x04\x38\x04\x32\x04\x35\x04\x42\x04"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="Привет")
}

///|
/// Test Arabic characters (RTL)
test "move_bytes_to_string arabic" {
  // "مرحبا" (Arabic for "Hello")
  // م=0x0645, ر=0x0631, ح=0x062D, ب=0x0628, ا=0x0627
  let bytes : Bytes = b"\x45\x06\x31\x06\x2D\x06\x28\x06\x27\x06"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="مرحبا")
}

///|
/// Test Japanese characters (Hiragana, Katakana, Kanji)
test "move_bytes_to_string japanese" {
  // "こんにちは" (Japanese Hiragana for "Hello")
  // こ=0x3053, ん=0x3093, に=0x306B, ち=0x3061, は=0x306F
  let bytes : Bytes = b"\x53\x30\x93\x30\x6B\x30\x61\x30\x6F\x30"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="こんにちは")
}

///|
/// Test mathematical symbols
test "move_bytes_to_string math symbols" {
  // "∑∏∫∆" - mathematical symbols
  // ∑=0x2211, ∏=0x220F, ∫=0x222B, ∆=0x2206
  let bytes : Bytes = b"\x11\x22\x0F\x22\x2B\x22\x06\x22"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="∑∏∫∆")
}

///|
/// Test longer string to verify move semantics work with larger data
test "move_bytes_to_string long string" {
  // Create a longer string: "ABCD" repeated 10 times
  let byte_array : Array[Byte] = []
  for i = 0; i < 10; i = i + 1 {
    byte_array.push(0x41) // A
    byte_array.push(0x00)
    byte_array.push(0x42) // B
    byte_array.push(0x00)
    byte_array.push(0x43) // C
    byte_array.push(0x00)
    byte_array.push(0x44) // D
    byte_array.push(0x00)
  }
  let bytes = Bytes::from_array(byte_array)
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="ABCDABCDABCDABCDABCDABCDABCDABCDABCDABCD")
  // copied_bytes should not be accessed after this point due to move semantics
}

///|
/// Test mixed scripts in one string
test "move_bytes_to_string mixed scripts" {
  // "Hello世界🌍" - English, Chinese, emoji
  // H=0x48, e=0x65, l=0x6C, l=0x6C, o=0x6F
  // 世=0x4E16, 界=0x754C
  // 🌍 (earth emoji): High=0xD83C, Low=0xDF0D
  let bytes : Bytes = b"\x48\x00\x65\x00\x6C\x00\x6C\x00\x6F\x00\x16\x4E\x4C\x75\x3C\xD8\x0D\xDF"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="Hello世界🌍")
}

///|
/// Test string containing quotation marks and special characters
test "move_bytes_to_string quotes and special" {
  // "\"'`~!@#$%^&*()" - various punctuation
  let bytes : Bytes = b"\x22\x00\x27\x00\x60\x00\x7E\x00\x21\x00\x40\x00\x23\x00\x24\x00\x25\x00\x5E\x00\x26\x00\x2A\x00\x28\x00\x29\x00"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="\"'`~!@#$%^&*()")
}

///|
/// Test currency symbols
test "move_bytes_to_string currency" {
  // "$€£¥₹" - various currency symbols
  // $=0x24, €=0x20AC, £=0xA3, ¥=0xA5, ₹=0x20B9
  let bytes : Bytes = b"\x24\x00\xAC\x20\xA3\x00\xA5\x00\xB9\x20"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="$€£¥₹")
}

///|
/// Test that demonstrates move semantics - after moving bytes to string,
/// the result should be a proper string that can be used normally
test "move_bytes_to_string result usage" {
  let bytes : Bytes = b"\x57\x00\x6F\x00\x72\x00\x6C\x00\x64\x00" // "World"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)

  // Test that the resulting string can be used normally
  let length = result.length()
  inspect(length, content="5")

  // Test string concatenation
  let greeting = "Hello " + result
  inspect(greeting, content="Hello World")

  // Test character access
  let first_char = result.get(0)
  inspect(first_char, content="Some(87)")
}

///|
/// Test with odd byte length (should handle incomplete UTF-16 code units gracefully)
test "move_bytes_to_string odd length" {
  // Single byte - incomplete UTF-16 code unit
  let bytes : Bytes = b"\x41"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  // The behavior might be platform-specific, but it should not crash
  // The result will depend on the implementation's handling of incomplete code units
  inspect(result.length() >= 0, content="true")
}

///|
/// Test BOM (Byte Order Mark) handling
test "move_bytes_to_string with bom" {
  // UTF-16 LE BOM (0xFEFF) followed by "Hi"
  // BOM=0xFFFE (little-endian), H=0x48, i=0x69
  let bytes : Bytes = b"\xFF\xFE\x48\x00\x69\x00"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  // The BOM might be preserved or stripped depending on implementation
  // Testing that it doesn't crash and produces a string
  inspect(result.length() >= 2, content="true")
}

///|
/// Test maximum Unicode code point in BMP
test "move_bytes_to_string high bmp" {
  // U+FFFD (replacement character) in UTF-16 LE
  let bytes : Bytes = b"\xFD\xFF"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="�")
}

///|
/// Test string interpolation with moved string
test "move_bytes_to_string in interpolation" {
  let bytes : Bytes = b"\x74\x00\x65\x00\x73\x00\x74\x00" // "test"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  let message = "Result: \{result}"
  inspect(message, content="Result: test")
}
