// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TournamentCreateRequest _$TournamentCreateRequestFromJson(
  Map<String, dynamic> json,
) => _TournamentCreateRequest(
  mode: json['mode'] as String,
  game: json['game'] as String,
  confrontationType: json['confrontationType'] as String,
  playersAmount: json['playersAmount'] as String,
  teamSize: json['teamSize'] as String,
  substitutesAmount: json['substitutesAmount'] as String,
  name: json['name'] as String,
  date: json['date'] as String,
  time: json['time'] as String,
  region: json['region'] as String,
  admissionMode: json['admissionMode'] as String,
  eliminationType: json['eliminationType'] as String,
  minTeams: (json['minTeams'] as num).toInt(),
  maxTeams: (json['maxTeams'] as num).toInt(),
  teamsPerMatch: (json['teamsPerMatch'] as num).toInt(),
  pointSystem: json['pointSystem'] as String,
  pointsPerKill: (json['pointsPerKill'] as num).toInt(),
  registrationType: json['registrationType'] as String,
  condutionMode: json['condutionMode'] as String,
  autoStartMatch: json['autoStartMatch'] as bool,
  autoCancelMatch: json['autoCancelMatch'] as bool,
  autoCancelFailedMatch: json['autoCancelFailedMatch'] as bool,
);

Map<String, dynamic> _$TournamentCreateRequestToJson(
  _TournamentCreateRequest instance,
) => <String, dynamic>{
  'mode': instance.mode,
  'game': instance.game,
  'confrontationType': instance.confrontationType,
  'playersAmount': instance.playersAmount,
  'teamSize': instance.teamSize,
  'substitutesAmount': instance.substitutesAmount,
  'name': instance.name,
  'date': instance.date,
  'time': instance.time,
  'region': instance.region,
  'admissionMode': instance.admissionMode,
  'eliminationType': instance.eliminationType,
  'minTeams': instance.minTeams,
  'maxTeams': instance.maxTeams,
  'teamsPerMatch': instance.teamsPerMatch,
  'pointSystem': instance.pointSystem,
  'pointsPerKill': instance.pointsPerKill,
  'registrationType': instance.registrationType,
  'condutionMode': instance.condutionMode,
  'autoStartMatch': instance.autoStartMatch,
  'autoCancelMatch': instance.autoCancelMatch,
  'autoCancelFailedMatch': instance.autoCancelFailedMatch,
};
