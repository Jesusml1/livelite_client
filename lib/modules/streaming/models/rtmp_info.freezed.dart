// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rtmp_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RtmpInfo {

 String get ingressId; String get name; String get streamKey; String get url;
/// Create a copy of RtmpInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RtmpInfoCopyWith<RtmpInfo> get copyWith => _$RtmpInfoCopyWithImpl<RtmpInfo>(this as RtmpInfo, _$identity);

  /// Serializes this RtmpInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RtmpInfo&&(identical(other.ingressId, ingressId) || other.ingressId == ingressId)&&(identical(other.name, name) || other.name == name)&&(identical(other.streamKey, streamKey) || other.streamKey == streamKey)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ingressId,name,streamKey,url);

@override
String toString() {
  return 'RtmpInfo(ingressId: $ingressId, name: $name, streamKey: $streamKey, url: $url)';
}


}

/// @nodoc
abstract mixin class $RtmpInfoCopyWith<$Res>  {
  factory $RtmpInfoCopyWith(RtmpInfo value, $Res Function(RtmpInfo) _then) = _$RtmpInfoCopyWithImpl;
@useResult
$Res call({
 String ingressId, String name, String streamKey, String url
});




}
/// @nodoc
class _$RtmpInfoCopyWithImpl<$Res>
    implements $RtmpInfoCopyWith<$Res> {
  _$RtmpInfoCopyWithImpl(this._self, this._then);

  final RtmpInfo _self;
  final $Res Function(RtmpInfo) _then;

/// Create a copy of RtmpInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ingressId = null,Object? name = null,Object? streamKey = null,Object? url = null,}) {
  return _then(_self.copyWith(
ingressId: null == ingressId ? _self.ingressId : ingressId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,streamKey: null == streamKey ? _self.streamKey : streamKey // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _RtmpInfo implements RtmpInfo {
  const _RtmpInfo({required this.ingressId, required this.name, required this.streamKey, required this.url});
  factory _RtmpInfo.fromJson(Map<String, dynamic> json) => _$RtmpInfoFromJson(json);

@override final  String ingressId;
@override final  String name;
@override final  String streamKey;
@override final  String url;

/// Create a copy of RtmpInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RtmpInfoCopyWith<_RtmpInfo> get copyWith => __$RtmpInfoCopyWithImpl<_RtmpInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RtmpInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RtmpInfo&&(identical(other.ingressId, ingressId) || other.ingressId == ingressId)&&(identical(other.name, name) || other.name == name)&&(identical(other.streamKey, streamKey) || other.streamKey == streamKey)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ingressId,name,streamKey,url);

@override
String toString() {
  return 'RtmpInfo(ingressId: $ingressId, name: $name, streamKey: $streamKey, url: $url)';
}


}

/// @nodoc
abstract mixin class _$RtmpInfoCopyWith<$Res> implements $RtmpInfoCopyWith<$Res> {
  factory _$RtmpInfoCopyWith(_RtmpInfo value, $Res Function(_RtmpInfo) _then) = __$RtmpInfoCopyWithImpl;
@override @useResult
$Res call({
 String ingressId, String name, String streamKey, String url
});




}
/// @nodoc
class __$RtmpInfoCopyWithImpl<$Res>
    implements _$RtmpInfoCopyWith<$Res> {
  __$RtmpInfoCopyWithImpl(this._self, this._then);

  final _RtmpInfo _self;
  final $Res Function(_RtmpInfo) _then;

/// Create a copy of RtmpInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ingressId = null,Object? name = null,Object? streamKey = null,Object? url = null,}) {
  return _then(_RtmpInfo(
ingressId: null == ingressId ? _self.ingressId : ingressId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,streamKey: null == streamKey ? _self.streamKey : streamKey // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
