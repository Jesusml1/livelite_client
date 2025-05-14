import 'package:freezed_annotation/freezed_annotation.dart';

part 'tournament_create_request.freezed.dart';
part 'tournament_create_request.g.dart';

@freezed
abstract class TournamentCreateRequest with _$TournamentCreateRequest {
  const factory TournamentCreateRequest({
    required String mode,
    required String game,
    required String confrontationType,
    required String playersAmount,
    required String teamSize,
    required String substitutesAmount,

    required String name,
    required String date,
    required String time,
    required String region,
    required String admissionMode,

    required String eliminationType,
    required int minTeams,
    required int maxTeams,
    required int teamsPerMatch,
    required String pointSystem,
    required int pointsPerKill,

    required String registrationType,
    required String condutionMode,
    required bool autoStartMatch,
    required bool autoCancelMatch,
    required bool autoCancelFailedMatch,
  }) = _TournamentCreateRequest;

  factory TournamentCreateRequest.fromJson(Map<String, Object?> json) =>
      _$TournamentCreateRequestFromJson(json);
}
