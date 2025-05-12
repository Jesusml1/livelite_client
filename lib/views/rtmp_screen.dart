import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:livelite_client/config/storage.dart';
import 'package:livelite_client/modules/streaming/backend/streaming.dart';
import 'package:livelite_client/modules/streaming/models/rtmp_info.dart';

class RtmpScreen extends StatefulWidget {
  const RtmpScreen({super.key});

  @override
  State<RtmpScreen> createState() => _RtmpScreenState();
}

class _RtmpScreenState extends State<RtmpScreen> {
  bool _loading = false;
  bool _loadingData = false;
  RtmpInfo? _rtmpInfo;

  late TextEditingController roomNameTEC;
  late TextEditingController streamNameTEC;
  late TextEditingController nicknameTEC;

  @override
  void initState() {
    super.initState();
    checkRtmpInfo();
    roomNameTEC = TextEditingController();
    streamNameTEC = TextEditingController();
    nicknameTEC = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    roomNameTEC.dispose();
    streamNameTEC.dispose();
    nicknameTEC.dispose();
  }

  Future<void> checkRtmpInfo() async {
    final secureStorage = SecureStorage();
    final rtmpInfo = await secureStorage.readRtmpInfo();
    if (rtmpInfo != null) {
      setState(() {
        _rtmpInfo = rtmpInfo;
      });
      Fluttertoast.showToast(msg: 'key: ${rtmpInfo.streamKey}');
    }
    setState(() {
      _loadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> handleRtmpLink() async {
      if (_loading) {
        return;
      }

      setState(() {
        _loading = true;
      });

      if (roomNameTEC.text.isEmpty ||
          streamNameTEC.text.isEmpty ||
          nicknameTEC.text.isEmpty) {
        Fluttertoast.showToast(msg: 'Fill the inputs');
      } else {
        print('generating rtmp...');
        RtmpInfo? info = await getRtmpInfo(
          roomName: roomNameTEC.text,
          streamTitle: streamNameTEC.text,
          nickname: nicknameTEC.text,
        );

        if (info != null) {
          final secureStorage = SecureStorage();
          final success = await secureStorage.writeRtmpInfo(info);
          if (success) {
            setState(() {
              _rtmpInfo = info;
            });
          }
        }
      }

      setState(() {
        _loading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text('RTMP info')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Builder(
            builder: (context) {
              if (_loadingData) {
                return CircularProgressIndicator();
              }
              if (_rtmpInfo != null) {
                return Column(
                  spacing: 16,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STREAM NAME',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        Row(
                          children: [
                            Text(_rtmpInfo!.name),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'URL',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        Row(
                          children: [
                            Expanded(child: Text(_rtmpInfo!.url)),
                            TextButton(
                              child: Icon(Icons.copy),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STREAM KEY',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        Row(
                          children: [
                            Expanded(child: Text(_rtmpInfo!.streamKey)),
                            TextButton(
                              child: Icon(Icons.copy),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () async {
                        final secureStorage = SecureStorage();
                        await secureStorage.removeRtmpInfo();
                      },
                      child: Text('Remove rtmp info'),
                    ),
                  ],
                );
              } else {
                return Column(
                  spacing: 12,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Room'),
                        TextField(controller: roomNameTEC, readOnly: _loading),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Stream title'),
                        TextField(
                          controller: streamNameTEC,
                          readOnly: _loading,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nickname'),
                        TextField(controller: nicknameTEC, readOnly: _loading),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _loading ? null : handleRtmpLink,
                      child:
                          _loading
                              ? CircularProgressIndicator()
                              : Text('Get RTMP link'),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
