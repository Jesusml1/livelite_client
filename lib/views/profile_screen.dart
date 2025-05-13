import 'package:flutter/material.dart';
import 'package:livelite_client/views/create_tournament_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: FilledButton(
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
      ),
    );
  }
}
