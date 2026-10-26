import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/common.dart';

class ProductsPage extends StatelessWidget {
  final void Function(String) onOpenRelated;
  const ProductsPage({super.key, required this.onOpenRelated});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final wide = width >= 1000;
    final mobile = width < 700;

    final productsPanel = BluePanel(
      padding: EdgeInsets.all(mobile ? 14 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(radius: mobile ? 9 : 11, backgroundColor: Colors.white),
            const SizedBox(width: 12),
            Text(
              'Product',
              style: TextStyle(
                color: Colors.white,
                fontSize: mobile ? 18 : 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ]),
          const SizedBox(height: 14),
          LayoutBuilder(builder: (context, c) {
            final cols = c.maxWidth > 560 ? 2 : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                mainAxisExtent: mobile ? 78 : 84,
                crossAxisSpacing: 16,
                mainAxisSpacing: mobile ? 8 : 10,
              ),
              itemBuilder: (_, i) => _ProductTile(
                products[i],
                () => onOpenRelated(products[i].name),
                mobile: mobile,
              ),
            );
          }),
          const SizedBox(height: 10),
          GradientPill(
            label: 'Explore Products',
            arrow: true,
            onTap: () => onOpenRelated('H. Pylori Ag TEST'),
          ),
        ],
      ),
    );

    final banners = Column(children: [
      _Banner(
        tagline: 'Reliable lab and medical\nsolutions for your business',
        title: 'EVO STAR',
        subtitle: 'Blood Hemoglobin Measuring System',
        image: 'assets/images/evo_star.png',
        onTap: () => onOpenRelated('EVO STAR'),
        mobile: mobile,
      ),
      const SizedBox(height: 14),
      _Banner(
        tagline: 'Quality Equipment\nfor Accurate Results',
        title: 'EVO PLUS',
        subtitle: 'Blood Glucose Monitoring System',
        image: 'assets/images/evo_plus.png',
        onTap: () => onOpenRelated('EVO PLUS'),
        mobile: mobile,
      ),
    ]);

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 11, child: productsPanel),
          const SizedBox(width: 14),
          Expanded(flex: 10, child: banners),
        ],
      );
    }
    return Column(children: [banners, const SizedBox(height: 18), productsPanel]);
  }
}

class _ProductTile extends StatelessWidget {
  final Product p;
  final VoidCallback onTap;
  final bool mobile;
  const _ProductTile(this.p, this.onTap, {this.mobile = false});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            CircleAvatar(radius: mobile ? 8 : 10, backgroundColor: Colors.white),
            SizedBox(width: mobile ? 10 : 14),
            Container(
              width: mobile ? 76 : 90,
              height: mobile ? 62 : 70,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Image.asset(
                p.image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(color: kGrey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: mobile ? 13 : 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.spec,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: mobile ? 10 : 10.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _Banner extends StatelessWidget {
  final String tagline, title, subtitle, image;
  final VoidCallback onTap;
  final bool mobile;
  const _Banner({
    required this.tagline,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.onTap,
    this.mobile = false,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(mobile ? 10 : 16),
        decoration: BoxDecoration(color: kGrey, borderRadius: BorderRadius.circular(mobile ? 18 : 22)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: mobile ? 205 : 225,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  image,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: const BoxDecoration(gradient: kBlueGradient),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.black.withValues(alpha: mobile ? 0.68 : 0.40),
                          Colors.black.withValues(alpha: mobile ? 0.32 : 0.08),
                          Colors.transparent,
                        ],
                        stops: [0.0, mobile ? 0.62 : 0.45, 1.0],
                      ),
                    ),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final textWidth = constraints.maxWidth * (mobile ? 0.58 : 0.52);
                    return Padding(
                      padding: EdgeInsets.all(mobile ? 14 : 20),
                      child: SizedBox(
                        width: textWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tagline,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: mobile ? 12 : 14,
                                    height: 1.25,
                                    shadows: const [
                                      Shadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 1)),
                                    ],
                                  ),
                                ),
                                SizedBox(height: mobile ? 6 : 12),
                                Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: mobile ? 22 : 30,
                                    letterSpacing: -0.5,
                                    shadows: const [
                                      Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: mobile ? 10 : 11,
                                    color: Colors.white.withValues(alpha: 0.90),
                                    height: 1.2,
                                    shadows: const [
                                      Shadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 1)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            GradientPill(
                              label: 'Explore Products',
                              arrow: true,
                              onTap: onTap,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
