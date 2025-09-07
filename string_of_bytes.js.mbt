///|
extern "js" fn text_decoder(
  bytes : Bytes,
  byte_offset : Int,
  byte_length : Int,
) -> String =
  #| (bytes,byte_offset , byte_length ) => new TextDecoder('utf-16').decode(new Uint8Array(bytes.buffer,byte_offset,byte_length))

///|
extern "js" fn hybrid(
  bytes : Bytes,
  byte_offset : Int,
  byte_length : Int,
) -> String =
  #| (bytes, byte_offset, byte_length) => {
  #|    if (byte_length - byte_offset <= 512) {
  #|        const end_offset = byte_offset + byte_length;
  #|        let buf = '';
  #|        while (byte_offset < end_offset) {
  #|            buf += String.fromCharCode(bytes[byte_offset] | (bytes[byte_offset + 1] << 8));
  #|            byte_offset += 2;
  #|        }
  #|        return buf;
  #|    } else {
  #|        return new TextDecoder('utf-16').decode(new Uint8Array(bytes.buffer, byte_offset, byte_length))
  #|    }
  #| }

///|
pub fnalias hybrid as string_of_bytes

///|
fn bytes_of_fixedarray(array : FixedArray[Byte]) -> Bytes = "%identity"

///|
fn bench_input(n : Int) -> Bytes {
  let array : FixedArray[Byte] = FixedArray::make(n << 1, 0)
  let mut i = 0
  while i < array.length() {
    array[i] = b'a'
    i += 2
  }
  bytes_of_fixedarray(array)
}

///|
fn bench_string_of_bytes(b : @bench.T, n : Int) -> Unit {
  let input = bench_input(n)
  b.bench(name="len: \{n}, text decode", () => b.keep(
    text_decoder(input, 0, input.length()),
  ))
  b.bench(name="len: \{n}, +=", () => b.keep(Bytes::to_unchecked_string(input)))
  b.bench(name="len: \{n}, hybrid", () => b.keep(
    hybrid(input, 0, input.length()),
  ))
}

///|
test (b : @bench.T) {
  for p in 0..<14 {
    bench_string_of_bytes(b, 1 << p)
  }
}
