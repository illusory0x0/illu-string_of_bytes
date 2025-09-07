# String of Bytes

A MoonBit package for converting bytes to strings with efficient memory operations. This package provides utilities for converting UTF-16 LE encoded bytes into MoonBit strings, with support for both copying and move semantics.

## Features

- **Efficient byte-to-string conversion**: Convert UTF-16 LE encoded bytes to strings
- **Substring extraction**: Extract substrings from byte arrays with offset and length
- **Move semantics**: Zero-copy conversion for performance-critical applications
- **Cross-platform**: Works across WASM, JavaScript, and native backends
- **Unicode support**: Full support for Unicode characters including emojis and surrogate pairs

## Installation

```bash
moon add illusory0x0/string_of_bytes
```

## API Reference

### `string_of_bytes(bytes, byte_offset, byte_length)`

Converts a portion of UTF-16 LE encoded bytes to a string.


**Parameters:**
- `bytes: Bytes` - The source byte array
- `byte_offset: Int` - Starting byte offset (must be even for UTF-16)
- `byte_length: Int` - Number of bytes to convert (must be even for UTF-16)

**Returns:** `String`

```moonbit
test "basic string conversion" {
  // "Hello" in UTF-16 LE encoding
  let bytes : Bytes = b"\x48\x00\x65\x00\x6C\x00\x6C\x00\x6F\x00"
  let result = @string_of_bytes.string_of_bytes(bytes, 0, bytes.length())
  inspect(result, content="Hello")
}
```

### Substring Extraction

Extract specific portions of strings from byte arrays:

```moonbit
test "substring extraction" {
  // "Hello World" but extract only "World"
  let bytes : Bytes = b"\x48\x00\x65\x00\x6C\x00\x6C\x00\x6F\x00\x20\x00\x57\x00\x6F\x00\x72\x00\x6C\x00\x64\x00"
  let result = @string_of_bytes.string_of_bytes(bytes, 12, 10) // Skip "Hello " (12 bytes), take "World" (10 bytes)
  inspect(result, content="World")
}
```

### Unicode and Emoji Support

Handle Unicode characters and emoji with surrogate pairs:

```moonbit
test "unicode characters" {
  // Chinese characters "你好" in UTF-16 LE
  let bytes : Bytes = b"\x60\x4F\x7D\x59"
  let result = @string_of_bytes.string_of_bytes(bytes, 0, bytes.length())
  inspect(result, content="你好")
}

test "emoji support" {
  // Grinning face emoji 😀 with surrogate pairs
  let bytes : Bytes = b"\x3D\xD8\x00\xDE"
  let result = @string_of_bytes.string_of_bytes(bytes, 0, bytes.length())
  inspect(result, content="😀")
}
```

### `move_bytes_to_string(bytes)`

Converts bytes to string using move semantics for optimal performance. After calling this function, the original bytes should not be accessed.

**Parameters:**
- `bytes: Bytes` - The source byte array (will be moved)

**Returns:** `String`

**⚠️ Important:** After calling this function, accessing the original `bytes` parameter results in undefined behavior.

```moonbit
test "move semantics conversion" {
  let bytes : Bytes = b"\x48\x00\x65\x00\x6C\x00\x6C\x00\x6F\x00"
  let copied_bytes = copy_bytes(bytes)
  let result = @string_of_bytes.move_bytes_to_string(copied_bytes)
  inspect(result, content="Hello")
  // ⚠️ Do not use 'copied_bytes' after this point!
}
```

### Performance Optimization

For large strings, `move_bytes_to_string` provides zero-copy conversion:

```moonbit
test "large string performance" {
  // Create a larger byte array
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
}
```

### Mixed Character Sets

Handle mixed scripts in a single string:

```moonbit
test "mixed scripts" {
  // "Hi你" - English + Chinese
  let bytes : Bytes = b"\x48\x00\x69\x00\x60\x4F"
  let result = @string_of_bytes.string_of_bytes(bytes, 0, bytes.length())
  inspect(result, content="Hi你")
}
```

### Special Characters and Symbols

Support for various symbols and special characters:

```moonbit
test "special characters" {
  // Mathematical symbols ∑∏∫∆
  let bytes : Bytes = b"\x11\x22\x0F\x22\x2B\x22\x06\x22"
  let result = @string_of_bytes.string_of_bytes(bytes, 0, bytes.length())
  inspect(result, content="∑∏∫∆")
}

test "currency symbols" {
  // Various currency symbols $€£¥₹
  let bytes : Bytes = b"\x24\x00\xAC\x20\xA3\x00\xA5\x00\xB9\x20"
  let result = @string_of_bytes.string_of_bytes(bytes, 0, bytes.length())
  inspect(result, content="$€£¥₹")
}
```

### Empty and Edge Cases

Handle empty strings and edge cases:

```moonbit
test "empty string" {
  let bytes : Bytes = b""
  let result = @string_of_bytes.string_of_bytes(bytes, 0, 0)
  inspect(result, content="")
}

test "null character" {
  let bytes : Bytes = b"\x00\x00"
  let result = @string_of_bytes.string_of_bytes(bytes, 0, 2)
  inspect(result, content="\u0000")
}
```

## UTF-16 Little Endian Format

This package expects bytes to be in UTF-16 Little Endian format:
- Each character is represented by 2 bytes (or 4 bytes for surrogate pairs)
- The least significant byte comes first
- For example, 'A' (U+0041) is encoded as `[0x41, 0x00]`

## Platform Support

- **WASM/WASM-GC**: Uses runtime memory manipulation for optimal performance
- **JavaScript**: Uses copying approach for compatibility
- **Native**: Uses efficient C-based memory operations

## Performance Considerations

- Use `move_bytes_to_string()` when you don't need the original bytes afterward
- Use `string_of_bytes()` when you need to preserve the original data or extract substrings
- Both functions are optimized for their respective use cases across all supported platforms

## License

Apache-2.0
