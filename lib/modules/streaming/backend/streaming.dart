import 'dart:convert';

import 'package:livelite_client/config/config.dart';
import 'package:livelite_client/modules/streaming/models/room.dart';
import 'package:http/http.dart' as http;

Future<List<Room>> listRooms() async {
  try {
    final request = await http.get(Uri.parse('${Config.apiUrl}/room'));
    if (request.statusCode == 200) {
      final body = jsonDecode(request.body);
      if (body['rooms'] == null) {
        return [];
      }
      final data = body['rooms'] as List;
      final rooms = data.map((e) => Room.fromJson(e)).toList();
      return rooms;
    }
    return [];
  } catch (e) {
    print(e);
    return [];
  }
}

Future<String?> generateTokenToJoin({
  required String roomName,
  required String nickname,
}) async {
  try {
    final request = await http.get(
      Uri.parse('${Config.apiUrl}/join/$roomName/$nickname'),
    );
    if (request.statusCode == 200) {
      final token = jsonDecode(request.body);
      return token;
    }
    return null;
  } catch (e) {
    print(e);
    return null;
  }
}
