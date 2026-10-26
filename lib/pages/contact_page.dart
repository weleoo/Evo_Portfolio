// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/common.dart';

void _launch(String url) {
  html.window.open(url, '_blank');
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final wide = width >= 1000;
    final mobile = width < 600;

    final info = BluePanel(
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 18 : 36,
        vertical: mobile ? 22 : 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Our Contact Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: mobile ? 21 : 25,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 18),
          _ContactRow(
            iconWidget: const Icon(Icons.facebook, color: kBlue, size: 24),
            title: 'Facebook',
            value: 'https://www.facebook.com/evomedegy/',
            onTap: () => _launch('https://www.facebook.com/evomedegy/'),
          ),
          _ContactRow(
            iconWidget: const Text(
              'in',
              style: TextStyle(
                color: kBlue,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
            title: 'LinkedIn',
            value: 'https://www.linkedin.com/company/evomedegy/',
            onTap: () => _launch('https://www.linkedin.com/company/evomedegy/'),
          ),
          const _ContactRow(
            iconWidget: Icon(Icons.phone_outlined, color: kBlue, size: 22),
            title: 'Phone',
            value: '01122228086 - 01155665681',
            customValueWidget: _PhoneValueWidget(),
          ),
          _ContactRow(
            iconWidget: const Icon(Icons.location_on_outlined, color: kBlue, size: 22),
            title: 'Address',
            value: '13 EL-Salhadar Tower, Roxy, Heliopolis, Cairo',
            onTap: () => _launch('https://maps.google.com/?q=13+EL-Salhadar+Tower+Roxy+Heliopolis+Cairo'),
          ),
          const _ContactRow(
            iconWidget: Icon(Icons.monitor_heart_outlined, color: kBlue, size: 22),
            title: 'Working Hours',
            value: 'Sat - Thu  9 AM - 5 PM\nFri  - Closed',
            isLast: true,
          ),
        ],
      ),
    );

    final side = Column(
      children: [
        _SideCard(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE7F1FC),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: EdgeInsets.fromLTRB(mobile ? 16 : 22, 18, mobile ? 12 : 14, 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Our COMPANY',
                        style: TextStyle(
                          color: kNavy,
                          fontSize: mobile ? 20 : 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'EVO MED L.L.C',
                        style: TextStyle(
                          color: Color(0xFF222222),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      InkWell(
                        onTap: () => _launch('tel:+20224505715'),
                        child: const Text(
                          '+20224505715',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2B303A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      InkWell(
                        onTap: () => _launch('https://www.evomed.com.eg'),
                        child: const Text(
                          'www.evomed.com.eg',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2B303A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      InkWell(
                        onTap: () => _launch('mailto:evomed6m@gmail.com'),
                        child: const Text(
                          'evomed6m@gmail.com',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2B303A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Factory No 224, Model A, Southern Region,\n6 Million Square Meters, 10th of Ramadan City, Egypt.',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: mobile ? 6 : 8),
                SizedBox(
                  width: mobile ? 100 : 145,
                  height: mobile ? 100 : 135,
                  child: Image.asset(
                    'assets/images/company.png',
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.white24,
                      child: const Center(
                        child: Icon(Icons.image_outlined, color: Colors.white70),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _SideCard(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 378 / 172,
                  child: Image.asset(
                    'assets/images/certified_quality.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                Positioned(
                  top: mobile ? 14 : 20,
                  left: mobile ? 16 : 22,
                  child: Text(
                    'Certified Quality',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: mobile ? 19 : 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    if (wide) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 11, child: info),
            const SizedBox(width: 16),
            Expanded(flex: 10, child: side),
          ],
        ),
      );
    }
    return Column(children: [info, const SizedBox(height: 16), side]);
  }
}

class _ContactRow extends StatefulWidget {
  final Widget iconWidget;
  final String title, value;
  final VoidCallback? onTap;
  final Widget? customValueWidget;
  final bool isLast;

  const _ContactRow({
    required this.iconWidget,
    required this.title,
    required this.value,
    this.onTap,
    this.customValueWidget,
    this.isLast = false,
  });

  @override
  State<_ContactRow> createState() => _ContactRowState();
}

class _ContactRowState extends State<_ContactRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final clickable = widget.onTap != null;
    return Padding(
      padding: EdgeInsets.only(bottom: widget.isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: widget.iconWidget,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                if (widget.customValueWidget != null)
                  widget.customValueWidget!
                else if (clickable)
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => _hovered = true),
                    onExit: (_) => setState(() => _hovered = false),
                    child: GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        widget.value,
                        style: TextStyle(
                          color: _hovered ? const Color(0xFFFFE082) : Colors.white,
                          fontSize: 13.5,
                          height: 1.4,
                          decoration: _hovered ? TextDecoration.underline : TextDecoration.none,
                          decorationColor: const Color(0xFFFFE082),
                        ),
                      ),
                    ),
                  )
                else
                  Text(
                    widget.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      height: 1.4,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneValueWidget extends StatelessWidget {
  const _PhoneValueWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ClickableNumber(
          number: '01122228086',
          onTap: () => _launch('https://wa.me/201122228086'),
        ),
        const Text(
          ' - ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.5,
            height: 1.4,
          ),
        ),
        _ClickableNumber(
          number: '01155665681',
          onTap: () => _launch('https://wa.me/201155665681'),
        ),
      ],
    );
  }
}

class _ClickableNumber extends StatefulWidget {
  final String number;
  final VoidCallback onTap;

  const _ClickableNumber({required this.number, required this.onTap});

  @override
  State<_ClickableNumber> createState() => _ClickableNumberState();
}

class _ClickableNumberState extends State<_ClickableNumber> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.number,
          style: TextStyle(
            color: _hovered ? const Color(0xFFFFE082) : Colors.white,
            fontSize: 13.5,
            height: 1.4,
            decoration: _hovered ? TextDecoration.underline : TextDecoration.none,
            decorationColor: const Color(0xFFFFE082),
          ),
        ),
      ),
    );
  }
}

class _SideCard extends StatelessWidget {
  final Widget child;
  const _SideCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(gradient: kBlueGradient, borderRadius: BorderRadius.circular(22)),
        child: child,
      );
}
