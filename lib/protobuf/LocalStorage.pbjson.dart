///
//  Generated code. Do not modify.
//  source: lib/protobuf/LocalStorage.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use localKeyPairDescriptor instead')
const LocalKeyPair$json = const {
  '1': 'LocalKeyPair',
  '2': const [
    const {'1': 'privateKey', '3': 1, '4': 1, '5': 12, '10': 'privateKey'},
    const {'1': 'publicKey', '3': 2, '4': 1, '5': 12, '10': 'publicKey'},
    const {'1': 'keyType', '3': 3, '4': 1, '5': 12, '10': 'keyType'},
  ],
};

/// Descriptor for `LocalKeyPair`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localKeyPairDescriptor = $convert.base64Decode('CgxMb2NhbEtleVBhaXISHgoKcHJpdmF0ZUtleRgBIAEoDFIKcHJpdmF0ZUtleRIcCglwdWJsaWNLZXkYAiABKAxSCXB1YmxpY0tleRIYCgdrZXlUeXBlGAMgASgMUgdrZXlUeXBl');
@$core.Deprecated('Use localPublicKeyDescriptor instead')
const LocalPublicKey$json = const {
  '1': 'LocalPublicKey',
  '2': const [
    const {'1': 'publicKey', '3': 1, '4': 1, '5': 12, '10': 'publicKey'},
    const {'1': 'keyType', '3': 2, '4': 1, '5': 12, '10': 'keyType'},
  ],
};

/// Descriptor for `LocalPublicKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localPublicKeyDescriptor = $convert.base64Decode('Cg5Mb2NhbFB1YmxpY0tleRIcCglwdWJsaWNLZXkYASABKAxSCXB1YmxpY0tleRIYCgdrZXlUeXBlGAIgASgMUgdrZXlUeXBl');
@$core.Deprecated('Use localPreKeyPairDescriptor instead')
const LocalPreKeyPair$json = const {
  '1': 'LocalPreKeyPair',
  '2': const [
    const {'1': 'preKeyId', '3': 1, '4': 1, '5': 13, '10': 'preKeyId'},
    const {'1': 'keyPair', '3': 2, '4': 1, '5': 11, '6': '.LocalKeyPair', '10': 'keyPair'},
  ],
};

/// Descriptor for `LocalPreKeyPair`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localPreKeyPairDescriptor = $convert.base64Decode('Cg9Mb2NhbFByZUtleVBhaXISGgoIcHJlS2V5SWQYASABKA1SCHByZUtleUlkEicKB2tleVBhaXIYAiABKAsyDS5Mb2NhbEtleVBhaXJSB2tleVBhaXI=');
@$core.Deprecated('Use localPreKeyDescriptor instead')
const LocalPreKey$json = const {
  '1': 'LocalPreKey',
  '2': const [
    const {'1': 'preKeyId', '3': 1, '4': 1, '5': 13, '10': 'preKeyId'},
    const {'1': 'publicKey', '3': 2, '4': 1, '5': 11, '6': '.LocalPublicKey', '10': 'publicKey'},
  ],
};

/// Descriptor for `LocalPreKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localPreKeyDescriptor = $convert.base64Decode('CgtMb2NhbFByZUtleRIaCghwcmVLZXlJZBgBIAEoDVIIcHJlS2V5SWQSLQoJcHVibGljS2V5GAIgASgLMg8uTG9jYWxQdWJsaWNLZXlSCXB1YmxpY0tleQ==');
@$core.Deprecated('Use localPendingPreKeyDescriptor instead')
const LocalPendingPreKey$json = const {
  '1': 'LocalPendingPreKey',
  '2': const [
    const {'1': 'preKeyId', '3': 1, '4': 1, '5': 13, '10': 'preKeyId'},
    const {'1': 'signedPreKeyId', '3': 2, '4': 1, '5': 13, '10': 'signedPreKeyId'},
    const {'1': 'publicKey', '3': 3, '4': 1, '5': 11, '6': '.LocalPublicKey', '10': 'publicKey'},
  ],
};

/// Descriptor for `LocalPendingPreKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localPendingPreKeyDescriptor = $convert.base64Decode('ChJMb2NhbFBlbmRpbmdQcmVLZXkSGgoIcHJlS2V5SWQYASABKA1SCHByZUtleUlkEiYKDnNpZ25lZFByZUtleUlkGAIgASgNUg5zaWduZWRQcmVLZXlJZBItCglwdWJsaWNLZXkYAyABKAsyDy5Mb2NhbFB1YmxpY0tleVIJcHVibGljS2V5');
@$core.Deprecated('Use localSignedPreKeyPairDescriptor instead')
const LocalSignedPreKeyPair$json = const {
  '1': 'LocalSignedPreKeyPair',
  '2': const [
    const {'1': 'signedPreKeyId', '3': 1, '4': 1, '5': 13, '10': 'signedPreKeyId'},
    const {'1': 'keyPair', '3': 2, '4': 1, '5': 11, '6': '.LocalKeyPair', '10': 'keyPair'},
  ],
};

