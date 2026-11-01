import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/video_item.dart';
import 'youtube_dialog.dart';

/// قسم مكتبة الفيديوهات التفاعلي (Video Showcase)
/// متجاوب بالكامل مع اللاب توب، التابلت، والموبايل
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
        horizontal: isMobile ? 14 : 28,
        vertical: isMobile ? 24 : 36,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(isMobile ? 20 : 28),
        border: Border.all(color: const Color(0xFFE5EBF5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: kBlue.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── رأس القسم (Section Header) ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: isMobile ? 42 : 52,
                height: isMobile ? 42 : 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF0033), Color(0xFFCC0000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF0033).withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: kBlue.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'معرض الفيديو • VIDEO SHOWCASE',
                        style: TextStyle(
                          color: kBlue,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'مكتبة الفيديوهات والشروحات العملية',
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 26,
                        fontWeight: FontWeight.w900,
                        color: kNavy,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Text(
            'شاهد استعراض أجهزة EVO MED الطبية بالفيديو التفاعلي وطريقة إجراء الاختبارات المعملية بدقة واحترافية.',
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: Colors.black54,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          // ── شريط فلاتر التصنيف (Category Filters) ──
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _filterChip('All', 'جميع الفيديوهات (All)'),
              _filterChip('Devices', 'شروحات الأجهزة (Devices)'),
              _filterChip('General', 'فيديوهات عامة ومعملية (General)'),
            ],
          ),

          const SizedBox(height: 24),

          // ── شبكة كروت الفيديوهات (Responsive Video Grid) ──
          LayoutBuilder(
            builder: (context, constraints) {
              final totalW = constraints.maxWidth;
              final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 2);
              final spacing = isMobile ? 16.0 : 20.0;
              final cardW = (totalW - (spacing * (crossAxisCount - 1))) / crossAxisCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
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
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: selected ? kBlueGradient : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? Colors.transparent : const Color(0xFFD6DFEC),
            width: 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: kBlue.withValues(alpha: 0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
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
          duration: const Duration(milliseconds: 220),
          transform: Matrix4.translationValues(0.0, _hovered ? -5.0 : 0.0, 0.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hovered ? kBlue : const Color(0xFFE2E8F2),
              width: _hovered ? 1.8 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? kBlue.withValues(alpha: 0.16)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: _hovered ? 20 : 12,
                offset: Offset(0, _hovered ? 8 : 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── الصورة المصغرة (Thumbnail with Overlay) ──
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      video.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        color: const Color(0xFF1E2D4A),
                        child: const Center(
                          child: Icon(Icons.videocam_rounded, color: Colors.white30, size: 48),
                        ),
                      ),
                    ),

                    // تدرج ظل سينمائي يحمي النصوص والأيقونات
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.35),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.65),
                            ],
                            stops: const [0.0, 0.45, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // شارة التاج (EVO Device أو General)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDevice ? const Color(0xFFCF1F2A) : kBlue,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 2)),
                          ],
                        ),
                        child: Text(
                          video.tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),

                    // شارة يوتيوب / شورتس
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              video.isShort ? Icons.bolt_rounded : Icons.play_arrow_rounded,
                              color: const Color(0xFFFF0033),
                              size: 14,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              video.isShort ? 'Shorts' : 'Video',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // زر التشغيل المركزي الكبير المتفاعل (Animated Play Button)
                    Center(
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        scale: _hovered ? 1.15 : 1.0,
                        child: Container(
                          width: widget.mobile ? 48 : 56,
                          height: widget.mobile ? 48 : 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF0033),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF0033).withValues(alpha: 0.50),
                                blurRadius: 18,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),

                    // شارة المدة بالأسفل
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          video.duration,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── تفاصيل الفيديو وأزرار التفاعل ──
              Padding(
                padding: EdgeInsets.all(widget.mobile ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: widget.mobile ? 14.5 : 16,
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
                        fontSize: 11,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      video.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: widget.mobile ? 11.5 : 12.5,
                        color: const Color(0xFF4A5568),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // شريط الأزرار التفاعلية
                    Row(
                      children: [
                        // زر تشغيل الفيديو
                        Expanded(
                          child: InkWell(
                            onTap: widget.onTap,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              decoration: BoxDecoration(
                                gradient: kBlueGradient,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: kBlue.withValues(alpha: 0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.play_circle_outline_rounded,
                                      color: Colors.white, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    'شاهد الفيديو الآن',
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

                        // زر فحص الـ 3D للجهاز إذا كان مرتبط بجهاز
                        if (widget.onInspectDevice != null) ...[
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: widget.onInspectDevice,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                              decoration: BoxDecoration(
                                color: kGrey,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFD3DDEB)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.view_in_ar_rounded, color: kNavy, size: 15),
                                  SizedBox(width: 4),
                                  Text(
                                    'عرض 3D',
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
