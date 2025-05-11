// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rtmp_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RtmpInfo _$RtmpInfoFromJson(Map<String, dynamic> json) => _RtmpInfo(
  ingressId: json['ingressId'] as String,
  name: json['name'] as String,
  streamKey: json['streamKey'] as String,
  url: json['url'] as String,
);

Map<String, dynamic> _$RtmpInfoToJson(_RtmpInfo instance) => <String, dynamic>{
  'ingressId': instance.ingressId,
  'name': instance.name,
  'streamKey': instance.streamKey,
  'url': instance.url,
};
