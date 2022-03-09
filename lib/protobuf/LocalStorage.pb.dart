///
//  Generated code. Do not modify.
//  source: lib/protobuf/LocalStorage.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class LocalKeyPair extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocalKeyPair', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'privateKey', $pb.PbFieldType.OY, protoName: 'privateKey')
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publicKey', $pb.PbFieldType.OY, protoName: 'publicKey')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'keyType', $pb.PbFieldType.OY, protoName: 'keyType')
    ..hasRequiredFields = false
  ;

  LocalKeyPair._() : super();
  factory LocalKeyPair({
    $core.List<$core.int>? privateKey,
    $core.List<$core.int>? publicKey,
    $core.List<$core.int>? keyType,
  }) {
    final _result = create();
    if (privateKey != null) {
      _result.privateKey = privateKey;
    }
    if (publicKey != null) {
      _result.publicKey = publicKey;
    }
    if (keyType != null) {
      _result.keyType = keyType;
    }
    return _result;
  }
  factory LocalKeyPair.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocalKeyPair.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocalKeyPair clone() => LocalKeyPair()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocalKeyPair copyWith(void Function(LocalKeyPair) updates) => super.copyWith((message) => updates(message as LocalKeyPair)) as LocalKeyPair; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocalKeyPair create() => LocalKeyPair._();
  LocalKeyPair createEmptyInstance() => create();
  static $pb.PbList<LocalKeyPair> createRepeated() => $pb.PbList<LocalKeyPair>();
  @$core.pragma('dart2js:noInline')
  static LocalKeyPair getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocalKeyPair>(create);
  static LocalKeyPair? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get privateKey => $_getN(0);
  @$pb.TagNumber(1)
  set privateKey($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPrivateKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrivateKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get publicKey => $_getN(1);
  @$pb.TagNumber(2)
  set publicKey($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPublicKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublicKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get keyType => $_getN(2);
  @$pb.TagNumber(3)
  set keyType($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasKeyType() => $_has(2);
  @$pb.TagNumber(3)
  void clearKeyType() => clearField(3);
}

class LocalPublicKey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocalPublicKey', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publicKey', $pb.PbFieldType.OY, protoName: 'publicKey')
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'keyType', $pb.PbFieldType.OY, protoName: 'keyType')
    ..hasRequiredFields = false
  ;

  LocalPublicKey._() : super();
  factory LocalPublicKey({
    $core.List<$core.int>? publicKey,
    $core.List<$core.int>? keyType,
  }) {
    final _result = create();
    if (publicKey != null) {
      _result.publicKey = publicKey;
    }
    if (keyType != null) {
      _result.keyType = keyType;
    }
    return _result;
  }
  factory LocalPublicKey.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocalPublicKey.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocalPublicKey clone() => LocalPublicKey()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocalPublicKey copyWith(void Function(LocalPublicKey) updates) => super.copyWith((message) => updates(message as LocalPublicKey)) as LocalPublicKey; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocalPublicKey create() => LocalPublicKey._();
  LocalPublicKey createEmptyInstance() => create();
  static $pb.PbList<LocalPublicKey> createRepeated() => $pb.PbList<LocalPublicKey>();
  @$core.pragma('dart2js:noInline')
  static LocalPublicKey getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocalPublicKey>(create);
  static LocalPublicKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get publicKey => $_getN(0);
  @$pb.TagNumber(1)
  set publicKey($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get keyType => $_getN(1);
  @$pb.TagNumber(2)
  set keyType($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasKeyType() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyType() => clearField(2);
}

class LocalPreKeyPair extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocalPreKeyPair', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'preKeyId', $pb.PbFieldType.OU3, protoName: 'preKeyId')
    ..aOM<LocalKeyPair>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'keyPair', protoName: 'keyPair', subBuilder: LocalKeyPair.create)
    ..hasRequiredFields = false
  ;

  LocalPreKeyPair._() : super();
  factory LocalPreKeyPair({
    $core.int? preKeyId,
    LocalKeyPair? keyPair,
  }) {
    final _result = create();
    if (preKeyId != null) {
      _result.preKeyId = preKeyId;
    }
    if (keyPair != null) {
      _result.keyPair = keyPair;
    }
    return _result;
  }
  factory LocalPreKeyPair.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocalPreKeyPair.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocalPreKeyPair clone() => LocalPreKeyPair()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocalPreKeyPair copyWith(void Function(LocalPreKeyPair) updates) => super.copyWith((message) => updates(message as LocalPreKeyPair)) as LocalPreKeyPair; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocalPreKeyPair create() => LocalPreKeyPair._();
  LocalPreKeyPair createEmptyInstance() => create();
  static $pb.PbList<LocalPreKeyPair> createRepeated() => $pb.PbList<LocalPreKeyPair>();
  @$core.pragma('dart2js:noInline')
  static LocalPreKeyPair getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocalPreKeyPair>(create);
  static LocalPreKeyPair? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get preKeyId => $_getIZ(0);
  @$pb.TagNumber(1)
  set preKeyId($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPreKeyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreKeyId() => clearField(1);

  @$pb.TagNumber(2)
  LocalKeyPair get keyPair => $_getN(1);
  @$pb.TagNumber(2)
  set keyPair(LocalKeyPair v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasKeyPair() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyPair() => clearField(2);
  @$pb.TagNumber(2)
  LocalKeyPair ensureKeyPair() => $_ensure(1);
}

class LocalPreKey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocalPreKey', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'preKeyId', $pb.PbFieldType.OU3, protoName: 'preKeyId')
    ..aOM<LocalPublicKey>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publicKey', protoName: 'publicKey', subBuilder: LocalPublicKey.create)
    ..hasRequiredFields = false
  ;

  LocalPreKey._() : super();
  factory LocalPreKey({
    $core.int? preKeyId,
    LocalPublicKey? publicKey,
  }) {
    final _result = create();
    if (preKeyId != null) {
      _result.preKeyId = preKeyId;
    }
    if (publicKey != null) {
      _result.publicKey = publicKey;
    }
    return _result;
  }
  factory LocalPreKey.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocalPreKey.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocalPreKey clone() => LocalPreKey()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocalPreKey copyWith(void Function(LocalPreKey) updates) => super.copyWith((message) => updates(message as LocalPreKey)) as LocalPreKey; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocalPreKey create() => LocalPreKey._();
  LocalPreKey createEmptyInstance() => create();
  static $pb.PbList<LocalPreKey> createRepeated() => $pb.PbList<LocalPreKey>();
  @$core.pragma('dart2js:noInline')
  static LocalPreKey getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocalPreKey>(create);
  static LocalPreKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get preKeyId => $_getIZ(0);
  @$pb.TagNumber(1)
  set preKeyId($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPreKeyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreKeyId() => clearField(1);

  @$pb.TagNumber(2)
  LocalPublicKey get publicKey => $_getN(1);
  @$pb.TagNumber(2)
  set publicKey(LocalPublicKey v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPublicKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublicKey() => clearField(2);
  @$pb.TagNumber(2)
  LocalPublicKey ensurePublicKey() => $_ensure(1);
}

class LocalPendingPreKey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocalPendingPreKey', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'preKeyId', $pb.PbFieldType.OU3, protoName: 'preKeyId')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signedPreKeyId', $pb.PbFieldType.OU3, protoName: 'signedPreKeyId')
    ..aOM<LocalPublicKey>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publicKey', protoName: 'publicKey', subBuilder: LocalPublicKey.create)
    ..hasRequiredFields = false
  ;

  LocalPendingPreKey._() : super();
  factory LocalPendingPreKey({
    $core.int? preKeyId,
    $core.int? signedPreKeyId,
    LocalPublicKey? publicKey,
  }) {
    final _result = create();
    if (preKeyId != null) {
      _result.preKeyId = preKeyId;
    }
    if (signedPreKeyId != null) {
      _result.signedPreKeyId = signedPreKeyId;
    }
    if (publicKey != null) {
      _result.publicKey = publicKey;
    }
    return _result;
  }
  factory LocalPendingPreKey.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocalPendingPreKey.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocalPendingPreKey clone() => LocalPendingPreKey()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocalPendingPreKey copyWith(void Function(LocalPendingPreKey) updates) => super.copyWith((message) => updates(message as LocalPendingPreKey)) as LocalPendingPreKey; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocalPendingPreKey create() => LocalPendingPreKey._();
  LocalPendingPreKey createEmptyInstance() => create();
  static $pb.PbList<LocalPendingPreKey> createRepeated() => $pb.PbList<LocalPendingPreKey>();
  @$core.pragma('dart2js:noInline')
  static LocalPendingPreKey getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocalPendingPreKey>(create);
  static LocalPendingPreKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get preKeyId => $_getIZ(0);
  @$pb.TagNumber(1)
  set preKeyId($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPreKeyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreKeyId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get signedPreKeyId => $_getIZ(1);
  @$pb.TagNumber(2)
  set signedPreKeyId($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSignedPreKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSignedPreKeyId() => clearField(2);

  @$pb.TagNumber(3)
  LocalPublicKey get publicKey => $_getN(2);
  @$pb.TagNumber(3)
  set publicKey(LocalPublicKey v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPublicKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearPublicKey() => clearField(3);
  @$pb.TagNumber(3)
  LocalPublicKey ensurePublicKey() => $_ensure(2);
}

class LocalSignedPreKeyPair extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocalSignedPreKeyPair', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signedPreKeyId', $pb.PbFieldType.OU3, protoName: 'signedPreKeyId')
    ..aOM<LocalKeyPair>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'keyPair', protoName: 'keyPair', subBuilder: LocalKeyPair.create)
    ..hasRequiredFields = false
  ;

  LocalSignedPreKeyPair._() : super();
  factory LocalSignedPreKeyPair({
    $core.int? signedPreKeyId,
    LocalKeyPair? keyPair,
  }) {
    final _result = create();
    if (signedPreKeyId != null) {
      _result.signedPreKeyId = signedPreKeyId;
    }
    if (keyPair != null) {
      _result.keyPair = keyPair;
    }
    return _result;
  }
  factory LocalSignedPreKeyPair.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocalSignedPreKeyPair.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocalSignedPreKeyPair clone() => LocalSignedPreKeyPair()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocalSignedPreKeyPair copyWith(void Function(LocalSignedPreKeyPair) updates) => super.copyWith((message) => updates(message as LocalSignedPreKeyPair)) as LocalSignedPreKeyPair; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocalSignedPreKeyPair create() => LocalSignedPreKeyPair._();
  LocalSignedPreKeyPair createEmptyInstance() => create();
  static $pb.PbList<LocalSignedPreKeyPair> createRepeated() => $pb.PbList<LocalSignedPreKeyPair>();
  @$core.pragma('dart2js:noInline')
  static LocalSignedPreKeyPair getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocalSignedPreKeyPair>(create);
  static LocalSignedPreKeyPair? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get signedPreKeyId => $_getIZ(0);
  @$pb.TagNumber(1)
  set signedPreKeyId($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSignedPreKeyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignedPreKeyId() => clearField(1);

  @$pb.TagNumber(2)
  LocalKeyPair get keyPair => $_getN(1);
  @$pb.TagNumber(2)
  set keyPair(LocalKeyPair v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasKeyPair() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyPair() => clearField(2);
  @$pb.TagNumber(2)
  LocalKeyPair ensureKeyPair() => $_ensure(1);
}

class LocalSignedPreKey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocalSignedPreKey', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signedPreKeyId', $pb.PbFieldType.OU3, protoName: 'signedPreKeyId')
    ..aOM<LocalPublicKey>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publicKey', protoName: 'publicKey', subBuilder: LocalPublicKey.create)
    ..hasRequiredFields = false
  ;

  LocalSignedPreKey._() : super();
  factory LocalSignedPreKey({
    $core.int? signedPreKeyId,
    LocalPublicKey? publicKey,
  }) {
    final _result = create();
    if (signedPreKeyId != null) {
      _result.signedPreKeyId = signedPreKeyId;
    }
    if (publicKey != null) {
      _result.publicKey = publicKey;
    }
    return _result;
  }
  factory LocalSignedPreKey.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocalSignedPreKey.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocalSignedPreKey clone() => LocalSignedPreKey()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocalSignedPreKey copyWith(void Function(LocalSignedPreKey) updates) => super.copyWith((message) => updates(message as LocalSignedPreKey)) as LocalSignedPreKey; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocalSignedPreKey create() => LocalSignedPreKey._();
  LocalSignedPreKey createEmptyInstance() => create();
  static $pb.PbList<LocalSignedPreKey> createRepeated() => $pb.PbList<LocalSignedPreKey>();
  @$core.pragma('dart2js:noInline')
  static LocalSignedPreKey getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocalSignedPreKey>(create);
  static LocalSignedPreKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get signedPreKeyId => $_getIZ(0);
  @$pb.TagNumber(1)
  set signedPreKeyId($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSignedPreKeyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignedPreKeyId() => clearField(1);

  @$pb.TagNumber(2)
  LocalPublicKey get publicKey => $_getN(1);
  @$pb.TagNumber(2)
  set publicKey(LocalPublicKey v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPublicKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublicKey() => clearField(2);
  @$pb.TagNumber(2)
  LocalPublicKey ensurePublicKey() => $_ensure(1);
}

class LocalMessageKey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocalMessageKey', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cipherKey', $pb.PbFieldType.OY, protoName: 'cipherKey')
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'macKey', $pb.PbFieldType.OY, protoName: 'macKey')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'iv', $pb.PbFieldType.OY)
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'index', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  LocalMessageKey._() : super();
  factory LocalMessageKey({
    $core.List<$core.int>? cipherKey,
    $core.List<$core.int>? macKey,
    $core.List<$core.int>? iv,
    $core.int? index,
  }) {
    final _result = create();
    if (cipherKey != null) {
      _result.cipherKey = cipherKey;
    }
    if (macKey != null) {
      _result.macKey = macKey;
    }
    if (iv != null) {
      _result.iv = iv;
    }
    if (index != null) {
      _result.index = index;
    }
    return _result;
  }
  factory LocalMessageKey.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocalMessageKey.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocalMessageKey clone() => LocalMessageKey()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocalMessageKey copyWith(void Function(LocalMessageKey) updates) => super.copyWith((message) => updates(message as LocalMessageKey)) as LocalMessageKey; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocalMessageKey create() => LocalMessageKey._();
  LocalMessageKey createEmptyInstance() => create();
  static $pb.PbList<LocalMessageKey> createRepeated() => $pb.PbList<LocalMessageKey>();
  @$core.pragma('dart2js:noInline')
  static LocalMessageKey getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocalMessageKey>(create);
  static LocalMessageKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get cipherKey => $_getN(0);
  @$pb.TagNumber(1)
  set cipherKey($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCipherKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearCipherKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get macKey => $_getN(1);
  @$pb.TagNumber(2)
  set macKey($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMacKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearMacKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get iv => $_getN(2);
  @$pb.TagNumber(3)
  set iv($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIv() => $_has(2);
  @$pb.TagNumber(3)
  void clearIv() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get index => $_getIZ(3);
  @$pb.TagNumber(4)
  set index($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearIndex() => clearField(4);
}

class LocalChain extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocalChain', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key', $pb.PbFieldType.OY)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'index', $pb.PbFieldType.OU3)
    ..pc<LocalMessageKey>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'messageKeys', $pb.PbFieldType.PM, protoName: 'messageKeys', subBuilder: LocalMessageKey.create)
    ..hasRequiredFields = false
  ;

  LocalChain._() : super();
  factory LocalChain({
    $core.List<$core.int>? key,
    $core.int? index,
    $core.Iterable<LocalMessageKey>? messageKeys,
  }) {
    final _result = create();
    if (key != null) {
      _result.key = key;
    }
    if (index != null) {
      _result.index = index;
    }
    if (messageKeys != null) {
      _result.messageKeys.addAll(messageKeys);
    }
    return _result;
  }
  factory LocalChain.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocalChain.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocalChain clone() => LocalChain()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocalChain copyWith(void Function(LocalChain) updates) => super.copyWith((message) => updates(message as LocalChain)) as LocalChain; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocalChain create() => LocalChain._();
  LocalChain createEmptyInstance() => create();
  static $pb.PbList<LocalChain> createRepeated() => $pb.PbList<LocalChain>();
  @$core.pragma('dart2js:noInline')
  static LocalChain getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocalChain>(create);
  static LocalChain? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get key => $_getN(0);
  @$pb.TagNumber(1)
  set key($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get index => $_getIZ(1);
  @$pb.TagNumber(2)
  set index($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndex() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<LocalMessageKey> get messageKeys => $_getList(2);
}

class LocalPublicKeyAndChain extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocalPublicKeyAndChain', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ephemeralPublicKey', $pb.PbFieldType.OY, protoName: 'ephemeralPublicKey')
    ..aOM<LocalChain>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chain', subBuilder: LocalChain.create)
    ..hasRequiredFields = false
  ;

  LocalPublicKeyAndChain._() : super();
  factory LocalPublicKeyAndChain({
    $core.List<$core.int>? ephemeralPublicKey,
    LocalChain? chain,
  }) {
    final _result = create();
    if (ephemeralPublicKey != null) {
      _result.ephemeralPublicKey = ephemeralPublicKey;
    }
    if (chain != null) {
      _result.chain = chain;
    }
    return _result;
  }
  factory LocalPublicKeyAndChain.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocalPublicKeyAndChain.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocalPublicKeyAndChain clone() => LocalPublicKeyAndChain()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocalPublicKeyAndChain copyWith(void Function(LocalPublicKeyAndChain) updates) => super.copyWith((message) => updates(message as LocalPublicKeyAndChain)) as LocalPublicKeyAndChain; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocalPublicKeyAndChain create() => LocalPublicKeyAndChain._();
  LocalPublicKeyAndChain createEmptyInstance() => create();
  static $pb.PbList<LocalPublicKeyAndChain> createRepeated() => $pb.PbList<LocalPublicKeyAndChain>();
  @$core.pragma('dart2js:noInline')
  static LocalPublicKeyAndChain getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocalPublicKeyAndChain>(create);
  static LocalPublicKeyAndChain? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get ephemeralPublicKey => $_getN(0);
  @$pb.TagNumber(1)
  set ephemeralPublicKey($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEphemeralPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearEphemeralPublicKey() => clearField(1);

  @$pb.TagNumber(2)
  LocalChain get chain => $_getN(1);
  @$pb.TagNumber(2)
  set chain(LocalChain v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasChain() => $_has(1);
  @$pb.TagNumber(2)
  void clearChain() => clearField(2);
  @$pb.TagNumber(2)
  LocalChain ensureChain() => $_ensure(1);
}

class LocalSessionMessaging extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocalSessionMessaging', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userName', protoName: 'userName')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userDeviceId', protoName: 'userDeviceId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupName', protoName: 'groupName')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupId', protoName: 'groupId')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupSenderName', protoName: 'groupSenderName')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupSenderDeviceId', protoName: 'groupSenderDeviceId')
    ..aOB(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isGroup', protoName: 'isGroup')
    ..hasRequiredFields = false
  ;

  LocalSessionMessaging._() : super();
  factory LocalSessionMessaging({
    $core.String? userName,
    $core.String? userDeviceId,
    $core.String? groupName,
    $core.String? groupId,
    $core.String? groupSenderName,
    $core.String? groupSenderDeviceId,
    $core.bool? isGroup,
  }) {
    final _result = create();
    if (userName != null) {
      _result.userName = userName;
    }
    if (userDeviceId != null) {
      _result.userDeviceId = userDeviceId;
    }
    if (groupName != null) {
      _result.groupName = groupName;
    }
    if (groupId != null) {
      _result.groupId = groupId;
    }
    if (groupSenderName != null) {
      _result.groupSenderName = groupSenderName;
    }
    if (groupSenderDeviceId != null) {
      _result.groupSenderDeviceId = groupSenderDeviceId;
    }
    if (isGroup != null) {
      _result.isGroup = isGroup;
    }
    return _result;
  }
  factory LocalSessionMessaging.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocalSessionMessaging.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocalSessionMessaging clone() => LocalSessionMessaging()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocalSessionMessaging copyWith(void Function(LocalSessionMessaging) updates) => super.copyWith((message) => updates(message as LocalSessionMessaging)) as LocalSessionMessaging; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocalSessionMessaging create() => LocalSessionMessaging._();
  LocalSessionMessaging createEmptyInstance() => create();
  static $pb.PbList<LocalSessionMessaging> createRepeated() => $pb.PbList<LocalSessionMessaging>();
  @$core.pragma('dart2js:noInline')
  static LocalSessionMessaging getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocalSessionMessaging>(create);
  static LocalSessionMessaging? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userName => $_getSZ(0);
  @$pb.TagNumber(1)
  set userName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserName() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get userDeviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userDeviceId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserDeviceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserDeviceId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get groupName => $_getSZ(2);
  @$pb.TagNumber(3)
  set groupName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGroupName() => $_has(2);
  @$pb.TagNumber(3)
  void clearGroupName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get groupId => $_getSZ(3);
  @$pb.TagNumber(4)
  set groupId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasGroupId() => $_has(3);
  @$pb.TagNumber(4)
  void clearGroupId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get groupSenderName => $_getSZ(4);
  @$pb.TagNumber(5)
  set groupSenderName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasGroupSenderName() => $_has(4);
  @$pb.TagNumber(5)
  void clearGroupSenderName() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get groupSenderDeviceId => $_getSZ(5);
  @$pb.TagNumber(6)
  set groupSenderDeviceId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasGroupSenderDeviceId() => $_has(5);
  @$pb.TagNumber(6)
  void clearGroupSenderDeviceId() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isGroup => $_getBF(6);
  @$pb.TagNumber(7)
  set isGroup($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasIsGroup() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsGroup() => clearField(7);
}

class LocalSessionState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocalSessionState', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionVersion', $pb.PbFieldType.OU3, protoName: 'sessionVersion')
    ..aOM<LocalPublicKey>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'remoteIdentityKey', protoName: 'remoteIdentityKey', subBuilder: LocalPublicKey.create)
    ..aOM<LocalPublicKey>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localIdentityKey', protoName: 'localIdentityKey', subBuilder: LocalPublicKey.create)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localRegistrationId', protoName: 'localRegistrationId')
    ..a<$core.List<$core.int>>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rootKey', $pb.PbFieldType.OY, protoName: 'rootKey')
    ..aOM<LocalChain>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendingChain', protoName: 'sendingChain', subBuilder: LocalChain.create)
    ..aOM<LocalKeyPair>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderRatchetKeyPair', protoName: 'senderRatchetKeyPair', subBuilder: LocalKeyPair.create)
    ..pc<LocalPublicKeyAndChain>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receivingChains', $pb.PbFieldType.PM, protoName: 'receivingChains', subBuilder: LocalPublicKeyAndChain.create)
    ..a<$core.int>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'previousCounter', $pb.PbFieldType.OU3, protoName: 'previousCounter')
    ..aOM<LocalPendingPreKey>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pending', subBuilder: LocalPendingPreKey.create)
    ..aOM<LocalPreKey>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'theirBaseKey', protoName: 'theirBaseKey', subBuilder: LocalPreKey.create)
    ..hasRequiredFields = false
  ;

  LocalSessionState._() : super();
  factory LocalSessionState({
    $core.int? sessionVersion,
    LocalPublicKey? remoteIdentityKey,
    LocalPublicKey? localIdentityKey,
    $core.String? localRegistrationId,
    $core.List<$core.int>? rootKey,
    LocalChain? sendingChain,
    LocalKeyPair? senderRatchetKeyPair,
    $core.Iterable<LocalPublicKeyAndChain>? receivingChains,
    $core.int? previousCounter,
    LocalPendingPreKey? pending,
    LocalPreKey? theirBaseKey,
  }) {
    final _result = create();
    if (sessionVersion != null) {
      _result.sessionVersion = sessionVersion;
    }
    if (remoteIdentityKey != null) {
      _result.remoteIdentityKey = remoteIdentityKey;
    }
    if (localIdentityKey != null) {
      _result.localIdentityKey = localIdentityKey;
    }
    if (localRegistrationId != null) {
      _result.localRegistrationId = localRegistrationId;
    }
    if (rootKey != null) {
      _result.rootKey = rootKey;
    }
    if (sendingChain != null) {
      _result.sendingChain = sendingChain;
    }
    if (senderRatchetKeyPair != null) {
      _result.senderRatchetKeyPair = senderRatchetKeyPair;
    }
    if (receivingChains != null) {
      _result.receivingChains.addAll(receivingChains);
    }
    if (previousCounter != null) {
      _result.previousCounter = previousCounter;
    }
    if (pending != null) {
      _result.pending = pending;
    }
    if (theirBaseKey != null) {
      _result.theirBaseKey = theirBaseKey;
    }
    return _result;
  }
  factory LocalSessionState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocalSessionState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocalSessionState clone() => LocalSessionState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocalSessionState copyWith(void Function(LocalSessionState) updates) => super.copyWith((message) => updates(message as LocalSessionState)) as LocalSessionState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocalSessionState create() => LocalSessionState._();
  LocalSessionState createEmptyInstance() => create();
  static $pb.PbList<LocalSessionState> createRepeated() => $pb.PbList<LocalSessionState>();
  @$core.pragma('dart2js:noInline')
  static LocalSessionState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocalSessionState>(create);
  static LocalSessionState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get sessionVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set sessionVersion($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionVersion() => clearField(1);

  @$pb.TagNumber(2)
  LocalPublicKey get remoteIdentityKey => $_getN(1);
  @$pb.TagNumber(2)
  set remoteIdentityKey(LocalPublicKey v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRemoteIdentityKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemoteIdentityKey() => clearField(2);
  @$pb.TagNumber(2)
  LocalPublicKey ensureRemoteIdentityKey() => $_ensure(1);

  @$pb.TagNumber(3)
  LocalPublicKey get localIdentityKey => $_getN(2);
  @$pb.TagNumber(3)
  set localIdentityKey(LocalPublicKey v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasLocalIdentityKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocalIdentityKey() => clearField(3);
  @$pb.TagNumber(3)
  LocalPublicKey ensureLocalIdentityKey() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get localRegistrationId => $_getSZ(3);
  @$pb.TagNumber(4)
  set localRegistrationId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLocalRegistrationId() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocalRegistrationId() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get rootKey => $_getN(4);
  @$pb.TagNumber(5)
  set rootKey($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRootKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearRootKey() => clearField(5);

  @$pb.TagNumber(6)
  LocalChain get sendingChain => $_getN(5);
  @$pb.TagNumber(6)
  set sendingChain(LocalChain v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasSendingChain() => $_has(5);
  @$pb.TagNumber(6)
  void clearSendingChain() => clearField(6);
  @$pb.TagNumber(6)
  LocalChain ensureSendingChain() => $_ensure(5);

  @$pb.TagNumber(7)
  LocalKeyPair get senderRatchetKeyPair => $_getN(6);
  @$pb.TagNumber(7)
  set senderRatchetKeyPair(LocalKeyPair v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasSenderRatchetKeyPair() => $_has(6);
  @$pb.TagNumber(7)
  void clearSenderRatchetKeyPair() => clearField(7);
  @$pb.TagNumber(7)
  LocalKeyPair ensureSenderRatchetKeyPair() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.List<LocalPublicKeyAndChain> get receivingChains => $_getList(7);

  @$pb.TagNumber(9)
  $core.int get previousCounter => $_getIZ(8);
  @$pb.TagNumber(9)
  set previousCounter($core.int v) { $_setUnsignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasPreviousCounter() => $_has(8);
  @$pb.TagNumber(9)
  void clearPreviousCounter() => clearField(9);

  @$pb.TagNumber(10)
  LocalPendingPreKey get pending => $_getN(9);
  @$pb.TagNumber(10)
  set pending(LocalPendingPreKey v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasPending() => $_has(9);
  @$pb.TagNumber(10)
  void clearPending() => clearField(10);
  @$pb.TagNumber(10)
  LocalPendingPreKey ensurePending() => $_ensure(9);

  @$pb.TagNumber(11)
  LocalPreKey get theirBaseKey => $_getN(10);
  @$pb.TagNumber(11)
  set theirBaseKey(LocalPreKey v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasTheirBaseKey() => $_has(10);
  @$pb.TagNumber(11)
  void clearTheirBaseKey() => clearField(11);
  @$pb.TagNumber(11)
  LocalPreKey ensureTheirBaseKey() => $_ensure(10);
}

class LocalSession extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocalSession', createEmptyInstance: create)
    ..aOM<LocalSessionMessaging>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionMessaging', protoName: 'sessionMessaging', subBuilder: LocalSessionMessaging.create)
    ..pc<LocalSessionState>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionStates', $pb.PbFieldType.PM, protoName: 'sessionStates', subBuilder: LocalSessionState.create)
    ..hasRequiredFields = false
  ;

  LocalSession._() : super();
  factory LocalSession({
    LocalSessionMessaging? sessionMessaging,
    $core.Iterable<LocalSessionState>? sessionStates,
  }) {
    final _result = create();
    if (sessionMessaging != null) {
      _result.sessionMessaging = sessionMessaging;
    }
    if (sessionStates != null) {
      _result.sessionStates.addAll(sessionStates);
    }
    return _result;
  }
  factory LocalSession.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocalSession.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocalSession clone() => LocalSession()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocalSession copyWith(void Function(LocalSession) updates) => super.copyWith((message) => updates(message as LocalSession)) as LocalSession; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocalSession create() => LocalSession._();
  LocalSession createEmptyInstance() => create();
  static $pb.PbList<LocalSession> createRepeated() => $pb.PbList<LocalSession>();
  @$core.pragma('dart2js:noInline')
  static LocalSession getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocalSession>(create);
  static LocalSession? _defaultInstance;

  @$pb.TagNumber(1)
  LocalSessionMessaging get sessionMessaging => $_getN(0);
  @$pb.TagNumber(1)
  set sessionMessaging(LocalSessionMessaging v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionMessaging() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionMessaging() => clearField(1);
  @$pb.TagNumber(1)
  LocalSessionMessaging ensureSessionMessaging() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<LocalSessionState> get sessionStates => $_getList(1);
}

class LocalStorage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LocalStorage', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localRegistrationId', $pb.PbFieldType.OY, protoName: 'localRegistrationId')
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localIdentityKeyPair', $pb.PbFieldType.OY, protoName: 'localIdentityKeyPair')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localPreKeyPairs', $pb.PbFieldType.OY, protoName: 'localPreKeyPairs')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localSignedPreKeyPairs', $pb.PbFieldType.OY, protoName: 'localSignedPreKeyPairs')
    ..a<$core.List<$core.int>>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'session', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  LocalStorage._() : super();
  factory LocalStorage({
    $core.List<$core.int>? localRegistrationId,
    $core.List<$core.int>? localIdentityKeyPair,
    $core.List<$core.int>? localPreKeyPairs,
    $core.List<$core.int>? localSignedPreKeyPairs,
    $core.List<$core.int>? session,
  }) {
    final _result = create();
    if (localRegistrationId != null) {
      _result.localRegistrationId = localRegistrationId;
    }
    if (localIdentityKeyPair != null) {
      _result.localIdentityKeyPair = localIdentityKeyPair;
    }
    if (localPreKeyPairs != null) {
      _result.localPreKeyPairs = localPreKeyPairs;
    }
    if (localSignedPreKeyPairs != null) {
      _result.localSignedPreKeyPairs = localSignedPreKeyPairs;
    }
    if (session != null) {
      _result.session = session;
    }
    return _result;
  }
  factory LocalStorage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocalStorage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocalStorage clone() => LocalStorage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocalStorage copyWith(void Function(LocalStorage) updates) => super.copyWith((message) => updates(message as LocalStorage)) as LocalStorage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LocalStorage create() => LocalStorage._();
  LocalStorage createEmptyInstance() => create();
  static $pb.PbList<LocalStorage> createRepeated() => $pb.PbList<LocalStorage>();
  @$core.pragma('dart2js:noInline')
  static LocalStorage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocalStorage>(create);
  static LocalStorage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get localRegistrationId => $_getN(0);
  @$pb.TagNumber(1)
  set localRegistrationId($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLocalRegistrationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocalRegistrationId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get localIdentityKeyPair => $_getN(1);
  @$pb.TagNumber(2)
  set localIdentityKeyPair($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLocalIdentityKeyPair() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocalIdentityKeyPair() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get localPreKeyPairs => $_getN(2);
  @$pb.TagNumber(3)
  set localPreKeyPairs($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLocalPreKeyPairs() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocalPreKeyPairs() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get localSignedPreKeyPairs => $_getN(3);
  @$pb.TagNumber(4)
  set localSignedPreKeyPairs($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLocalSignedPreKeyPairs() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocalSignedPreKeyPairs() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get session => $_getN(4);
  @$pb.TagNumber(5)
  set session($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSession() => $_has(4);
  @$pb.TagNumber(5)
  void clearSession() => clearField(5);
}