/// Descriptor for `LocalSignedPreKeyPair`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localSignedPreKeyPairDescriptor = $convert.base64Decode('ChVMb2NhbFNpZ25lZFByZUtleVBhaXISJgoOc2lnbmVkUHJlS2V5SWQYASABKA1SDnNpZ25lZFByZUtleUlkEicKB2tleVBhaXIYAiABKAsyDS5Mb2NhbEtleVBhaXJSB2tleVBhaXI=');
@$core.Deprecated('Use localSignedPreKeyDescriptor instead')
const LocalSignedPreKey$json = const {
  '1': 'LocalSignedPreKey',
  '2': const [
    const {'1': 'signedPreKeyId', '3': 1, '4': 1, '5': 13, '10': 'signedPreKeyId'},
    const {'1': 'publicKey', '3': 2, '4': 1, '5': 11, '6': '.LocalPublicKey', '10': 'publicKey'},
  ],
};

/// Descriptor for `LocalSignedPreKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localSignedPreKeyDescriptor = $convert.base64Decode('ChFMb2NhbFNpZ25lZFByZUtleRImCg5zaWduZWRQcmVLZXlJZBgBIAEoDVIOc2lnbmVkUHJlS2V5SWQSLQoJcHVibGljS2V5GAIgASgLMg8uTG9jYWxQdWJsaWNLZXlSCXB1YmxpY0tleQ==');
@$core.Deprecated('Use localMessageKeyDescriptor instead')
const LocalMessageKey$json = const {
  '1': 'LocalMessageKey',
  '2': const [
    const {'1': 'cipherKey', '3': 1, '4': 1, '5': 12, '10': 'cipherKey'},
    const {'1': 'macKey', '3': 2, '4': 1, '5': 12, '10': 'macKey'},
    const {'1': 'iv', '3': 3, '4': 1, '5': 12, '10': 'iv'},
  ],
};

/// Descriptor for `LocalMessageKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localMessageKeyDescriptor = $convert.base64Decode('Cg9Mb2NhbE1lc3NhZ2VLZXkSHAoJY2lwaGVyS2V5GAEgASgMUgljaXBoZXJLZXkSFgoGbWFjS2V5GAIgASgMUgZtYWNLZXkSDgoCaXYYAyABKAxSAml2');
@$core.Deprecated('Use localChainDescriptor instead')
const LocalChain$json = const {
  '1': 'LocalChain',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 12, '10': 'key'},
    const {'1': 'index', '3': 2, '4': 1, '5': 13, '10': 'index'},
    const {'1': 'messageKeys', '3': 3, '4': 3, '5': 11, '6': '.LocalMessageKey', '10': 'messageKeys'},
  ],
};

/// Descriptor for `LocalChain`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localChainDescriptor = $convert.base64Decode('CgpMb2NhbENoYWluEhAKA2tleRgBIAEoDFIDa2V5EhQKBWluZGV4GAIgASgNUgVpbmRleBIyCgttZXNzYWdlS2V5cxgDIAMoCzIQLkxvY2FsTWVzc2FnZUtleVILbWVzc2FnZUtleXM=');
@$core.Deprecated('Use localPublicKeyAndChainDescriptor instead')
const LocalPublicKeyAndChain$json = const {
  '1': 'LocalPublicKeyAndChain',
  '2': const [
    const {'1': 'ephemeralPublicKey', '3': 1, '4': 1, '5': 12, '10': 'ephemeralPublicKey'},
    const {'1': 'chain', '3': 2, '4': 1, '5': 11, '6': '.LocalChain', '10': 'chain'},
  ],
};

/// Descriptor for `LocalPublicKeyAndChain`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localPublicKeyAndChainDescriptor = $convert.base64Decode('ChZMb2NhbFB1YmxpY0tleUFuZENoYWluEi4KEmVwaGVtZXJhbFB1YmxpY0tleRgBIAEoDFISZXBoZW1lcmFsUHVibGljS2V5EiEKBWNoYWluGAIgASgLMgsuTG9jYWxDaGFpblIFY2hhaW4=');
@$core.Deprecated('Use localSessionMessagingDescriptor instead')
const LocalSessionMessaging$json = const {
  '1': 'LocalSessionMessaging',
  '2': const [
    const {'1': 'userName', '3': 1, '4': 1, '5': 9, '10': 'userName'},
    const {'1': 'userDeviceId', '3': 2, '4': 1, '5': 9, '10': 'userDeviceId'},
    const {'1': 'groupName', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'groupName', '17': true},
    const {'1': 'groupId', '3': 4, '4': 1, '5': 9, '9': 1, '10': 'groupId', '17': true},
    const {'1': 'groupSenderName', '3': 5, '4': 1, '5': 9, '9': 2, '10': 'groupSenderName', '17': true},
    const {'1': 'groupSenderDeviceId', '3': 6, '4': 1, '5': 9, '9': 3, '10': 'groupSenderDeviceId', '17': true},
    const {'1': 'isGroup', '3': 7, '4': 1, '5': 8, '10': 'isGroup'},
  ],
  '8': const [
    const {'1': '_groupName'},
    const {'1': '_groupId'},
    const {'1': '_groupSenderName'},
    const {'1': '_groupSenderDeviceId'},
  ],
};

