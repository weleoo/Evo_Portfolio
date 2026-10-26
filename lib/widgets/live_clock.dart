import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../constants.dart';

/// ساعة حائط تفاعلية حية (Live Wall Clock) لعلامة EVO MED
/// تتصل بالتوقيت الحقيقي للجهاز (DateTime.now()) وتتحرك عقاربها بسلاسة تامة.
class LiveEvoWallClock extends StatefulWidget {
  final double size;
  const LiveEvoWallClock({super.key, this.size = 72});

  @override
  State<LiveEvoWallClock> createState() => _LiveEvoWallClockState();
}

class _LiveEvoWallClockState extends State<LiveEvoWallClock> with SingleTickerProviderStateMixin {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    // تحديث كل 50 ملي ثانية لعقرب ثواني انسيابي كالساعات السويسرية الفاخرة
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (mounted) {
        setState(() => _now = DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final h = _now.hour % 12 == 0 ? 12 : _now.hour % 12;
    final m = _now.minute.toString().padLeft(2, '0');
    final s = _now.second.toString().padLeft(2, '0');
    final ampm = _now.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m:$s $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '🕒 EVO MED Live Clock: $_formattedTime (وقت حقيقي)',
      textStyle: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: kNavy.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 10,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _ClockPainter(time: _now),
        ),
      ),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final DateTime time;
  _ClockPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 0. طبقة أساس بيضاء معتمة 100% تمنع أي عناصر أو خطوط بالصورة الخلفية من الظهور من تحت الساعة
    canvas.drawCircle(center, radius, Paint()..color = Colors.white);

