import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String apiUrl = dotenv.get(
    'API_URL',
    fallback: "http://localhost:9000",
  );

  static String livekitUrl = dotenv.get(
    'LIVEKIT_URL',
    fallback: "wss://livekit.io",
  );
}
