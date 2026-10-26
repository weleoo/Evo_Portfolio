// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';

/// بيعرض مشهد العلبة 3D (assets/3d/box.html) جوه Flutter Web.
/// [productId] لازم يكون موجود في PRODUCTS جوه box.html (مثلا hpylori_ag).
class EvoBox3D extends StatefulWidget {
  final String productId;
  const EvoBox3D({super.key, required this.productId});

  @override
  State<EvoBox3D> createState() => _EvoBox3DState();
}

class _EvoBox3DState extends State<EvoBox3D> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'evo-box-3d-${widget.productId}-${identityHashCode(this)}';
    final htmlFile = widget.productId == 'evo_plus'
        ? 'evo_plus.html'
        : widget.productId == 'ctni'
            ? 'ctni.html'
            : 'box.html';
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int _) {
      return html.IFrameElement()
        // مسار الـ asset على الويب: assets/ + اسم الـ asset
        ..src = 'assets/assets/3d/$htmlFile?p=${widget.productId}'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allowFullscreen = true;
    });
  }

  @override
  Widget build(BuildContext context) => HtmlElementView(viewType: _viewType);
}
