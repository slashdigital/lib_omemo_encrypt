///
//  Generated code. Do not modify.
//  source: lib/protobuf/OMEMOAuthenticatedMessage.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class OMEMOAuthenticatedMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OMEMOAuthenticatedMessage', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mac', $pb.PbFieldType.QY)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message', $pb.PbFieldType.QY)
  ;

  OMEMOAuthenticatedMessage._() : super();
  factory OMEMOAuthenticatedMessage({
    $core.List<$core.int>? mac,
    $core.List<$core.int>? message,
  }) {
    final _result = create();
    if (mac != null) {
      _result.mac = mac;
    }
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory OMEMOAuthenticatedMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OMEMOAuthenticatedMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OMEMOAuthenticatedMessage clone() => OMEMOAuthenticatedMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OMEMOAuthenticatedMessage copyWith(void Function(OMEMOAuthenticatedMessage) updates) => super.copyWith((message) => updates(message as OMEMOAuthenticatedMessage)) as OMEMOAuthenticatedMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OMEMOAuthenticatedMessage create() => OMEMOAuthenticatedMessage._();
  OMEMOAuthenticatedMessage createEmptyInstance() => create();
  static $pb.PbList<OMEMOAuthenticatedMessage> createRepeated() => $pb.PbList<OMEMOAuthenticatedMessage>();
  @$core.pragma('dart2js:noInline')
  static OMEMOAuthenticatedMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OMEMOAuthenticatedMessage>(create);
  static OMEMOAuthenticatedMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get mac => $_getN(0);
  @$pb.TagNumber(1)
  set mac($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMac() => $_has(0);
  @$pb.TagNumber(1)
  void clearMac() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get message => $_getN(1);
  @$pb.TagNumber(2)
  set message($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

