import 'package:flutter/material.dart';

class RtmpScreen extends StatelessWidget {
  const RtmpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RTMP info')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 12,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Room'), TextField()],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Stream title'), TextField()],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Nickname'), TextField()],
              ),
              ElevatedButton(onPressed: () {}, child: Text('Get RTMP link')),
            ],
          ),
        ),
      ),
    );
  }
}
