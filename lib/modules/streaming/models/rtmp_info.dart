import 'package:freezed_annotation/freezed_annotation.dart';

part 'rtmp_info.freezed.dart';
part 'rtmp_info.g.dart';

@freezed
abstract class RtmpInfo with _$RtmpInfo {
  const factory RtmpInfo({
    @JsonKey(name: 'ingress_id') required String ingressId,
    required String name,
    @JsonKey(name: 'stream_key') required String streamKey,
    required String url,
  }) = _RtmpInfo;

  factory RtmpInfo.fromJson(Map<String, Object?> json) =>
      _$RtmpInfoFromJson(json);
}
