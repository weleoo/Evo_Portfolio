import 'dart:async';
import 'package:flutter/material.dart';

import '../constants.dart';

/// عارض منتجات متحرك انسيابي (Vertical Product Ticker / Showcase)
/// يحل محل كلمة EVO STAR الثابتة في الهيدر، وتنزلق فيه أسماء كواشف وأجهزة EVO بسلاسة وتتغير دورياً
class ProductTicker extends StatefulWidget {
  final void Function(String productTitle) onSelect;

  const ProductTicker({super.key, required this.onSelect});

  @override
  State<ProductTicker> createState() => _ProductTickerState();
}

class _ProductTickerState extends State<ProductTicker> {
  static const List<({String name, String badge, bool is3D, Color color})> _products = [
    (name: 'EVO STAR', badge: '3D DEVICE', is3D: true, color: Color(0xFF0055D0)),
    (name: 'EVO PLUS', badge: '3D DEVICE', is3D: true, color: Color(0xFFCF1F2A)),
    (name: 'CTNI TEST', badge: 'RAPID KIT', is3D: true, color: Color(0xFF5B67C9)),
    (name: 'H. Pylori Ag', badge: '3D KIT', is3D: true, color: Color(0xFF00897B)),
    (name: 'HCG TEST', badge: 'RAPID KIT', is3D: true, color: Color(0xFF8E24AA)),
    (name: 'HBs Ag TEST', badge: 'RAPID KIT', is3D: true, color: Color(0xFF3949AB)),
    (name: 'FOB TEST', badge: 'RAPID KIT', is3D: true, color: Color(0xFF00ACC1)),
    (name: 'HIV TEST', badge: 'RAPID KIT', is3D: true, color: Color(0xFFD81B60)),
    (name: 'Multi DRUGS', badge: 'RAPID KIT', is3D: true, color: Color(0xFF5E35B1)),
    (name: 'HAV IgG/IgM', badge: 'RAPID KIT', is3D: true, color: Color(0xFF43A047)),
    (name: 'H. Pylori Ab', badge: 'RAPID KIT', is3D: true, color: Color(0xFFFB8C00)),
    (name: 'HCV TEST', badge: 'RAPID KIT', is3D: true, color: Color(0xFFE53935)),
  ];

  int _currentIndex = 0;
  Timer? _timer;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    // تغيير المنتج دورياً كل 3 ثوانٍ
    _timer = Timer.periodic(const Duration(milliseconds: 3200), (_) {
      if (mounted && !_isHovered) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _products.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = _products[_currentIndex];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onSelect(item.name.contains('H. Pylori Ag') ? 'H. Pylori Ag TEST' : item.name),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white : Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: _isHovered ? kBlue : kBlue.withValues(alpha: 0.22),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: kBlue.withValues(alpha: _isHovered ? 0.16 : 0.06),
                blurRadius: _isHovered ? 12 : 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // نقطة تنبيه حية وامضة بلون المنتج
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.color,
                  boxShadow: [
                    BoxShadow(
                      color: item.color.withValues(alpha: 0.6),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // منطقة النص المنزلق رأسياً (ينزل تحت ويختفي ويطلع المنتج التالي)
              ClipRect(
                child: SizedBox(
                  height: 30,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 550),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    layoutBuilder: (currentChild, previousChildren) {
                      return Stack(
                        alignment: Alignment.centerLeft,
                        children: <Widget>[
                          ...previousChildren,
                          ?currentChild,
                        ],
                      );
                    },
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      // التحقق إذا كان هذا هو العنصر القادم أم الراحل
                      final isCurrent = (child.key as ValueKey<int>?)?.value == _currentIndex;

                      // العنصر الراحل ينزل للأسفل ويختفي (Down & Out)
                      // العنصر القادم يدخل من الأعلى إلى المنتصف (From Top to Center)
                      final offsetTween = isCurrent
                          ? Tween<Offset>(begin: const Offset(0.0, -1.1), end: Offset.zero)
                          : Tween<Offset>(begin: const Offset(0.0, 1.1), end: Offset.zero);

                      return SlideTransition(
                        position: offsetTween.animate(animation),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Row(
                      key: ValueKey<int>(_currentIndex),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            color: item.color,
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: item.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.badge,
                            style: TextStyle(
                              color: item.color,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11,
                color: _isHovered ? kBlue : Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
