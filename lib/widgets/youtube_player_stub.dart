import 'package:flutter/material.dart';

void registerYouTubeIframe(String viewType, String youtubeId) {}

void openUrlInNewTab(String url) {}

Widget buildPlatformVideoView(String viewType, String title) {
  return Center(
    child: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
  );
}
