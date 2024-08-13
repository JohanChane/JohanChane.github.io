+++ 
draft = false
date = 2024-08-13T09:33:25+08:00
title = ""
description = ""
slug = ""
authors = []
tags = []
categories = []
externalLink = ""
series = []
+++

# Protocol Buffer 的编码

## Variant 编码

Variant 编码是一种无符号的变长编码，每个字节的最高位（第8位）用来表示是否有后续字节（如果是1，则表示后面还有更多字节；如果是0，则这是最后一个字节），其余7位用来表示数值。

## zigzag 编码

zigzag 可以将有符号整数转为无符号整数。然后再用 variant 编码压缩即可。

encode:
-   将 value 的符号位放在数字的尾部。
-   如果负数, 则对数据位取反。

十进制 `1`:

-   二进制: **0**0000000 00000000 00000000 00000001
-   ZigZag: 00000000 00000000 00000000 0000001**0**     # 符号位放在尾部

十进制 `-2`:

-   二进制: **1**1111111 11111111 11111111 11111110
-   ZigZag
    -   11111111 11111111 11111111 1111110**1**     # 符号位放在尾部
    -   00000000 00000000 00000000 0000001**1**     # 数据位取反

## For example

```cpp

#include <stdint.h>
#include <stdio.h>

// value 后面的分组在 buffer 前面的编码组。
void encode_varint(uint32_t value, uint8_t *buffer, size_t *length) {
  size_t index = 0;
  while (value >= 0x80) { // 是否还有编码组
    buffer[index] = (uint8_t)(value | 0x80);
    value >>= 7; // 取下一组 7 位
    index++;
  }
  buffer[index] = (uint8_t)(value); // 最后一组编码组, 最高位为 0。
  index++;
  *length = index; // 返回编码组的数量
}

// buffer 后面的编码组放在 value 的前面。
void decode_varint(const uint8_t *buffer, size_t length, uint32_t *value) {
  *value = (uint32_t)buffer[length - 1]
           << (7 * (length - 1)); // 取出最后一个编码组 (最高位为 0)
  for (size_t i = 0, offset = 0; i < length - 1; i++, offset += 7) {
    *value += (uint32_t)(buffer[i] - 0x80)
              << offset; // 取出其余编码组 (最高位为 1)。
  }
}

/*
zigzag 的实现方法:
-   数据位使用 `x ^ y ^ y = x`
-   符号位使用 `0 ^ sign = sign`
*/
uint32_t zigzag_encode(int32_t value) {
  return (value << 1) ^
         (value >>
          31); // 去除符号位得到数据位 (最低位为 0), 然后用符号位与之异或。
}

int32_t zigzag_decode(uint32_t encoded_value) {
  // (~(encoded_value & 1) + 1)) == (-(encoded_value & 1))
  // pow(2, 32) - 1 = x + ~x => pow(2, 32) - 1 = (encoded_value & 1) + ~(encoded_value & 1)
  //    => ~(encoded_value & 1) = (pow(2, 32) + (-(encoded_value & 1)) + 1) mod pow(2, 32)
  //    => -(encoded_value & 1) + 1

  //return (encoded_value >> 1) ^
  //       (-(encoded_value & 1));

  // OR
  return (encoded_value >> 1) ^
         (~(encoded_value & 1) + 1); // 去除符号位得到数据位 (最高位为 0), 然后用符号位与之异或。
}

void print_binary(const uint8_t *buffer, size_t length) {
  for (size_t i = 0; i < length; i++) {
    for (int j = 7; j >= 0; j--) {
      printf("%d", (buffer[i] >> j) & 1);
    }
    printf(" ");
  }
  printf("\n");
}

void print_unsigned_value(uint32_t value) {
  printf("Decimal value: %u\n", value);

  // 打印 7 位二进制表示
  printf("7-bit binary representation: ");
  for (int i = sizeof(value) * 8 / 7; i >= 0; i--) {
    uint8_t byte = (value >> (i * 7)) & 0x7F;

    for (int j = 6; j >= 0; j--) {
      printf("%d", (byte >> j) & 1);
    }
    printf(" ");
  }
  printf("\n");
}

void test_variant() {
  printf("--- variant ---\n");

  uint32_t original_value = 123456; // 要编码的整数
  printf("# ## Original value\n");
  print_unsigned_value(original_value);

  // ## 编码整数
  uint8_t buffer[10];    // 存放编码结果的缓冲区
  size_t encoded_length; // 编码结果的长度
  encode_varint(original_value, buffer, &encoded_length);
  printf("# ## Encoded bytes\n");
  print_binary(buffer, encoded_length);

  // ## 解码整数
  uint32_t decoded_value;
  decode_varint(buffer, encoded_length, &decoded_value);
  printf("# ## Decoded value\n");
  print_unsigned_value(decoded_value);
}

void print_signed_value(int32_t value) {
  printf("Decimal value: %d\n", value);

  printf("8-bit binary representation: ");
  for (int i = sizeof(value) * 8 / 7; i >= 0; i--) {
    uint8_t byte = (value >> (i * 7)) & 0x7F;

    for (int j = 6; j >= 0; j--) {
      printf("%d", (byte >> j) & 1);
    }
    printf(" ");
  }
  printf("\n");
}

void test_zigzag() {
  printf("--- zigzag ---\n");
  uint32_t encoded_value, decoded_value;

  int32_t original_value1 = 1;
  printf("# ## Original value\n");
  print_signed_value(original_value1);
  encoded_value = zigzag_encode(original_value1);
  print_signed_value(encoded_value);
  decoded_value = zigzag_decode(encoded_value);
  print_signed_value(decoded_value);

  int32_t original_value2 = -2;
  printf("# ## Original value\n");
  print_signed_value(original_value2);
  encoded_value = zigzag_encode(original_value2);
  print_signed_value(encoded_value);
  decoded_value = zigzag_decode(encoded_value);
  print_signed_value(decoded_value);
}

int main() {
  test_variant();
  test_zigzag();
  return 0;
}
```

