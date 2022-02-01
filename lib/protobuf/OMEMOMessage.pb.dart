///
//  Generated code. Do not modify.
//  source: lib/protobuf/OMEMOMessage.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class OMEMOMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OMEMOMessage', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'n', $pb.PbFieldType.QU3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pn', $pb.PbFieldType.QU3)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dhPub', $pb.PbFieldType.QY)
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ciphertext', $pb.PbFieldType.OY)
  ;

  OMEMOMessage._() : super();
  factory OMEMOMessage({
    $core.int? n,
    $core.int? pn,
    $core.List<$core.int>? dhPub,
    $core.List<$core.int>? ciphertext,
  }) {
    final _result = create();
    if (n != null) {
      _result.n = n;
    }
    if (pn != null) {
      _result.pn = pn;
    }
    if (dhPub != null) {
      _result.dhPub = dhPub;
    }
    if (ciphertext != null) {
      _result.ciphertext = ciphertext;
    }
    return _result;
  }
  factory OMEMOMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OMEMOMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OMEMOMessage clone() => OMEMOMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OMEMOMessage copyWith(void Function(OMEMOMessage) updates) => super.copyWith((message) => updates(message as OMEMOMessage)) as OMEMOMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OMEMOMessage create() => OMEMOMessage._();
  OMEMOMessage createEmptyInstance() => create();
  static $pb.PbList<OMEMOMessage> createRepeated() => $pb.PbList<OMEMOMessage>();
  @$core.pragma('dart2js:noInline')
  static OMEMOMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OMEMOMessage>(create);
  static OMEMOMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get n => $_getIZ(0);
  @$pb.TagNumber(1)
  set n($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasN() => $_has(0);
  @$pb.TagNumber(1)
  void clearN() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get pn => $_getIZ(1);
  @$pb.TagNumber(2)
  set pn($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPn() => $_has(1);
  @$pb.TagNumber(2)
  void clearPn() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get dhPub => $_getN(2);
  @$pb.TagNumber(3)
  set dhPub($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDhPub() => $_has(2);
  @$pb.TagNumber(3)
  void clearDhPub() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get ciphertext => $_getN(3);
  @$pb.TagNumber(4)
  set ciphertext($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCiphertext() => $_has(3);
  @$pb.TagNumber(4)
  void clearCiphertext() => clearField(4);
}

