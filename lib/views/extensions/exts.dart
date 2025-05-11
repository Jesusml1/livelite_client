import 'package:flutter/material.dart';

extension LKExampleExt on BuildContext {
  //
  Future<bool?> showPublishDialog() => showDialog<bool>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('publish'),
          content: const Text('publishCamAndMic'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('no'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('yes'),
            ),
          ],
        ),
      );

  Future<bool?> showPlayAudioManuallyDialog() => showDialog<bool>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('playAudio'),
          content: const Text('activateAudioSafari'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('ignore'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('playAudio'),
            ),
          ],
        ),
      );

  Future<bool?> showUnPublishDialog() => showDialog<bool>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('unpublish'),
          content: const Text('unpublishCamAndMic'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('no'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('yes'),
            ),
          ],
        ),
      );

  Future<void> showErrorDialog(dynamic exception) => showDialog<void>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('unknownErrorThree'),
          content: Text(exception.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('ok'),
            )
          ],
        ),
      );

  Future<bool?> showDisconnectDialog() => showDialog<bool>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('disconnect'),
          content: const Text('disconnectConfirmation'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('disconnect'),
            ),
          ],
        ),
      );

  Future<bool?> showReconnectDialog() => showDialog<bool>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('reconnect'),
          content: const Text('reconnectionForce'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('reconnect'),
            ),
          ],
        ),
      );

  Future<void> showReconnectSuccessDialog() => showDialog<void>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('reconnect'),
          content: const Text('reconnectionSuccess'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('ok'),
            ),
          ],
        ),
      );

  Future<bool?> showSendDataDialog() => showDialog<bool>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('sendData'),
          content: const Text('sampleDataWarning'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('send'),
            ),
          ],
        ),
      );

  Future<bool?> showDataReceivedDialog(String data) => showDialog<bool>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('receivedData'),
          content: Text(data),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('ok'),
            ),
          ],
        ),
      );

  Future<bool?> showRecordingStatusChangedDialog(bool isActiveRecording) =>
      showDialog<bool>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('roomRecordingReminder'),
          content: Text(isActiveRecording
              ? 'roomRecordingActive'
              : 'roomRecordingStopped'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('ok'),
            ),
          ],
        ),
      );

  Future<bool?> showSubscribePermissionDialog() => showDialog<bool>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('allowSubscription'),
          content: const Text('allowParticipants'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('no'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('yes'),
            ),
          ],
        ),
      );

  Future<SimulateScenarioResult?> showSimulateScenarioDialog() =>
      showDialog<SimulateScenarioResult>(
        context: this,
        builder: (ctx) => SimpleDialog(
          title: const Text('simulateScenario'),
          children: SimulateScenarioResult.values
              .map((e) => SimpleDialogOption(
                    child: Text(e.name),
                    onPressed: () => Navigator.pop(ctx, e),
                  ))
              .toList(),
        ),
      );
}

enum SimulateScenarioResult {
  signalReconnect,
  fullReconnect,
  speakerUpdate,
  nodeFailure,
  migration,
  serverLeave,
  switchCandidate,
  e2eeKeyRatchet,
  participantName,
  participantMetadata,
  clear,
}
