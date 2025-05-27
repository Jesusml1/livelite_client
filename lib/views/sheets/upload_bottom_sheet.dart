import 'package:flutter/material.dart';
import 'package:livelite_client/views/pre_join_screen_capture.dart';
import 'package:livelite_client/views/rtmp_screen.dart';

class UploadBottomSheet extends StatelessWidget {
  const UploadBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Text(
                'Broadcast from',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Icon(Icons.close),
            ),
          ),
          Positioned(
            top: 70,
            left: 30,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.cell_tower, color: Colors.red.shade500),
                    title: const Text('Camera'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PopScope(
                              onPopInvokedWithResult: (didPop, _) {},
                              child: const Placeholder(),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.screenshot_rounded, color: Colors.green.shade500),
                    title: const Text('Screen Capture'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PopScope(
                              onPopInvokedWithResult: (didPop, _) {},
                              child: PreJoinScreenCapture(),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.center_focus_strong, color: Colors.blue.shade500),
                    title: const Text('RTMP (obs, streamlabs, etc)'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return RtmpScreen();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
