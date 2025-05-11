import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:livelite_client/config/config.dart';
import 'package:livelite_client/modules/streaming/backend/streaming.dart';
import 'package:livelite_client/modules/streaming/models/room.dart';
import 'package:livekit_client/livekit_client.dart' as lkclient;
import 'package:livelite_client/views/watch_room_screen.dart';

class AvailableRoomsWidget extends StatefulWidget {
  final List<Room> rooms;

  const AvailableRoomsWidget({super.key, required this.rooms});

  @override
  State<AvailableRoomsWidget> createState() => _AvailableRoomsWidgetState();
}

class _AvailableRoomsWidgetState extends State<AvailableRoomsWidget> {
  bool _busy = false;
  final String url = Config.livekitUrl;

  @override
  Widget build(BuildContext context) {
    join(BuildContext context, String roomName) async {
      if (_busy) {
        return;
      }

      try {
        setState(() {
          _busy = true;
        });

        String? token;
        token = await generateTokenToJoin(
          roomName: roomName,
          nickname: "fulanito",
        );
        if (token == null) {
          return;
        }

        final room = lkclient.Room(
          roomOptions: lkclient.RoomOptions(
            adaptiveStream: true,
            dynacast: true,
            defaultVideoPublishOptions: const lkclient.VideoPublishOptions(
              stream: 'custom_sync_stream_id',
              simulcast: true,
              videoCodec: 'VP8',
              backupVideoCodec: lkclient.BackupVideoCodec(enabled: true),
            ),
            defaultCameraCaptureOptions: lkclient.CameraCaptureOptions(
              maxFrameRate: 30,
              params: lkclient.VideoParametersPresets.h720_169,
            ),
          ),
        );
        final listener = room.createListener();

        await room.connect(url, token);

        if (context.mounted) {
          await Navigator.push<void>(
            context,
            MaterialPageRoute(
              builder:
                  (_) => WatchStreamView(room, () async {
                    await Future.delayed(const Duration(seconds: 10));
                  }, listener),
            ),
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('could not join $e');
        }
      } finally {
        setState(() {
          _busy = false;
        });
      }
    }

    return ListView.builder(
      itemCount: widget.rooms.length,
      itemBuilder: (context, index) {
        final room = widget.rooms[index];
        return ListTile(
          title: Text(room.name),
          trailing: ElevatedButton(
            onPressed: _busy ? null : () => join(context, room.name),
            child: Text('Join'),
          ),
        );
      },
    );
  }
}
