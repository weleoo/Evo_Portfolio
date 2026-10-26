import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/common.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final wide = width >= 900;
    final mobile = width < 600;

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ABOUT US',
          style: TextStyle(
            color: Colors.white,
            fontSize: mobile ? 22 : 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'EVO Med is an Egyptian provider of in-vitro diagnostic devices from advanced laboratory analyzers to point-of-care systems and rapid test kits. We combine reliable technology with genuine local support: installation, training, maintenance and spare parts, all delivered by our team in EGYPT. Because accuracy is not optional and neither is a partner who answers the phone.',
          style: TextStyle(
            color: Colors.white,
            fontSize: mobile ? 14 : (wide ? 18 : 16),
            height: 1.4,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: wide ? 260 : (mobile ? 180 : 220),
        width: double.infinity,
        child: const AssetImg('assets/images/about.png'),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BluePanel(
          padding: EdgeInsets.all(mobile ? 18 : 24),
          child: wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(child: text),
                  const SizedBox(width: 24),
                  Expanded(child: image),
                ])
              : Column(children: [text, const SizedBox(height: 16), image]),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: wide ? 90 : (mobile ? 16 : 30),
          runSpacing: 8,
          children: [
            _AboutTag('Precision Diagnostics', mobile: mobile),
            _AboutTag('Trusted Care', mobile: mobile),
            _AboutTag('Trusted Partner', mobile: mobile),
          ],
        ),
        SizedBox(height: mobile ? 20 : 30),
        Text(
          'Advancing Diagnostic Excellence',
          style: TextStyle(fontSize: mobile ? 18 : 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Text(
          "The region's most trusted provider of in-vitro diagnostic solutions.\nRapid Tests, point-of-care systems - backed by certified quality and genuine local technical support.",
          style: TextStyle(
            color: kNavy,
            fontSize: mobile ? 13.5 : 15,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
        SizedBox(height: mobile ? 36 : 80),
      ],
    );
  }
}

class _AboutTag extends StatelessWidget {
  final String t;
  final bool mobile;
  const _AboutTag(this.t, {this.mobile = false});

  @override
  Widget build(BuildContext context) =>
      Text(t, style: TextStyle(color: kNavy, fontSize: mobile ? 15 : 20, fontWeight: FontWeight.w700));
}