output:

```
--- variant ---
# ## Original value
Decimal value: 123456
7-bit binary representation: 0000000 0000000 0000111 1000100 1000000 
# ## Encoded bytes
11000000 11000100 00000111 
# ## Decoded value
Decimal value: 123456
7-bit binary representation: 0000000 0000000 0000111 1000100 1000000 
--- zigzag ---
# ## Original value
Decimal value: 1
8-bit binary representation: 0000000 0000000 0000000 0000000 0000001 
Decimal value: 2
8-bit binary representation: 0000000 0000000 0000000 0000000 0000010 
Decimal value: 1
8-bit binary representation: 0000000 0000000 0000000 0000000 0000001 
# ## Original value
Decimal value: -2
8-bit binary representation: 1111111 1111111 1111111 1111111 1111110 
Decimal value: 3
8-bit binary representation: 0000000 0000000 0000000 0000000 0000011 
Decimal value: -2
8-bit binary representation: 1111111 1111111 1111111 1111111 1111110 
```

## protobuf variant 编码的实现

-   [UnsafeVarint](https://github.com/protocolbuffers/protobuf/blob/769305467a58fc0a8bee1a14fc9e605f6534c8b2/src/google/protobuf/io/coded_stream.h#L898)
-   [ReadVarint64FromArray](https://github.com/protocolbuffers/protobuf/blob/769305467a58fc0a8bee1a14fc9e605f6534c8b2/src/google/protobuf/io/coded_stream.cc#L468)
-   [DecodeVarint64KnownSize](https://github.com/protocolbuffers/protobuf/blob/769305467a58fc0a8bee1a14fc9e605f6534c8b2/src/google/protobuf/io/coded_stream.cc#L407)

UnsafeVarint:

```cpp
template <typename T>
PROTOBUF_ALWAYS_INLINE static uint8_t* UnsafeVarint(T value, uint8_t* ptr) {
  static_assert(std::is_unsigned<T>::value,
                "Varint serialization must be unsigned");
  while (PROTOBUF_PREDICT_FALSE(value >= 0x80)) {
    *ptr = static_cast<uint8_t>(value | 0x80);
    value >>= 7;
    ++ptr;
  }
  *ptr++ = static_cast<uint8_t>(value);
  return ptr;
}
```

ReadVarint64FromArray:

```cpp
PROTOBUF_ALWAYS_INLINE::std::pair<bool, const uint8_t*> ReadVarint64FromArray(
    const uint8_t* buffer, uint64_t* value);
inline ::std::pair<bool, const uint8_t*> ReadVarint64FromArray(
    const uint8_t* buffer, uint64_t* value) {
  // Assumes varint64 is at least 2 bytes.
  ABSL_DCHECK_GE(buffer[0], 128);

  const uint8_t* next;
  if (buffer[1] < 128) {
    next = DecodeVarint64KnownSize<2>(buffer, value);
  } else if (buffer[2] < 128) {
    next = DecodeVarint64KnownSize<3>(buffer, value);
  } else if (buffer[3] < 128) {
    next = DecodeVarint64KnownSize<4>(buffer, value);
  } else if (buffer[4] < 128) {
    next = DecodeVarint64KnownSize<5>(buffer, value);
  } else if (buffer[5] < 128) {
    next = DecodeVarint64KnownSize<6>(buffer, value);
  } else if (buffer[6] < 128) {
    next = DecodeVarint64KnownSize<7>(buffer, value);
  } else if (buffer[7] < 128) {
    next = DecodeVarint64KnownSize<8>(buffer, value);
  } else if (buffer[8] < 128) {
    next = DecodeVarint64KnownSize<9>(buffer, value);
  } else if (buffer[9] < 128) {
    next = DecodeVarint64KnownSize<10>(buffer, value);
  } else {
    // We have overrun the maximum size of a varint (10 bytes). Assume
    // the data is corrupt.
    return std::make_pair(false, buffer + 11);
  }

  return std::make_pair(true, next);
}
```

DecodeVarint64KnownSize:

```cpp
template <size_t N>
const uint8_t* DecodeVarint64KnownSize(const uint8_t* buffer, uint64_t* value) {
  ABSL_DCHECK_GT(N, 0);
  uint64_t result = static_cast<uint64_t>(buffer[N - 1]) << (7 * (N - 1));
  for (size_t i = 0, offset = 0; i < N - 1; i++, offset += 7) {
    result += static_cast<uint64_t>(buffer[i] - 0x80) << offset;
  }
  *value = result;
  return buffer + N;
}
```

## protobuf zigzag 编码的实现

-   [ZigZagEncode32](https://github.com/protocolbuffers/protobuf/blob/769305467a58fc0a8bee1a14fc9e605f6534c8b2/src/google/protobuf/wire_format_lite.h#L889)
-   [ZigZagDecode32](https://github.com/protocolbuffers/protobuf/blob/769305467a58fc0a8bee1a14fc9e605f6534c8b2/src/google/protobuf/wire_format_lite.h#L895)

ZigZagDecode32:

```cpp
inline uint32_t WireFormatLite::ZigZagEncode32(int32_t n) {
  // Note:  the right-shift must be arithmetic
  // Note:  left shift must be unsigned because of overflow
  return (static_cast<uint32_t>(n) << 1) ^ static_cast<uint32_t>(n >> 31);
}
```

ZigZagEncode32:

```cpp
inline int32_t WireFormatLite::ZigZagDecode32(uint32_t n) {
  // Note:  Using unsigned types prevent undefined behavior
  return static_cast<int32_t>((n >> 1) ^ (~(n & 1) + 1));
}
```

## References

-   [详解varint编码原理](https://segmentfault.com/a/1190000020500985)
