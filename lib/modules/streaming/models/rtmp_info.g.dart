// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rtmp_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RtmpInfo _$RtmpInfoFromJson(Map<String, dynamic> json) => _RtmpInfo(
  ingressId: json['ingress_id'] as String,
  name: json['name'] as String,
  streamKey: json['stream_key'] as String,
  url: json['url'] as String,
);

Map<String, dynamic> _$RtmpInfoToJson(_RtmpInfo instance) => <String, dynamic>{
  'ingress_id': instance.ingressId,
  'name': instance.name,
  'stream_key': instance.streamKey,
  'url': instance.url,
};
