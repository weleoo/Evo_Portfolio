import 'package:flutter/widgets.dart';

import 'youtube_player_stub.dart'
    if (dart.library.html) 'youtube_player_web.dart' as platform;

void registerYouTubeIframe(String viewType, String youtubeId) {
  platform.registerYouTubeIframe(viewType, youtubeId);
}

void openUrlInNewTab(String url) {
  platform.openUrlInNewTab(url);
}

Widget buildPlatformVideoView(String viewType, String title) {
  return platform.buildPlatformVideoView(viewType, title);
}
