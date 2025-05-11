import 'package:flutter/material.dart';
import 'package:livelite_client/modules/streaming/backend/streaming.dart';
import 'package:livelite_client/modules/streaming/models/room.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Room>> _roomsFuture = listRooms();

  @override
  void initState() {
    super.initState();
    _roomsFuture = listRooms();
  }

  void _refreshFuture() {
    setState(() {
      _roomsFuture = listRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          TextButton(onPressed: _refreshFuture, child: Icon(Icons.refresh)),
        ],
      ),
      body: Expanded(
        child: FutureBuilder(
          future: _roomsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final rooms = snapshot.data;
              if (rooms!.isEmpty) {
                return Center(child: Text('There are no rooms'));
              }
              return ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  return ListTile(
                    title: Text(room.name),
                    trailing: ElevatedButton(
                      child: Text('Join'),
                      onPressed: () {},
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Placeholder();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
