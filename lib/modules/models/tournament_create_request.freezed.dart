// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_create_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TournamentCreateRequest {

 String get mode; String get game; String get confrontationType; String get playersAmount; String get teamSize; String get substitutesAmount; String get name; String get date; String get time; String get region; String get admissionMode; String get eliminationType; int get minTeams; int get maxTeams; int get teamsPerMatch; String get pointSystem; int get pointsPerKill; String get registrationType; String get condutionMode; bool get autoStartMatch; bool get autoCancelMatch; bool get autoCancelFailedMatch;
/// Create a copy of TournamentCreateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentCreateRequestCopyWith<TournamentCreateRequest> get copyWith => _$TournamentCreateRequestCopyWithImpl<TournamentCreateRequest>(this as TournamentCreateRequest, _$identity);

  /// Serializes this TournamentCreateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentCreateRequest&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.game, game) || other.game == game)&&(identical(other.confrontationType, confrontationType) || other.confrontationType == confrontationType)&&(identical(other.playersAmount, playersAmount) || other.playersAmount == playersAmount)&&(identical(other.teamSize, teamSize) || other.teamSize == teamSize)&&(identical(other.substitutesAmount, substitutesAmount) || other.substitutesAmount == substitutesAmount)&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.region, region) || other.region == region)&&(identical(other.admissionMode, admissionMode) || other.admissionMode == admissionMode)&&(identical(other.eliminationType, eliminationType) || other.eliminationType == eliminationType)&&(identical(other.minTeams, minTeams) || other.minTeams == minTeams)&&(identical(other.maxTeams, maxTeams) || other.maxTeams == maxTeams)&&(identical(other.teamsPerMatch, teamsPerMatch) || other.teamsPerMatch == teamsPerMatch)&&(identical(other.pointSystem, pointSystem) || other.pointSystem == pointSystem)&&(identical(other.pointsPerKill, pointsPerKill) || other.pointsPerKill == pointsPerKill)&&(identical(other.registrationType, registrationType) || other.registrationType == registrationType)&&(identical(other.condutionMode, condutionMode) || other.condutionMode == condutionMode)&&(identical(other.autoStartMatch, autoStartMatch) || other.autoStartMatch == autoStartMatch)&&(identical(other.autoCancelMatch, autoCancelMatch) || other.autoCancelMatch == autoCancelMatch)&&(identical(other.autoCancelFailedMatch, autoCancelFailedMatch) || other.autoCancelFailedMatch == autoCancelFailedMatch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,mode,game,confrontationType,playersAmount,teamSize,substitutesAmount,name,date,time,region,admissionMode,eliminationType,minTeams,maxTeams,teamsPerMatch,pointSystem,pointsPerKill,registrationType,condutionMode,autoStartMatch,autoCancelMatch,autoCancelFailedMatch]);

@override
String toString() {
  return 'TournamentCreateRequest(mode: $mode, game: $game, confrontationType: $confrontationType, playersAmount: $playersAmount, teamSize: $teamSize, substitutesAmount: $substitutesAmount, name: $name, date: $date, time: $time, region: $region, admissionMode: $admissionMode, eliminationType: $eliminationType, minTeams: $minTeams, maxTeams: $maxTeams, teamsPerMatch: $teamsPerMatch, pointSystem: $pointSystem, pointsPerKill: $pointsPerKill, registrationType: $registrationType, condutionMode: $condutionMode, autoStartMatch: $autoStartMatch, autoCancelMatch: $autoCancelMatch, autoCancelFailedMatch: $autoCancelFailedMatch)';
}


}

