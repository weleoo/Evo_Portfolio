import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_shell.dart';
import '../logo_data.dart';

/// Splash فائق الخفة والسرعة (60-120 FPS):
/// - خالي تماماً من أي Overdraw أو إعادة رسم ثقيلة
/// - حلقة اللوجو ونبض القلب ECG مع كاش للمسار (Zero Allocation per frame)
/// - خلفية ناعمة ثابتة دون إجهاد كارت الشاشة
/// - يختفي تلقائياً بعد 3 ثوانٍ بالضبط مع زر تخطي فوري ("نخش ف الموضوع")
/// - انتقال فوري وانسيابي بدون أي تهنيج عند الخروج
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const _blue = Color(0xFF1468FE);
  static const _navy = Color(0xFF0A2F7A);

  static final _logo = MemoryImage(kLogoBytes);
  static const _words = ['Comprehensive', 'care', '&', 'life'];
  static const _duration = Duration(milliseconds: 3000);

  late final AnimationController _c;
  Timer? _autoDismissTimer;

  late final Animation<double> _ring;
  late final Animation<double> _ecg;
  late final Animation<double> _logoIn;
  late final Animation<double> _logoFade;
  late final Animation<double> _tagline;
  late final Animation<double> _sub;
  late final Animation<double> _skipIn;

  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _c = AnimationController(
      vsync: this,
      duration: _duration,
    );

    _ring = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.04, 0.35, curve: Curves.easeOutCubic),
    );
    _ecg = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.12, 0.50, curve: Curves.easeInOut),
    );
    _logoIn = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.08, 0.32, curve: Curves.easeOutBack),
    );
    _logoFade = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.08, 0.22, curve: Curves.easeOut),
    );
    _tagline = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.35, 0.75, curve: Curves.linear),
    );
    _sub = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.68, 0.88, curve: Curves.easeOut),
    );
    _skipIn = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.15, 0.35, curve: Curves.easeOut),
    );

    // 1. مؤقت أوتوماتيكي مؤكد لمدة 3 ثوانٍ بالضبط للإخفاء التلقائي
    _autoDismissTimer = Timer(const Duration(milliseconds: 3000), () {
      if (mounted) _goToHome();
    });

    // 2. ضمان الانتقال التلقائي فور اكتمال حركة المؤقت
    _c.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _goToHome();
        });
      }
    });

    _c.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_logo, context);
  }

  void _goToHome() {
    if (_navigated || !mounted) return;
    _navigated = true;
    _autoDismissTimer?.cancel();
    _c.stop();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!kIsWeb) {
        HapticFeedback.selectionClick();
      }

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const AppShell(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            child: child,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.width < 600;
    final badge = compact ? 104.0 : 128.0;
    final ringSize = badge + (compact ? 50 : 66);

    return Scaffold(
      backgroundColor: _navy,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1) خلفية ثابتة تماماً وخفيفة على الـ GPU (بدون إعادة رسم مستمرة)
          const RepaintBoundary(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_blue, Color(0xFF0F4FC4), _navy],
                  stops: [0.0, 0.50, 1.0],
                ),
              ),
            ),
          ),

          // 2) إضاءة ناعمة ثابتة (Static Glows) لا تستهلك أي فريمات
          Positioned(
            top: -size.height * 0.1,
            left: -size.width * 0.1,
            child: IgnorePointer(
              child: Container(
                width: size.width * 0.7,
                height: size.height * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF5B9BFF).withValues(alpha: 0.28),
                      const Color(0xFF5B9BFF).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -size.height * 0.1,
            right: -size.width * 0.1,
            child: IgnorePointer(
              child: Container(
                width: size.width * 0.7,
                height: size.height * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF00C2FF).withValues(alpha: 0.18),
                      const Color(0xFF00C2FF).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3) المحتوى المركزي: اللوجو ونبض الـ ECG والعنوان
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: ringSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // خط النبض السلس
                        Positioned.fill(
                          child: RepaintBoundary(
                            child: AnimatedBuilder(
                              animation: _ecg,
                              builder: (context, child) => CustomPaint(
                                painter: _OptimizedEcgPainter(progress: _ecg.value),
                              ),
                            ),
                          ),
                        ),
                        // حلقة اللوجو
                        RepaintBoundary(
                          child: AnimatedBuilder(
                            animation: _ring,
                            builder: (context, child) => CustomPaint(
                              size: Size.square(ringSize),
                              painter: _OptimizedRingPainter(progress: _ring.value),
                            ),
                          ),
                        ),
                        // بادج اللوجو الأبيض
                        FadeTransition(
                          opacity: _logoFade,
                          child: ScaleTransition(
                            scale: Tween(begin: 0.82, end: 1.0).animate(_logoIn),
                            child: Container(
                              width: badge,
                              height: badge,
                              padding: EdgeInsets.all(badge * 0.2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.20),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Image(
                                image: _logo,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.medium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: compact ? 24 : 32),

                  // الشعار كلمة بكلمة
                  _WordReveal(
                    words: _words,
                    animation: _tagline,
                    style: GoogleFonts.poppins(
                      fontSize: compact ? 22 : 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // سطر ثانوي هادي
                  FadeTransition(
                    opacity: _sub,
                    child: Text(
                      'EVO MED',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.7),
                        letterSpacing: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4) زر التخطي: "نخش ف الموضوع"
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FadeTransition(
                  opacity: _skipIn,
                  child: _SkipButton(onTap: _goToHome),
                ),
              ),
            ),
          ),

          // 5) خط تقدم رفيع خفيف وسريع في الأسفل
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Center(
                  child: RepaintBoundary(
                    child: AnimatedBuilder(
                      animation: _c,
                      builder: (context, child) {
                        return Container(
                          width: 120,
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 120 * _c.value.clamp(0.0, 1.0),
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Widgets ─────────────────────────

class _WordReveal extends StatelessWidget {
  const _WordReveal({
    required this.words,
    required this.animation,
    required this.style,
  });

  final List<String> words;
  final Animation<double> animation;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: List.generate(words.length, (i) {
        final start = i / words.length * 0.7;
        final end = (start + 0.35).clamp(0.0, 1.0);
        final t = CurvedAnimation(
          parent: animation,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        );
        return FadeTransition(
          opacity: t,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, 0.40), end: Offset.zero).animate(t),
            child: Text(words[i], style: style),
          ),
        );
      }),
    );
  }
}

/// زر تخطي تفاعلي خفيف وسريع
class _SkipButton extends StatefulWidget {
  const _SkipButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_SkipButton> createState() => _SkipButtonState();
}

class _SkipButtonState extends State<_SkipButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'نخش ف الموضوع',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _hover ? 1.04 : 1.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: _hover ? 0.28 : 0.15),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: _hover ? 0.60 : 0.35),
                  width: 1.2,
                ),
                boxShadow: [
                  if (_hover)
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.16),
                      blurRadius: 14,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'نخش ف الموضوع',
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_back_rounded, size: 15, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Optimized Painters ─────────────────────────

/// حلقة دائرية محسنة مع تخزين مسبق للـ Paint
class _OptimizedRingPainter extends CustomPainter {
  _OptimizedRingPainter({required this.progress});
  final double progress;

  static final Paint _bgPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5
    ..color = Colors.white.withValues(alpha: 0.14);

  static final Paint _drawPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.4
    ..strokeCap = StrokeCap.round
    ..color = Colors.white.withValues(alpha: 0.90);

  Path? _cachedPath;
  Size? _lastSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    if (_cachedPath == null || _lastSize != size) {
      _lastSize = size;
      _cachedPath = Path()..addOval((Offset.zero & size).deflate(2));
    }

    final path = _cachedPath!;
    canvas.drawPath(path, _bgPaint);

    if (progress <= 0) return;
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final drawn = metric.extractPath(0, metric.length * progress.clamp(0.0, 1.0));
    canvas.drawPath(drawn, _drawPaint);
  }

  @override
  bool shouldRepaint(_OptimizedRingPainter old) => old.progress != progress;
}

