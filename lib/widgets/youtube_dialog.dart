import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/video_item.dart';
import 'youtube_player_platform.dart';

/// يعرض مشغل فيديو يوتيوب داخل نافذة منبثقة تفاعلية (Lightbox / Modal)
/// متجاوبة مع اللاب توب، التابلت، والموبايل بنسبة أبعاد مثالية للفيديوهات العادية والـ Shorts.
void showYouTubeVideoDialog(BuildContext context, VideoItem video) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.82),
    builder: (ctx) => _YouTubeModalContent(video: video),
  );
}

class _YouTubeModalContent extends StatefulWidget {
  final VideoItem video;
  const _YouTubeModalContent({required this.video});

  @override
  State<_YouTubeModalContent> createState() => _YouTubeModalContentState();
}

class _YouTubeModalContentState extends State<_YouTubeModalContent> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType =
        'youtube-player-${widget.video.youtubeId}-${DateTime.now().millisecondsSinceEpoch}-${identityHashCode(this)}';

    if (kIsWeb) {
      registerYouTubeIframe(_viewType, widget.video.youtubeId);
    }
  }

  void _openInYouTube() {
    openUrlInNewTab(widget.video.directUrl);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenW = media.size.width;
    final screenH = media.size.height;
    final isMobile = screenW < 700;
    final isTablet = screenW >= 700 && screenW < 1024;

    // حساب الأبعاد الذكية المتجاوبة حسب نوع الفيديو (Shorts 9:16 أو عادي 16:9)
    final double playerW;
    final double playerH;

    if (widget.video.isShort) {
      // فيديو رأسي (Shorts)
      final maxAvailableH = screenH * (isMobile ? 0.72 : 0.78);
      final calculatedW = maxAvailableH * (9.0 / 16.0);
      playerW = min(calculatedW, screenW * (isMobile ? 0.88 : 0.45));
      playerH = playerW * (16.0 / 9.0);
    } else {
      // فيديو أفقي سينمائي (16:9)
      final maxTargetW = isMobile
          ? screenW * 0.94
          : isTablet
              ? screenW * 0.84
              : min(880.0, screenW * 0.75);
      final calculatedH = maxTargetW * (9.0 / 16.0);
      final maxAvailableH = screenH * (isMobile ? 0.65 : 0.75);

      if (calculatedH > maxAvailableH) {
        playerH = maxAvailableH;
        playerW = playerH * (16.0 / 9.0);
      } else {
        playerW = maxTargetW;
        playerH = calculatedH;
      }
    }

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: playerW,
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 24,
            vertical: isMobile ? 16 : 28,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF101726),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: kBlue.withValues(alpha: 0.40), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.70),
                blurRadius: 36,
                spreadRadius: 6,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: kBlue.withValues(alpha: 0.25),
                blurRadius: 40,
                spreadRadius: 2,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── شريط رأس المشغل (Header) ──
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 18,
                  vertical: isMobile ? 10 : 12,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF162035),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF22314D), width: 1.0),
                  ),
                ),
                child: Row(
                  children: [
                    // أيقونة يوتيوب الحمراء الأنيقة
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF0033),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14),
                          SizedBox(width: 3),
                          Text(
                            'YouTube',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // عنوان الفيديو
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.video.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 12.5 : 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            widget.video.englishTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: isMobile ? 10 : 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // زر الفتح المباشر على يوتيوب
                    if (!isMobile) ...[
                      InkWell(
                        onTap: _openInYouTube,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.open_in_new_rounded, color: Colors.white70, size: 13),
                              SizedBox(width: 5),
                              Text(
                                'فتح في يوتيوب',
                                style: TextStyle(color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // زر الإغلاق الدائري البارز
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── شاشة عرض الفيديو (Video Viewport) ──
              SizedBox(
                width: playerW,
                height: playerH,
                child: buildPlatformVideoView(_viewType, widget.video.title),
              ),

              // ── شريط تفاصيل سفلية للموبايل فقط ──
              if (isMobile)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  color: const Color(0xFF162035),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.video.duration,
                        style: const TextStyle(color: Colors.white54, fontSize: 11),
                      ),
                      InkWell(
                        onTap: _openInYouTube,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'مشاهدة على تطبيق يوتيوب',
                              style: TextStyle(
                                color: kLightBlue,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.open_in_new_rounded, color: kLightBlue, size: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
