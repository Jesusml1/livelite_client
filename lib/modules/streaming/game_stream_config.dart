import 'package:livekit_client/livekit_client.dart';

class GameStreamConfig {
  static const VideoParameters gaming1080p = VideoParameters(
    dimensions: VideoDimensionsPresets.h1080_169,
    encoding: VideoEncoding(maxFramerate: 30, maxBitrate: 8000000),
  );

  static const VideoParameters gaming720p = VideoParameters(
    dimensions: VideoDimensionsPresets.h720_169,
    encoding: VideoEncoding(maxFramerate: 25, maxBitrate: 4000000),
  );

  static const VideoParameters gamingMobile = VideoParameters(
    dimensions: VideoDimensionsPresets.h540_169,
    encoding: VideoEncoding(maxBitrate: 2500000, maxFramerate: 25),
  );
}
