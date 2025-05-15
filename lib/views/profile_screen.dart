import 'package:flutter/material.dart';
import 'package:livelite_client/views/create_tournament_screen.dart';
import 'package:livelite_client/views/test_stream_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateTournamentScreen(),
                  ),
                );
              },
              child: Text('Crear torneo'),
            ),
        
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StreamingPage()),
                );
              },
              child: Text('test stream'),
            ),
          ],
        ),
      ),
    );
  }
}
