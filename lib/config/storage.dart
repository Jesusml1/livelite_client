import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:livelite_client/modules/streaming/models/rtmp_info.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _userRtmpInfo = 'user_rtmp_info';

  Future<RtmpInfo?> readRtmpInfo() async {
    String? value = await _storage.read(key: _userRtmpInfo);
    if (value != null) {
      final data = jsonDecode(value) as Map<String, Object?>;
      print('reading from storage...');
      print(data);
      return RtmpInfo.fromJson(data);
    }
    return null;
  }

  Future<bool> writeRtmpInfo(RtmpInfo rtmpInfo) async {
    try {
      final jsonValue = jsonEncode(rtmpInfo.toJson());
      print('writing to storage...');
      await _storage.write(key: _userRtmpInfo, value: jsonValue);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeRtmpInfo() async {
    try {
      await _storage.delete(key: _userRtmpInfo);
      return true;
    } catch (e) {
      return false;
    }
  }
}
