import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/video_item.dart';
import 'youtube_dialog.dart';

/// قسم مكتبة الفيديوهات بتصميم عصري وبسيط ومختصر
class VideoShowcaseSection extends StatefulWidget {
  final void Function(String)? onSelectDevice;
  const VideoShowcaseSection({super.key, this.onSelectDevice});

  @override
  State<VideoShowcaseSection> createState() => _VideoShowcaseSectionState();
}

class _VideoShowcaseSectionState extends State<VideoShowcaseSection> {
  String _selectedCategory = 'All';

  List<VideoItem> get _filteredVideos {
    if (_selectedCategory == 'All') return kShowcaseVideos;
    if (_selectedCategory == 'Devices') {
      return kShowcaseVideos.where((v) => v.deviceName != null).toList();
    }
    return kShowcaseVideos.where((v) => v.deviceName == null).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final isMobile = screenW < 750;
    final isTablet = screenW >= 750 && screenW < 1100;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 14 : 24,
        vertical: isMobile ? 18 : 26,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(isMobile ? 18 : 24),
        border: Border.all(color: const Color(0xFFE5EBF5), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── رأس القسم مختصر وسريع ──
          Row(
            children: [
              Container(
                width: isMobile ? 38 : 44,
                height: isMobile ? 38 : 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF0033),
                  borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF0033).withValues(alpha: 0.30),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Videos',
                    style: TextStyle(
                      fontSize: isMobile ? 22 : 26,
                      fontWeight: FontWeight.w900,
                      color: kNavy,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const Text(
                    'فيديوهات أجهزة ومنتجات EVO MED',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (!isMobile)
                Wrap(
                  spacing: 6,
                  children: [
                    _filterChip('All', 'الكل'),
                    _filterChip('Devices', 'الأجهزة'),
                    _filterChip('General', 'عام'),
                  ],
                ),
            ],
          ),

          if (isMobile) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              children: [
                _filterChip('All', 'الكل'),
                _filterChip('Devices', 'الأجهزة'),
                _filterChip('General', 'عام'),
              ],
            ),
          ],

          const SizedBox(height: 18),

          // ── شبكة كروت الفيديوهات ──
          LayoutBuilder(
            builder: (context, constraints) {
              final totalW = constraints.maxWidth;
              // عرض كارت متناسق فخم ومريح للعين على كل الشاشات بدون تمدد عملاق
              final double cardW;
              if (isMobile) {
                cardW = totalW;
              } else if (isTablet) {
                cardW = (totalW - 14.0) / 2;
              } else {
                // شاشات اللاب توب والديسكتوب الكبيرة
                final cols = totalW > 1150 ? 3 : 2;
                const spacing = 18.0;
                final idealW = (totalW - (spacing * (cols - 1))) / cols;
                cardW = idealW.clamp(320.0, 460.0);
              }

              return Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: _filteredVideos.map((video) {
                  return SizedBox(
                    width: cardW,
                    child: _VideoCard(
                      video: video,
                      mobile: isMobile,
                      onTap: () => showYouTubeVideoDialog(context, video),
                      onInspectDevice: video.deviceName != null && widget.onSelectDevice != null
                          ? () => widget.onSelectDevice!(video.deviceName!)
                          : null,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String id, String label) {
    final selected = _selectedCategory == id;
    return InkWell(
      onTap: () => setState(() => _selectedCategory = id),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          gradient: selected ? kBlueGradient : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.transparent : const Color(0xFFD6DFEC),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? Colors.white : const Color(0xFF334460),
          ),
        ),
      ),
    );
  }
}

class _VideoCard extends StatefulWidget {
  final VideoItem video;
  final bool mobile;
  final VoidCallback onTap;
  final VoidCallback? onInspectDevice;

  const _VideoCard({
    required this.video,
    required this.mobile,
    required this.onTap,
    this.onInspectDevice,
  });

  @override
  State<_VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<_VideoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final video = widget.video;
    final isDevice = video.deviceName != null;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0.0, _hovered ? -4.0 : 0.0, 0.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? kBlue : const Color(0xFFE2E8F2),
              width: _hovered ? 1.6 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? kBlue.withValues(alpha: 0.14)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: _hovered ? 16 : 8,
                offset: Offset(0, _hovered ? 6 : 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── الصورة المصغرة ──
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      video.thumbnailUrl,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      isAntiAlias: true,
                      errorBuilder: (ctx, err, stack) => Image.network(
                        video.fallbackThumbnailUrl,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        isAntiAlias: true,
                        errorBuilder: (ctx2, err2, stack2) => Container(
                          color: const Color(0xFF1E2D4A),
                          child: const Center(
                            child: Icon(Icons.videocam_rounded, color: Colors.white30, size: 40),
                          ),
                        ),
                      ),
                    ),

                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.25),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.55),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // شارة التاج
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDevice ? const Color(0xFFCF1F2A) : kBlue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          video.tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    // شارة المدة
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          video.duration,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // زر التشغيل المركزي
                    Center(
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 180),
                        scale: _hovered ? 1.12 : 1.0,
                        child: Container(
                          width: widget.mobile ? 44 : 50,
                          height: widget.mobile ? 44 : 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF0033),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF0033).withValues(alpha: 0.45),
                                blurRadius: 14,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── تفاصيل وأزرار مختصرة ──
              Padding(
                padding: EdgeInsets.all(widget.mobile ? 11 : 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: widget.mobile ? 14 : 15,
                        fontWeight: FontWeight.w800,
                        color: kNavy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      video.englishTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: widget.onTap,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 7.5),
                              decoration: BoxDecoration(
                                gradient: kBlueGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    'تشغيل',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (widget.onInspectDevice != null) ...[
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: widget.onInspectDevice,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7.5),
                              decoration: BoxDecoration(
                                color: kGrey,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFD3DDEB)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.view_in_ar_rounded, color: kNavy, size: 14),
                                  SizedBox(width: 3),
                                  Text(
                                    '3D',
                                    style: TextStyle(
                                      color: kNavy,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
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
