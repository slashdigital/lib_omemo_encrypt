///
//  Generated code. Do not modify.
//  source: lib/protobuf/WhisperSenderMessage.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use senderKeyMessageDescriptor instead')
const SenderKeyMessage$json = const {
  '1': 'SenderKeyMessage',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    const {'1': 'iteration', '3': 2, '4': 1, '5': 13, '10': 'iteration'},
    const {'1': 'ciphertext', '3': 3, '4': 1, '5': 12, '10': 'ciphertext'},
  ],
};

/// Descriptor for `SenderKeyMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List senderKeyMessageDescriptor = $convert.base64Decode(
    'ChBTZW5kZXJLZXlNZXNzYWdlEg4KAmlkGAEgASgNUgJpZBIcCglpdGVyYXRpb24YAiABKA1SCWl0ZXJhdGlvbhIeCgpjaXBoZXJ0ZXh0GAMgASgMUgpjaXBoZXJ0ZXh0');
