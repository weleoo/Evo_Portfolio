import 'package:flutter/material.dart';
import '../constants.dart';
import '../logo_data.dart';

class GradientPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool big;
  final bool arrow;
  const GradientPill({
    super.key,
    required this.label,
    required this.onTap,
    this.big = false,
    this.arrow = false,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: big ? 40 : 16, vertical: big ? 12 : 8),
          decoration: BoxDecoration(gradient: kBlueGradient, borderRadius: BorderRadius.circular(30)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(label,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700, fontSize: big ? 17 : 13)),
            if (arrow) ...[
              const SizedBox(width: 24),
              const Icon(Icons.chevron_right, color: Colors.black, size: 22),
            ],
          ]),
        ),
      );
}

class BluePanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const BluePanel({super.key, required this.child, this.padding = const EdgeInsets.all(28)});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(gradient: kBlueGradient, borderRadius: BorderRadius.circular(22)),
        child: child,
      );
}

/// صورة من الـ assets، ولو مش موجودة بتظهر أيقونة بديلة
class AssetImg extends StatelessWidget {
  final String path;
  final BoxFit fit;
  const AssetImg(this.path, {super.key, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) => Image.asset(
        path,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.white24,
          child: const Center(child: Icon(Icons.image_outlined, color: Colors.white70)),
        ),
      );
}

/// ودجت لوجو EVO MED مع حماية من أي تأخير في الـ asset bundle
class EvoLogo extends StatelessWidget {
  final double width;
  final double height;
  const EvoLogo({super.key, this.width = 54, this.height = 42});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: height,
        child: Image.memory(
          kLogoBytes,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.biotech, color: kBlue),
          ),
        ),
      );
}

