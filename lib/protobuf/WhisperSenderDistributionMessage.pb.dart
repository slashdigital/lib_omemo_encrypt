///
//  Generated code. Do not modify.
//  source: lib/protobuf/WhisperSenderDistributionMessage.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SenderKeyDistributionMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SenderKeyDistributionMessage', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'iteration', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chainKey', $pb.PbFieldType.OY, protoName: 'chainKey')
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signingKey', $pb.PbFieldType.OY, protoName: 'signingKey')
    ..hasRequiredFields = false
  ;

  SenderKeyDistributionMessage._() : super();
  factory SenderKeyDistributionMessage({
    $core.int? id,
    $core.int? iteration,
    $core.List<$core.int>? chainKey,
    $core.List<$core.int>? signingKey,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (iteration != null) {
      _result.iteration = iteration;
    }
    if (chainKey != null) {
      _result.chainKey = chainKey;
    }
    if (signingKey != null) {
      _result.signingKey = signingKey;
    }
    return _result;
  }
  factory SenderKeyDistributionMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SenderKeyDistributionMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SenderKeyDistributionMessage clone() => SenderKeyDistributionMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SenderKeyDistributionMessage copyWith(void Function(SenderKeyDistributionMessage) updates) => super.copyWith((message) => updates(message as SenderKeyDistributionMessage)) as SenderKeyDistributionMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SenderKeyDistributionMessage create() => SenderKeyDistributionMessage._();
  SenderKeyDistributionMessage createEmptyInstance() => create();
  static $pb.PbList<SenderKeyDistributionMessage> createRepeated() => $pb.PbList<SenderKeyDistributionMessage>();
  @$core.pragma('dart2js:noInline')
  static SenderKeyDistributionMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SenderKeyDistributionMessage>(create);
  static SenderKeyDistributionMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get iteration => $_getIZ(1);
  @$pb.TagNumber(2)
  set iteration($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIteration() => $_has(1);
  @$pb.TagNumber(2)
  void clearIteration() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get chainKey => $_getN(2);
  @$pb.TagNumber(3)
  set chainKey($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasChainKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearChainKey() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get signingKey => $_getN(3);
  @$pb.TagNumber(4)
  set signingKey($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSigningKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearSigningKey() => clearField(4);
}