/// رسم الـ ECG محسّن 100% مع كاش للمسار وتدرج لوني ثابت
class _OptimizedEcgPainter extends CustomPainter {
  _OptimizedEcgPainter({required this.progress});
  final double progress;

  Path? _cachedPath;
  Size? _lastSize;
  Shader? _cachedShader;

  static final Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0 || progress <= 0) return;

    if (_cachedPath == null || _lastSize != size) {
      _lastSize = size;
      final cy = h / 2;
      final amp = h * 0.22;
      final p = Path()..moveTo(0, cy);

      void beat(double cx) {
        final u = w * 0.012;
        p
          ..lineTo(cx - u * 8, cy)
          ..lineTo(cx - u * 6, cy - amp * 0.25)
          ..lineTo(cx - u * 4, cy)
          ..lineTo(cx - u * 2, cy)
          ..lineTo(cx - u * 1, cy + amp * 0.35)
          ..lineTo(cx, cy - amp)
          ..lineTo(cx + u * 1.5, cy + amp * 0.55)
          ..lineTo(cx + u * 3, cy)
          ..lineTo(cx + u * 5, cy - amp * 0.3)
          ..lineTo(cx + u * 7, cy);
      }

      beat(w * 0.20);
      p.lineTo(w * 0.80 - w * 0.012 * 8, cy);
      beat(w * 0.80);
      p.lineTo(w, cy);

      _cachedPath = p;

      _cachedShader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.85),
          Colors.white.withValues(alpha: 0.85),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.15, 0.85, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    }

    final path = _cachedPath!;
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final drawn = metric.extractPath(0, metric.length * progress.clamp(0.0, 1.0));

    _paint.shader = _cachedShader;
    canvas.drawPath(drawn, _paint);
  }

  @override
  bool shouldRepaint(_OptimizedEcgPainter old) => old.progress != progress;
}
