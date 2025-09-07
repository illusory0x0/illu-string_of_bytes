///|
/// Test basic ASCII characters
test "string_of_bytes basic ASCII" {
  // "Hello" in UTF-16 LE: H=0x48, e=0x65, l=0x6C, l=0x6C, o=0x6F
  let bytes : Bytes = b"\x48\x00\x65\x00\x6C\x00\x6C\x00\x6F\x00"
  let result = @string_of_bytes.string_of_bytes(bytes, 0, bytes.length())
  inspect(result, content="Hello")
}

///|
/// Test empty string
test "string_of_bytes empty" {
  let bytes : Bytes = b""
  let result = @string_of_bytes.string_of_bytes(bytes, 0, 0)
  inspect(result, content="")
}

///|
/// Test single character
test "string_of_bytes single char" {
  // "A" in UTF-16 LE: A=0x41
  let bytes : Bytes = b"\x41\x00"
  let result = @string_of_bytes.string_of_bytes(bytes, 0, bytes.length())
  inspect(result, content="A")
}

///|
/// Test with offset and length
test "string_of_bytes with offset" {
  // "Hello World" but we only want "World"
  // H=0x48, e=0x65, l=0x6C, l=0x6C, o=0x6F, space=0x20, W=0x57, o=0x6F, r=0x72, l=0x6C, d=0x64
  let bytes : Bytes = b"\x48\x00\x65\x00\x6C\x00\x6C\x00\x6F\x00\x20\x00\x57\x00\x6F\x00\x72\x00\x6C\x00\x64\x00"
  let result = @string_of_bytes.string_of_bytes(bytes, 12, 10) // Skip "Hello " (6 chars * 2 bytes = 12), take "World" (5 chars * 2 bytes = 10)
  inspect(result, content="World")
}

///|
/// Test Unicode characters (non-ASCII)
test "string_of_bytes unicode" {
  // "你好" (Chinese for "Hello") in UTF-16 LE
  // 你 = 0x4F60, 好 = 0x597D
  let bytes : Bytes = b"\x60\x4F\x7D\x59"
  let result = @string_of_bytes.string_of_bytes(bytes, 0, bytes.length())
  inspect(result, content="你好")
}

///|
/// Test mixed ASCII and Unicode
test "string_of_bytes mixed" {
  // "Hi你" - H=0x48, i=0x69, 你=0x4F60
  let bytes : Bytes = b"\x48\x00\x69\x00\x60\x4F"
  let result = @string_of_bytes.string_of_bytes(bytes, 0, bytes.length())
  inspect(result, content="Hi你")
}

///|
/// Test emojis (surrogate pairs)
test "string_of_bytes emoji" {
  // "😀" (grinning face) in UTF-16 LE surrogate pairs
  // High surrogate: 0xD83D, Low surrogate: 0xDE00
  let bytes : Bytes = b"\x3D\xD8\x00\xDE"
  let result = @string_of_bytes.string_of_bytes(bytes, 0, bytes.length())
  inspect(result, content="😀")
}

///|
/// Test numbers and symbols
test "string_of_bytes numbers and symbols" {
  // "123!@#" in UTF-16 LE
  // 1=0x31, 2=0x32, 3=0x33, !=0x21, @=0x40, #=0x23
  let bytes : Bytes = b"\x31\x00\x32\x00\x33\x00\x21\x00\x40\x00\x23\x00"
  let result = @string_of_bytes.string_of_bytes(bytes, 0, bytes.length())
  inspect(result, content="123!@#")
}

///|
/// Test partial extraction from middle
test "string_of_bytes partial middle" {
  // "ABCDEF" but extract "CDE"
  // A=0x41, B=0x42, C=0x43, D=0x44, E=0x45, F=0x46
  let bytes : Bytes = b"\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00"
  let result = @string_of_bytes.string_of_bytes(bytes, 4, 6) // Skip "AB" (4 bytes), take "CDE" (6 bytes)
  inspect(result, content="CDE")
}

///|
/// Test special whitespace characters
test "string_of_bytes whitespace" {
  // "\t\n\r " (tab, newline, carriage return, space) in UTF-16 LE
  // tab=0x09, newline=0x0A, CR=0x0D, space=0x20
  let bytes : Bytes = b"\x09\x00\x0A\x00\x0D\x00\x20\x00"
  let result = @string_of_bytes.string_of_bytes(bytes, 0, bytes.length())
  inspect(result, content="\t\n\r ")
}

///|
/// Test zero byte offset with partial length
test "string_of_bytes zero offset partial" {
  // "Testing" but only take first 4 characters "Test"
  // T=0x54, e=0x65, s=0x73, t=0x74, i=0x69, n=0x6E, g=0x67
  let bytes : Bytes = b"\x54\x00\x65\x00\x73\x00\x74\x00\x69\x00\x6E\x00\x67\x00"
  let result = @string_of_bytes.string_of_bytes(bytes, 0, 8) // Take first 8 bytes (4 characters)
  inspect(result, content="Test")
}

///|
/// Test with null character (U+0000)
test "string_of_bytes null character" {
  // Null character in UTF-16 LE: 0x0000
  let bytes : Bytes = b"\x00\x00"
  let result = @string_of_bytes.string_of_bytes(bytes, 0, 2)
  inspect(result, content="\u0000")
}

///|
/// Test long string to verify performance characteristics
test "string_of_bytes long string" {
  // Create a longer string: "ABCD" repeated to test larger inputs
  let byte_array : Array[Byte] = []
  for i = 0; i < 20; i = i + 1 { // 20 repetitions = 80 chars = 160 bytes
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
  let result = @string_of_bytes.string_of_bytes(bytes, 0, bytes.length())
  // Should be "ABCD" repeated 20 times
  inspect(
    result,
    content="ABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCD",
  )
}

///|
/// Test with zero length extraction
test "string_of_bytes zero length" {
  let bytes : Bytes = b"\x48\x00\x65\x00\x6C\x00\x6C\x00\x6F\x00"
  let result = @string_of_bytes.string_of_bytes(bytes, 2, 0) // Zero length at offset 2
  inspect(result, content="")
}

///|
/// Test edge case: offset at end of string
test "string_of_bytes offset at end" {
  let bytes : Bytes = b"\x48\x00\x69\x00" // "Hi"
  let result = @string_of_bytes.string_of_bytes(bytes, 4, 0) // Offset at end
  inspect(result, content="")
}
