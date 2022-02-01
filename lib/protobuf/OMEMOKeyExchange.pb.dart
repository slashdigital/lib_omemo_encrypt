///
//  Generated code. Do not modify.
//  source: lib/protobuf/OMEMOKeyExchange.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class OMEMOKeyExchange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OMEMOKeyExchange', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pkId', $pb.PbFieldType.QU3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'spkId', $pb.PbFieldType.QU3)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ik', $pb.PbFieldType.QY)
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ek', $pb.PbFieldType.QY)
    ..a<$core.List<$core.int>>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message', $pb.PbFieldType.QY)
    ..a<$core.List<$core.int>>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'registrationId', $pb.PbFieldType.OY, protoName: 'registrationId')
  ;

  OMEMOKeyExchange._() : super();
  factory OMEMOKeyExchange({
    $core.int? pkId,
    $core.int? spkId,
    $core.List<$core.int>? ik,
    $core.List<$core.int>? ek,
    $core.List<$core.int>? message,
    $core.List<$core.int>? registrationId,
  }) {
    final _result = create();
    if (pkId != null) {
      _result.pkId = pkId;
    }
    if (spkId != null) {
      _result.spkId = spkId;
    }
    if (ik != null) {
      _result.ik = ik;
    }
    if (ek != null) {
      _result.ek = ek;
    }
    if (message != null) {
      _result.message = message;
    }
    if (registrationId != null) {
      _result.registrationId = registrationId;
    }
    return _result;
  }
  factory OMEMOKeyExchange.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OMEMOKeyExchange.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OMEMOKeyExchange clone() => OMEMOKeyExchange()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OMEMOKeyExchange copyWith(void Function(OMEMOKeyExchange) updates) => super.copyWith((message) => updates(message as OMEMOKeyExchange)) as OMEMOKeyExchange; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OMEMOKeyExchange create() => OMEMOKeyExchange._();
  OMEMOKeyExchange createEmptyInstance() => create();
  static $pb.PbList<OMEMOKeyExchange> createRepeated() => $pb.PbList<OMEMOKeyExchange>();
  @$core.pragma('dart2js:noInline')
  static OMEMOKeyExchange getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OMEMOKeyExchange>(create);
  static OMEMOKeyExchange? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pkId => $_getIZ(0);
  @$pb.TagNumber(1)
  set pkId($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPkId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get spkId => $_getIZ(1);
  @$pb.TagNumber(2)
  set spkId($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSpkId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSpkId() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get ik => $_getN(2);
  @$pb.TagNumber(3)
  set ik($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIk() => $_has(2);
  @$pb.TagNumber(3)
  void clearIk() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get ek => $_getN(3);
  @$pb.TagNumber(4)
  set ek($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasEk() => $_has(3);
  @$pb.TagNumber(4)
  void clearEk() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get message => $_getN(4);
  @$pb.TagNumber(5)
  set message($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearMessage() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get registrationId => $_getN(5);
  @$pb.TagNumber(6)
  set registrationId($core.List<$core.int> v) { $_setBytes(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasRegistrationId() => $_has(5);
  @$pb.TagNumber(6)
  void clearRegistrationId() => clearField(6);
}