/// Descriptor for `LocalSessionMessaging`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localSessionMessagingDescriptor = $convert.base64Decode('ChVMb2NhbFNlc3Npb25NZXNzYWdpbmcSGgoIdXNlck5hbWUYASABKAlSCHVzZXJOYW1lEiIKDHVzZXJEZXZpY2VJZBgCIAEoCVIMdXNlckRldmljZUlkEiEKCWdyb3VwTmFtZRgDIAEoCUgAUglncm91cE5hbWWIAQESHQoHZ3JvdXBJZBgEIAEoCUgBUgdncm91cElkiAEBEi0KD2dyb3VwU2VuZGVyTmFtZRgFIAEoCUgCUg9ncm91cFNlbmRlck5hbWWIAQESNQoTZ3JvdXBTZW5kZXJEZXZpY2VJZBgGIAEoCUgDUhNncm91cFNlbmRlckRldmljZUlkiAEBEhgKB2lzR3JvdXAYByABKAhSB2lzR3JvdXBCDAoKX2dyb3VwTmFtZUIKCghfZ3JvdXBJZEISChBfZ3JvdXBTZW5kZXJOYW1lQhYKFF9ncm91cFNlbmRlckRldmljZUlk');
@$core.Deprecated('Use localSessionStateDescriptor instead')
const LocalSessionState$json = const {
  '1': 'LocalSessionState',
  '2': const [
    const {'1': 'sessionMessaging', '3': 1, '4': 1, '5': 11, '6': '.LocalSessionMessaging', '10': 'sessionMessaging'},
    const {'1': 'sessionVersion', '3': 2, '4': 1, '5': 13, '10': 'sessionVersion'},
    const {'1': 'remoteIdentityKey', '3': 3, '4': 1, '5': 11, '6': '.LocalPublicKey', '10': 'remoteIdentityKey'},
    const {'1': 'localIdentityKey', '3': 4, '4': 1, '5': 11, '6': '.LocalPublicKey', '10': 'localIdentityKey'},
    const {'1': 'localRegistrationId', '3': 5, '4': 1, '5': 9, '10': 'localRegistrationId'},
    const {'1': 'rootKey', '3': 6, '4': 1, '5': 12, '10': 'rootKey'},
    const {'1': 'sendingChain', '3': 7, '4': 1, '5': 11, '6': '.LocalChain', '10': 'sendingChain'},
    const {'1': 'senderRatchetKeyPair', '3': 8, '4': 1, '5': 11, '6': '.LocalKeyPair', '10': 'senderRatchetKeyPair'},
    const {'1': 'receivingChains', '3': 9, '4': 3, '5': 11, '6': '.LocalPublicKeyAndChain', '10': 'receivingChains'},
    const {'1': 'previousCounter', '3': 10, '4': 1, '5': 13, '10': 'previousCounter'},
    const {'1': 'pending', '3': 11, '4': 1, '5': 11, '6': '.LocalPendingPreKey', '9': 0, '10': 'pending', '17': true},
    const {'1': 'theirBaseKey', '3': 12, '4': 1, '5': 11, '6': '.LocalPreKey', '9': 1, '10': 'theirBaseKey', '17': true},
  ],
  '8': const [
    const {'1': '_pending'},
    const {'1': '_theirBaseKey'},
  ],
};

