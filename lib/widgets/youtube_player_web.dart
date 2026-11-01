// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';

void registerYouTubeIframe(String viewType, String youtubeId) {
  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final iframe = html.IFrameElement()
      ..src =
          'https://www.youtube.com/embed/$youtubeId?autoplay=1&rel=0&modestbranding=1&enablejsapi=1'
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.borderRadius = '16px'
      ..allow =
          'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share'
      ..allowFullscreen = true;
    return iframe;
  });
}

void openUrlInNewTab(String url) {
  html.window.open(url, '_blank');
}

Widget buildPlatformVideoView(String viewType, String title) {
  return HtmlElementView(viewType: viewType);
}
