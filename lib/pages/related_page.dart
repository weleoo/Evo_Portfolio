import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../constants.dart';
import '../models/video_item.dart';
import '../widgets/evo_box_3d.dart';
import '../widgets/youtube_dialog.dart';

/// صفحة Related to Product: عارض 3D للمنتج المختار + شريط لاختيار أي منتج تاني
class RelatedPage extends StatelessWidget {
  final String title;
  final void Function(String) onSelect;
  const RelatedPage({super.key, required this.title, required this.onSelect});

  /// بيدور على المنتج (جهاز أو تيست) بالاسم
  ({String name, String subtitle, String model}) _find() {
    for (final d in devices) {
      if (d.name == title) return (name: d.name, subtitle: d.subtitle, model: d.model);
    }
    for (final p in products) {
      if (p.name == title) return (name: p.name, subtitle: p.spec, model: p.model);
    }
    final d = devices.last;
    return (name: d.name, subtitle: d.subtitle, model: d.model);
  }

  @override
  Widget build(BuildContext context) {
    final item = _find();
    final mobile = MediaQuery.of(context).size.width < 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.name,
            style: TextStyle(color: kNavy, fontSize: mobile ? 34 : 46, fontWeight: FontWeight.w800)),
        Text(item.subtitle, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
        const SizedBox(height: 16),

        // ── عارض الـ 3D ──
        Container(
          height: mobile ? 420 : 580,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFEAF2FF), Color(0xFFD3E5FF)],
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: box3dIds.containsKey(item.name)
              ? EvoBox3D(
                  key: ValueKey(item.name),
                  productId: box3dIds[item.name]!,
                )
              : ModelViewer(
                  key: ValueKey(item.model), // بيعمل ريلود لما المنتج يتغير
                  src: item.model,
                  alt: '3D model of ${item.name}',
                  autoRotate: true,
                  cameraControls: true,
                  disableZoom: false,
                  backgroundColor: const Color(0x00FFFFFF),
                ),
        ),
        const SizedBox(height: 6),
        Text(
            item.name == 'EVO PLUS'
                ? 'محاكاة تفاعلية ثلاثية الأبعاد: انقر على المجسم أو اتبع خطوات المحاكاة بالأسفل • اسحب للتدوير'
                : box3dIds.containsKey(item.name)
                    ? 'دوس على استيكر QC عشان تفتح العلبة • اسحب للتدوير'
                    : 'اسحب للتدوير • اسكرول للزووم',
            style: const TextStyle(fontSize: 11, color: Colors.black45)),

        if (item.name == 'EVO PLUS') ...[
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              final video = kShowcaseVideos.firstWhere((v) => v.deviceName == 'EVO PLUS');
              showYouTubeVideoDialog(context, video);
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: mobile ? 14 : 18, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF101726),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFFF0033).withValues(alpha: 0.50),
                  width: 1.2,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_circle_fill_rounded, color: Color(0xFFFF0033), size: 22),
                  SizedBox(width: 8),
                  Text(
                    'فيديو جهاز EVO PLUS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.open_in_new_rounded, color: Colors.white54, size: 13),
                ],
              ),
            ),
          ),
        ],

        const SizedBox(height: 22),

        // ── اختيار منتج تاني ──
        const Text('All Products',
            style: TextStyle(color: kNavy, fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final d in devices) _chip(d.name, d.name == item.name),
            for (final p in products) _chip(p.name, p.name == item.name),
          ],
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _chip(String label, bool selected) => InkWell(
        onTap: () => onSelect(label),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            gradient: selected ? kBlueGradient : null,
            color: selected ? null : kGrey,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.black87,
              )),
        ),
      );
}