/// Descriptor for `LocalSessionState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localSessionStateDescriptor = $convert.base64Decode('ChFMb2NhbFNlc3Npb25TdGF0ZRJCChBzZXNzaW9uTWVzc2FnaW5nGAEgASgLMhYuTG9jYWxTZXNzaW9uTWVzc2FnaW5nUhBzZXNzaW9uTWVzc2FnaW5nEiYKDnNlc3Npb25WZXJzaW9uGAIgASgNUg5zZXNzaW9uVmVyc2lvbhI9ChFyZW1vdGVJZGVudGl0eUtleRgDIAEoCzIPLkxvY2FsUHVibGljS2V5UhFyZW1vdGVJZGVudGl0eUtleRI7ChBsb2NhbElkZW50aXR5S2V5GAQgASgLMg8uTG9jYWxQdWJsaWNLZXlSEGxvY2FsSWRlbnRpdHlLZXkSMAoTbG9jYWxSZWdpc3RyYXRpb25JZBgFIAEoCVITbG9jYWxSZWdpc3RyYXRpb25JZBIYCgdyb290S2V5GAYgASgMUgdyb290S2V5Ei8KDHNlbmRpbmdDaGFpbhgHIAEoCzILLkxvY2FsQ2hhaW5SDHNlbmRpbmdDaGFpbhJBChRzZW5kZXJSYXRjaGV0S2V5UGFpchgIIAEoCzINLkxvY2FsS2V5UGFpclIUc2VuZGVyUmF0Y2hldEtleVBhaXISQQoPcmVjZWl2aW5nQ2hhaW5zGAkgAygLMhcuTG9jYWxQdWJsaWNLZXlBbmRDaGFpblIPcmVjZWl2aW5nQ2hhaW5zEigKD3ByZXZpb3VzQ291bnRlchgKIAEoDVIPcHJldmlvdXNDb3VudGVyEjIKB3BlbmRpbmcYCyABKAsyEy5Mb2NhbFBlbmRpbmdQcmVLZXlIAFIHcGVuZGluZ4gBARI1Cgx0aGVpckJhc2VLZXkYDCABKAsyDC5Mb2NhbFByZUtleUgBUgx0aGVpckJhc2VLZXmIAQFCCgoIX3BlbmRpbmdCDwoNX3RoZWlyQmFzZUtleQ==');
@$core.Deprecated('Use localSessionDescriptor instead')
const LocalSession$json = const {
  '1': 'LocalSession',
  '2': const [
    const {'1': 'sessionStates', '3': 1, '4': 3, '5': 11, '6': '.LocalSessionState', '10': 'sessionStates'},
  ],
};

/// Descriptor for `LocalSession`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localSessionDescriptor = $convert.base64Decode('CgxMb2NhbFNlc3Npb24SOAoNc2Vzc2lvblN0YXRlcxgBIAMoCzISLkxvY2FsU2Vzc2lvblN0YXRlUg1zZXNzaW9uU3RhdGVz');
@$core.Deprecated('Use localStorageDescriptor instead')
const LocalStorage$json = const {
  '1': 'LocalStorage',
  '2': const [
    const {'1': 'localRegistrationId', '3': 1, '4': 1, '5': 12, '9': 0, '10': 'localRegistrationId', '17': true},
    const {'1': 'localIdentityKeyPair', '3': 2, '4': 1, '5': 12, '9': 1, '10': 'localIdentityKeyPair', '17': true},
    const {'1': 'localPreKeyPairs', '3': 3, '4': 1, '5': 12, '9': 2, '10': 'localPreKeyPairs', '17': true},
    const {'1': 'localSignedPreKeyPairs', '3': 4, '4': 1, '5': 12, '9': 3, '10': 'localSignedPreKeyPairs', '17': true},
    const {'1': 'session', '3': 5, '4': 1, '5': 12, '9': 4, '10': 'session', '17': true},
  ],
  '8': const [
    const {'1': '_localRegistrationId'},
    const {'1': '_localIdentityKeyPair'},
    const {'1': '_localPreKeyPairs'},
    const {'1': '_localSignedPreKeyPairs'},
    const {'1': '_session'},
  ],
};

/// Descriptor for `LocalStorage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List localStorageDescriptor = $convert.base64Decode('CgxMb2NhbFN0b3JhZ2USNQoTbG9jYWxSZWdpc3RyYXRpb25JZBgBIAEoDEgAUhNsb2NhbFJlZ2lzdHJhdGlvbklkiAEBEjcKFGxvY2FsSWRlbnRpdHlLZXlQYWlyGAIgASgMSAFSFGxvY2FsSWRlbnRpdHlLZXlQYWlyiAEBEi8KEGxvY2FsUHJlS2V5UGFpcnMYAyABKAxIAlIQbG9jYWxQcmVLZXlQYWlyc4gBARI7ChZsb2NhbFNpZ25lZFByZUtleVBhaXJzGAQgASgMSANSFmxvY2FsU2lnbmVkUHJlS2V5UGFpcnOIAQESHQoHc2Vzc2lvbhgFIAEoDEgEUgdzZXNzaW9uiAEBQhYKFF9sb2NhbFJlZ2lzdHJhdGlvbklkQhcKFV9sb2NhbElkZW50aXR5S2V5UGFpckITChFfbG9jYWxQcmVLZXlQYWlyc0IZChdfbG9jYWxTaWduZWRQcmVLZXlQYWlyc0IKCghfc2Vzc2lvbg==');