    // 1. الإطار الخارجي الفضي/المعدني (Metallic Bezel)
    final bezelPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFE8EAEF),
          const Color(0xFFC7CBD3),
          const Color(0xFF9AA0AA),
          const Color(0xFFFFFFFF),
          const Color(0xFFB5BAC3),
        ],
        stops: const [0.82, 0.88, 0.93, 0.97, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bezelPaint);

    // 2. ميناء الساعة الداخلي (Dial Face)
    final dialRadius = radius * 0.83;
    final dialPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFFFFF),
          const Color(0xFFF7F8FA),
          const Color(0xFFE8ECF2),
        ],
        stops: const [0.0, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: dialRadius));
    canvas.drawCircle(center, dialRadius, dialPaint);

    // حماية قاطعة: قص الرسم داخل حدود الميناء لمنع أي خروج خارج إطار الساعة
    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: center, radius: dialRadius - 0.5)));

    // 3. علامات الساعات والدقائق (Tick marks)
    final tickPaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 60; i++) {
      final angle = i * 2 * pi / 60 - pi / 2;
      final isHour = i % 5 == 0;
      final len = isHour ? dialRadius * 0.16 : dialRadius * 0.08;
      final strokeW = isHour ? size.width * 0.032 : size.width * 0.012;

      tickPaint.strokeWidth = strokeW;
      tickPaint.color = isHour ? const Color(0xFF1E2D4A) : const Color(0xFF8A95A5);

      final p1 = Offset(
        center.dx + (dialRadius - 2) * cos(angle),
        center.dy + (dialRadius - 2) * sin(angle),
      );
      final p2 = Offset(
        center.dx + (dialRadius - 2 - len) * cos(angle),
        center.dy + (dialRadius - 2 - len) * sin(angle),
      );
      canvas.drawLine(p1, p2, tickPaint);
    }

    // 4. شعار EVO MED في مركز الميناء العلوي
    _drawEvoLogo(canvas, center, dialRadius);

    canvas.restore();

    // 5. حساب زوايا العقارب الحقيقية
    final millis = time.second + (time.millisecond / 1000.0);
    final secondAngle = (millis * 2 * pi / 60) - pi / 2;
    final minuteAngle = ((time.minute + millis / 60.0) * 2 * pi / 60) - pi / 2;
    final hourAngle = (((time.hour % 12) + time.minute / 60.0 + millis / 3600.0) * 2 * pi / 12) - pi / 2;

    // 6. عقرب الساعات (Hour Hand)
    final hourPaint = Paint()
      ..color = const Color(0xFF182236)
      ..strokeWidth = size.width * 0.055
      ..strokeCap = StrokeCap.round;
    final hourLen = dialRadius * 0.52;
    final hourOffset = dialRadius * 0.12;
    canvas.drawLine(
      Offset(center.dx - hourOffset * cos(hourAngle), center.dy - hourOffset * sin(hourAngle)),
      Offset(center.dx + hourLen * cos(hourAngle), center.dy + hourLen * sin(hourAngle)),
      hourPaint,
    );

    // 7. عقرب الدقائق (Minute Hand)
    final minutePaint = Paint()
      ..color = const Color(0xFF182236)
      ..strokeWidth = size.width * 0.038
      ..strokeCap = StrokeCap.round;
    final minuteLen = dialRadius * 0.74;
    final minOffset = dialRadius * 0.15;
    canvas.drawLine(
      Offset(center.dx - minOffset * cos(minuteAngle), center.dy - minOffset * sin(minuteAngle)),
      Offset(center.dx + minuteLen * cos(minuteAngle), center.dy + minuteLen * sin(minuteAngle)),
      minutePaint,
    );

    // 8. عقرب الثواني الانسيابي بأزرق EVO المميز (Second Hand)
    final secondPaint = Paint()
      ..color = const Color(0xFF0055D0) // أزرق البراند
      ..strokeWidth = size.width * 0.02
      ..strokeCap = StrokeCap.round;
    final secondLen = dialRadius * 0.85;
    final secTail = dialRadius * 0.22;
    canvas.drawLine(
      Offset(center.dx - secTail * cos(secondAngle), center.dy - secTail * sin(secondAngle)),
      Offset(center.dx + secondLen * cos(secondAngle), center.dy + secondLen * sin(secondAngle)),
      secondPaint,
    );

    // دائرة توازن ذيل عقرب الثواني
    final tailCirclePaint = Paint()..color = const Color(0xFF0055D0);
    canvas.drawCircle(
      Offset(center.dx - secTail * 0.55 * cos(secondAngle), center.dy - secTail * 0.55 * sin(secondAngle)),
      size.width * 0.03,
      tailCirclePaint,
    );

    // 9. مسمار المركز الفضي (Center Pin Cap)
    final pinPaint = Paint()..color = const Color(0xFFD6DBE4);
    canvas.drawCircle(center, size.width * 0.045, pinPaint);
    final pinCore = Paint()..color = const Color(0xFF0055D0);
    canvas.drawCircle(center, size.width * 0.02, pinCore);
  }

  void _drawEvoLogo(Canvas canvas, Offset center, double dialRadius) {
    // نسبة التكبير المتناسبة ميكرومترياً مع نصف قطر الميناء (الأساس dialRadius = 30)
    final scale = (dialRadius / 30.0).clamp(0.4, 2.5);

    // 1. أيقونة الجزيء الطبي الدقيق أعلى الكلمة
    final dotPaint = Paint()..color = const Color(0xFF0055D0);
    final dotY = center.dy - (dialRadius * 0.58);
    final dotR = (1.5 * scale).clamp(0.8, 2.2);
    canvas.drawCircle(Offset(center.dx, dotY), dotR, dotPaint);
    canvas.drawCircle(Offset(center.dx - 3.2 * scale, dotY - 2.2 * scale), dotR * 0.72, dotPaint);
    canvas.drawCircle(Offset(center.dx + 3.2 * scale, dotY - 1.8 * scale), dotR * 0.72, dotPaint);

    // 2. خط الشعار المصغر المتناسب تماماً
    final evoSize = (8.0 * scale).clamp(4.0, 14.0);
    final medSize = (4.2 * scale).clamp(2.4, 7.5);

    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'EVO\n',
            style: TextStyle(
              color: const Color(0xFF0055D0),
              fontSize: evoSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8 * scale,
              height: 0.88,
            ),
          ),
          TextSpan(
            text: 'EVO MED',
            style: TextStyle(
              color: const Color(0xFF1E2D4A),
              fontSize: medSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4 * scale,
              height: 1.0,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // وضع النص أعلى المركز بمسافة آمنة دون ملامسة مسمار المركز أو الإطار الخارجي
    final textY = center.dy - (dialRadius * 0.46);
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, textY),
    );
  }

  @override
  bool shouldRepaint(covariant _ClockPainter oldDelegate) => true;
}