/// @nodoc
abstract mixin class $TournamentCreateRequestCopyWith<$Res>  {
  factory $TournamentCreateRequestCopyWith(TournamentCreateRequest value, $Res Function(TournamentCreateRequest) _then) = _$TournamentCreateRequestCopyWithImpl;
@useResult
$Res call({
 String mode, String game, String confrontationType, String playersAmount, String teamSize, String substitutesAmount, String name, String date, String time, String region, String admissionMode, String eliminationType, int minTeams, int maxTeams, int teamsPerMatch, String pointSystem, int pointsPerKill, String registrationType, String condutionMode, bool autoStartMatch, bool autoCancelMatch, bool autoCancelFailedMatch
});




}
/// @nodoc
class _$TournamentCreateRequestCopyWithImpl<$Res>
    implements $TournamentCreateRequestCopyWith<$Res> {
  _$TournamentCreateRequestCopyWithImpl(this._self, this._then);

  final TournamentCreateRequest _self;
  final $Res Function(TournamentCreateRequest) _then;

/// Create a copy of TournamentCreateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? game = null,Object? confrontationType = null,Object? playersAmount = null,Object? teamSize = null,Object? substitutesAmount = null,Object? name = null,Object? date = null,Object? time = null,Object? region = null,Object? admissionMode = null,Object? eliminationType = null,Object? minTeams = null,Object? maxTeams = null,Object? teamsPerMatch = null,Object? pointSystem = null,Object? pointsPerKill = null,Object? registrationType = null,Object? condutionMode = null,Object? autoStartMatch = null,Object? autoCancelMatch = null,Object? autoCancelFailedMatch = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,game: null == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as String,confrontationType: null == confrontationType ? _self.confrontationType : confrontationType // ignore: cast_nullable_to_non_nullable
as String,playersAmount: null == playersAmount ? _self.playersAmount : playersAmount // ignore: cast_nullable_to_non_nullable
as String,teamSize: null == teamSize ? _self.teamSize : teamSize // ignore: cast_nullable_to_non_nullable
as String,substitutesAmount: null == substitutesAmount ? _self.substitutesAmount : substitutesAmount // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,admissionMode: null == admissionMode ? _self.admissionMode : admissionMode // ignore: cast_nullable_to_non_nullable
as String,eliminationType: null == eliminationType ? _self.eliminationType : eliminationType // ignore: cast_nullable_to_non_nullable
as String,minTeams: null == minTeams ? _self.minTeams : minTeams // ignore: cast_nullable_to_non_nullable
as int,maxTeams: null == maxTeams ? _self.maxTeams : maxTeams // ignore: cast_nullable_to_non_nullable
as int,teamsPerMatch: null == teamsPerMatch ? _self.teamsPerMatch : teamsPerMatch // ignore: cast_nullable_to_non_nullable
as int,pointSystem: null == pointSystem ? _self.pointSystem : pointSystem // ignore: cast_nullable_to_non_nullable
as String,pointsPerKill: null == pointsPerKill ? _self.pointsPerKill : pointsPerKill // ignore: cast_nullable_to_non_nullable
as int,registrationType: null == registrationType ? _self.registrationType : registrationType // ignore: cast_nullable_to_non_nullable
as String,condutionMode: null == condutionMode ? _self.condutionMode : condutionMode // ignore: cast_nullable_to_non_nullable
as String,autoStartMatch: null == autoStartMatch ? _self.autoStartMatch : autoStartMatch // ignore: cast_nullable_to_non_nullable
as bool,autoCancelMatch: null == autoCancelMatch ? _self.autoCancelMatch : autoCancelMatch // ignore: cast_nullable_to_non_nullable
as bool,autoCancelFailedMatch: null == autoCancelFailedMatch ? _self.autoCancelFailedMatch : autoCancelFailedMatch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TournamentCreateRequest implements TournamentCreateRequest {
  const _TournamentCreateRequest({required this.mode, required this.game, required this.confrontationType, required this.playersAmount, required this.teamSize, required this.substitutesAmount, required this.name, required this.date, required this.time, required this.region, required this.admissionMode, required this.eliminationType, required this.minTeams, required this.maxTeams, required this.teamsPerMatch, required this.pointSystem, required this.pointsPerKill, required this.registrationType, required this.condutionMode, required this.autoStartMatch, required this.autoCancelMatch, required this.autoCancelFailedMatch});
  factory _TournamentCreateRequest.fromJson(Map<String, dynamic> json) => _$TournamentCreateRequestFromJson(json);

@override final  String mode;
@override final  String game;
@override final  String confrontationType;
@override final  String playersAmount;
@override final  String teamSize;
@override final  String substitutesAmount;
@override final  String name;
@override final  String date;
@override final  String time;
@override final  String region;
@override final  String admissionMode;
@override final  String eliminationType;
@override final  int minTeams;
@override final  int maxTeams;
@override final  int teamsPerMatch;
@override final  String pointSystem;
@override final  int pointsPerKill;
@override final  String registrationType;
@override final  String condutionMode;
@override final  bool autoStartMatch;
@override final  bool autoCancelMatch;
@override final  bool autoCancelFailedMatch;

/// Create a copy of TournamentCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TournamentCreateRequestCopyWith<_TournamentCreateRequest> get copyWith => __$TournamentCreateRequestCopyWithImpl<_TournamentCreateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TournamentCreateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TournamentCreateRequest&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.game, game) || other.game == game)&&(identical(other.confrontationType, confrontationType) || other.confrontationType == confrontationType)&&(identical(other.playersAmount, playersAmount) || other.playersAmount == playersAmount)&&(identical(other.teamSize, teamSize) || other.teamSize == teamSize)&&(identical(other.substitutesAmount, substitutesAmount) || other.substitutesAmount == substitutesAmount)&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.region, region) || other.region == region)&&(identical(other.admissionMode, admissionMode) || other.admissionMode == admissionMode)&&(identical(other.eliminationType, eliminationType) || other.eliminationType == eliminationType)&&(identical(other.minTeams, minTeams) || other.minTeams == minTeams)&&(identical(other.maxTeams, maxTeams) || other.maxTeams == maxTeams)&&(identical(other.teamsPerMatch, teamsPerMatch) || other.teamsPerMatch == teamsPerMatch)&&(identical(other.pointSystem, pointSystem) || other.pointSystem == pointSystem)&&(identical(other.pointsPerKill, pointsPerKill) || other.pointsPerKill == pointsPerKill)&&(identical(other.registrationType, registrationType) || other.registrationType == registrationType)&&(identical(other.condutionMode, condutionMode) || other.condutionMode == condutionMode)&&(identical(other.autoStartMatch, autoStartMatch) || other.autoStartMatch == autoStartMatch)&&(identical(other.autoCancelMatch, autoCancelMatch) || other.autoCancelMatch == autoCancelMatch)&&(identical(other.autoCancelFailedMatch, autoCancelFailedMatch) || other.autoCancelFailedMatch == autoCancelFailedMatch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,mode,game,confrontationType,playersAmount,teamSize,substitutesAmount,name,date,time,region,admissionMode,eliminationType,minTeams,maxTeams,teamsPerMatch,pointSystem,pointsPerKill,registrationType,condutionMode,autoStartMatch,autoCancelMatch,autoCancelFailedMatch]);

@override
String toString() {
  return 'TournamentCreateRequest(mode: $mode, game: $game, confrontationType: $confrontationType, playersAmount: $playersAmount, teamSize: $teamSize, substitutesAmount: $substitutesAmount, name: $name, date: $date, time: $time, region: $region, admissionMode: $admissionMode, eliminationType: $eliminationType, minTeams: $minTeams, maxTeams: $maxTeams, teamsPerMatch: $teamsPerMatch, pointSystem: $pointSystem, pointsPerKill: $pointsPerKill, registrationType: $registrationType, condutionMode: $condutionMode, autoStartMatch: $autoStartMatch, autoCancelMatch: $autoCancelMatch, autoCancelFailedMatch: $autoCancelFailedMatch)';
}


}

/// @nodoc
abstract mixin class _$TournamentCreateRequestCopyWith<$Res> implements $TournamentCreateRequestCopyWith<$Res> {
  factory _$TournamentCreateRequestCopyWith(_TournamentCreateRequest value, $Res Function(_TournamentCreateRequest) _then) = __$TournamentCreateRequestCopyWithImpl;
@override @useResult
$Res call({
 String mode, String game, String confrontationType, String playersAmount, String teamSize, String substitutesAmount, String name, String date, String time, String region, String admissionMode, String eliminationType, int minTeams, int maxTeams, int teamsPerMatch, String pointSystem, int pointsPerKill, String registrationType, String condutionMode, bool autoStartMatch, bool autoCancelMatch, bool autoCancelFailedMatch
});




}
/// @nodoc
class __$TournamentCreateRequestCopyWithImpl<$Res>
    implements _$TournamentCreateRequestCopyWith<$Res> {
  __$TournamentCreateRequestCopyWithImpl(this._self, this._then);

  final _TournamentCreateRequest _self;
  final $Res Function(_TournamentCreateRequest) _then;

/// Create a copy of TournamentCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? game = null,Object? confrontationType = null,Object? playersAmount = null,Object? teamSize = null,Object? substitutesAmount = null,Object? name = null,Object? date = null,Object? time = null,Object? region = null,Object? admissionMode = null,Object? eliminationType = null,Object? minTeams = null,Object? maxTeams = null,Object? teamsPerMatch = null,Object? pointSystem = null,Object? pointsPerKill = null,Object? registrationType = null,Object? condutionMode = null,Object? autoStartMatch = null,Object? autoCancelMatch = null,Object? autoCancelFailedMatch = null,}) {
  return _then(_TournamentCreateRequest(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,game: null == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as String,confrontationType: null == confrontationType ? _self.confrontationType : confrontationType // ignore: cast_nullable_to_non_nullable
as String,playersAmount: null == playersAmount ? _self.playersAmount : playersAmount // ignore: cast_nullable_to_non_nullable
as String,teamSize: null == teamSize ? _self.teamSize : teamSize // ignore: cast_nullable_to_non_nullable
as String,substitutesAmount: null == substitutesAmount ? _self.substitutesAmount : substitutesAmount // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,admissionMode: null == admissionMode ? _self.admissionMode : admissionMode // ignore: cast_nullable_to_non_nullable
as String,eliminationType: null == eliminationType ? _self.eliminationType : eliminationType // ignore: cast_nullable_to_non_nullable
as String,minTeams: null == minTeams ? _self.minTeams : minTeams // ignore: cast_nullable_to_non_nullable
as int,maxTeams: null == maxTeams ? _self.maxTeams : maxTeams // ignore: cast_nullable_to_non_nullable
as int,teamsPerMatch: null == teamsPerMatch ? _self.teamsPerMatch : teamsPerMatch // ignore: cast_nullable_to_non_nullable
as int,pointSystem: null == pointSystem ? _self.pointSystem : pointSystem // ignore: cast_nullable_to_non_nullable
as String,pointsPerKill: null == pointsPerKill ? _self.pointsPerKill : pointsPerKill // ignore: cast_nullable_to_non_nullable
as int,registrationType: null == registrationType ? _self.registrationType : registrationType // ignore: cast_nullable_to_non_nullable
as String,condutionMode: null == condutionMode ? _self.condutionMode : condutionMode // ignore: cast_nullable_to_non_nullable
as String,autoStartMatch: null == autoStartMatch ? _self.autoStartMatch : autoStartMatch // ignore: cast_nullable_to_non_nullable
as bool,autoCancelMatch: null == autoCancelMatch ? _self.autoCancelMatch : autoCancelMatch // ignore: cast_nullable_to_non_nullable
as bool,autoCancelFailedMatch: null == autoCancelFailedMatch ? _self.autoCancelFailedMatch : autoCancelFailedMatch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
