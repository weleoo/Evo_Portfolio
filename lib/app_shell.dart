import 'dart:math';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'widgets/common.dart';
import 'widgets/live_clock.dart';
import 'widgets/search_dialog.dart';
import 'widgets/hero_image_data.dart';
import 'widgets/product_ticker.dart';
import 'pages/products_page.dart';
import 'pages/contact_page.dart';
import 'pages/about_page.dart';
import 'pages/related_page.dart';

/// تطبيق متكامل:
/// 1) صفحة رئيسية واحدة (Landing Page) بسكرول ناعم بين: المنتجات -> من نحن -> التواصل
/// 2) عارض الـ 3D يفتح فقط عند الضغط على Explore Products أو اختيار أي منتج
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final ScrollController _scrollController = ScrollController();

  // مفاتيح أقسام الصفحة الرئيسية للتمرير الناعم
  final GlobalKey _productsKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  AppPage? _activeNav;
  String _relatedTitle = 'H. Pylori Ag TEST';
  bool _is3DView = false;
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final showBtn = offset > 320;
    if (showBtn != _showBackToTop) {
      setState(() => _showBackToTop = showBtn);
    }
    if (!_is3DView) {
      _detectActiveSection();
    }
  }

  /// كشف القسم المعروض حالياً على الشاشة وتحديث مؤشر النافبار تلقائياً
  void _detectActiveSection() {
    final scrollY = _scrollController.hasClients ? _scrollController.offset : 0.0;
    // إذا كان السكرول في أعلى الصفحة (ضمن منطقة المعرض والهوم)، لا نعلّم أي قسم في النافبار
    if (scrollY < 260) {
      if (_activeNav != null) {
        setState(() => _activeNav = null);
      }
      return;
    }

    final sections = [
      (AppPage.contact, _contactKey),
      (AppPage.about, _aboutKey),
      (AppPage.products, _productsKey),
    ];

    for (final (page, key) in sections) {
      final ctx = key.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox?;
        if (box != null && box.hasSize) {
          final dy = box.localToGlobal(Offset.zero).dy;
          if (dy <= 240) {
            if (_activeNav != page) {
              setState(() => _activeNav = page);
            }
            return;
          }
        }
      }
    }
    if (_activeNav != null) {
      setState(() => _activeNav = null);
    }
  }

  /// تمرير ناعم سلس بأنيميشن مخصص (Smooth Cubic Easing)
  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final position = box.localToGlobal(Offset.zero);
    final currentScroll = _scrollController.offset;
    final isMobile = MediaQuery.of(context).size.width < 800;
    final headerOffset = isMobile ? 140.0 : 130.0;

    final targetOffset = (currentScroll + position.dy - headerOffset).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeInOutCubic,
    );
  }

  void _scrollToTop() {
    if (_is3DView) {
      setState(() {
        _is3DView = false;
        _activeNav = null;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      });
    } else {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 850),
        curve: Curves.easeInOutCubic,
      );
      setState(() => _activeNav = null);
    }
  }

  void _onNavTap(AppPage p) {
    if (_is3DView) {
      setState(() {
        _is3DView = false;
        _activeNav = p;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSection(p);
      });
    } else {
      setState(() => _activeNav = p);
      _scrollToSection(p);
    }
  }

  void _scrollToSection(AppPage p) {
    switch (p) {
      case AppPage.products:
        _scrollTo(_productsKey);
        break;
      case AppPage.about:
        _scrollTo(_aboutKey);
        break;
      case AppPage.contact:
        _scrollTo(_contactKey);
        break;
      case AppPage.related:
        break;
    }
  }

  /// فتح عارض الـ 3D عند الضغط على Explore Products أو كارت منتج
  void openRelated(String title) {
    setState(() {
      _relatedTitle = title;
      _is3DView = true;
    });
    // إعادة السكرول لأول عارض الـ 3D
    _scrollController.jumpTo(0.0);
  }

  void close3DView() {
    setState(() {
      _is3DView = false;
      _activeNav = AppPage.products;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollTo(_productsKey);
    });
  }


  String get _date {
    const m = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'];
    final d = DateTime.now();
    return '${m[d.month - 1]} ${d.day} , ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final mobile = screenWidth < 800;

    return Scaffold(
      body: Stack(
        children: [
          // الدايرة الزخرفية في الخلفية (تظهر فقط على الشاشات الكبيرة لتجنب تشويه حواف الموبايل)
          if (!mobile)
            Positioned(
              right: -90,
              bottom: -90,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF5B67C9), width: 45),
                ),
              ),
            ),

          // المحتوى التفاعلي (إما الصفحة الرئيسية المترابطة أو عارض الـ 3D)
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: EdgeInsets.symmetric(horizontal: mobile ? 12 : 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // مسافة تعويضية تحت شريط الهيدر المثبت
                SizedBox(height: mobile ? 124 : 130),

                if (_is3DView) ...[
                  // ── صفحة الـ 3D (تظهر فقط عند Explore Products) ──
                  const SizedBox(height: 10),
                  _backButton(),
                  const SizedBox(height: 16),
                  RelatedPage(
                    title: _relatedTitle,
                    onSelect: (newTitle) => setState(() => _relatedTitle = newTitle),
                  ),
                  const SizedBox(height: 40),
                ] else ...[
                  // ── الصفحة الرئيسية الممتدة (Landing Page) ──
                  _greetingRow('Welcome', mobile),
                  const SizedBox(height: 20),

                  // بانر المعرض الطبي الرئيسي مع ساعة الحائط الحية التفاعلية
                  _heroShowroomBanner(mobile),
                  const SizedBox(height: 36),

                  // 1) قسم المنتجات (Products)
                  Container(
                    key: _productsKey,
                    child: ProductsPage(onOpenRelated: openRelated),
                  ),
                  const SizedBox(height: 60),

                  // 2) قسم من نحن (About)
                  Container(
                    key: _aboutKey,
                    child: const AboutPage(),
                  ),
                  const SizedBox(height: 20),

                  // 3) قسم التواصل (Contact)
                  Container(
                    key: _contactKey,
                    child: const ContactPage(),
                  ),
                  const SizedBox(height: 40),
                ],

                // الفوتر
                _footer(mobile),
                const SizedBox(height: 36),
              ],
            ),
          ),

          // ── شريط الهيدر المثبت بأعلى الصفحة (Sticky Header) ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(
                horizontal: mobile ? 12 : 56,
                vertical: 8,
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _topBar(mobile, screenWidth),
                    const SizedBox(height: 8),
                    _navBar(mobile),
                  ],
                ),
              ),
            ),
          ),

          // ── زر العودة للأعلى العائم (Back to Top FAB) ──
          Positioned(
            right: mobile ? 16 : 28,
            bottom: 24,
            child: AnimatedScale(
              scale: _showBackToTop ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutBack,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _scrollToTop,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: kBlueGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: kBlue.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backButton() => InkWell(
        onTap: close3DView,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: kGrey,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, color: kNavy, size: 20),
              SizedBox(width: 8),
              Text(
                'Back to All Products',
                style: TextStyle(color: kNavy, fontWeight: FontWeight.w700, fontSize: 13.5),
              ),
            ],
          ),
        ),
      );

  Widget _topBar(bool mobile, double screenWidth) => Container(
        padding: EdgeInsets.symmetric(horizontal: mobile ? 12 : 18, vertical: mobile ? 6 : 8),
        decoration: BoxDecoration(color: kGrey, borderRadius: BorderRadius.circular(40)),
        child: Row(
          children: [
            EvoLogo(width: mobile ? 38 : 46, height: mobile ? 30 : 36),
            SizedBox(width: mobile ? 6 : 10),
            Text(
              'EVO MED',
              style: TextStyle(
                fontSize: mobile ? 18 : 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: const Color(0xFF111111),
              ),
            ),
            SizedBox(width: mobile ? 6 : 28),
            GradientPill(
              label: 'HOME',
              onTap: _scrollToTop,
              big: !mobile,
            ),
            // عارض المنتجات المتحرك الرأسي التفاعلي (ينزلق ويتبدل دورياً)
            if (screenWidth > 540) ...[
              const SizedBox(width: 14),
              ProductTicker(onSelect: (title) => openRelated(title)),
            ],
            const Spacer(),
            Tooltip(
              message: 'البحث في منتجات وأجهزة EVO',
              child: Container(
                width: mobile ? 34 : 38,
                height: mobile ? 34 : 38,
                decoration: const BoxDecoration(shape: BoxShape.circle, gradient: kBlueGradient),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.search, color: Colors.white, size: mobile ? 18 : 20),
                  onPressed: () => ProductSearchDialog.show(context, (title) => openRelated(title)),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _navBar(bool mobile) {
    Widget item(String label, AppPage p) {
      final active = (_activeNav == p) && !_is3DView;
      return InkWell(
        onTap: () => _onNavTap(p),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: mobile ? 14 : 34, vertical: mobile ? 5 : 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: mobile ? 13 : 16,
                  fontWeight: FontWeight.w700,
                  color: active ? kBlue : Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                height: 2.5,
                width: active ? (mobile ? 22 : 30) : 0,
                decoration: BoxDecoration(
                  gradient: active ? kBlueGradient : null,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: mobile ? 2 : 4),
      decoration: BoxDecoration(color: kGrey, borderRadius: BorderRadius.circular(30)),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          item('PRODUCTS', AppPage.products),
          item('ABOUT', AppPage.about),
          item('CONTACT', AppPage.contact),
        ],
      ),
    );
  }

  Widget _greetingRow(String title, bool mobile) {
    final dateChip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: kGrey, borderRadius: BorderRadius.circular(30)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${DateTime.now().day}',
            style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(width: 8),
        Text(_date, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13.5)),
        const SizedBox(width: 6),
        const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.black54),
      ]),
    );

    final banner = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        'assets/images/tubes_banner.png',
        width: 300,
        height: 48,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/lab_banner.png',
          width: 300,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Container(width: 300, height: 48, color: kBlue.withValues(alpha: 0.15)),
        ),
      ),
    );

    final titleCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: mobile ? 34 : 46,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          'Welcome to our store today',
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13.5, color: Colors.black54),
        ),
      ],
    );

    if (mobile) {
      return Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 10,
        children: [
          titleCol,
          dateChip,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 4, child: titleCol),
        dateChip,
        const SizedBox(width: 20),
        banner,
      ],
    );
  }

  /// بانر المعرض الطبي التفاعلي الرئيسي المزود بساعة الحائط الحية والمناطق التفاعلية
  Widget _heroShowroomBanner(bool mobile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(mobile ? 16 : 26),
        border: Border.all(color: kBlue, width: mobile ? 2.0 : 3.5),
        boxShadow: [
          BoxShadow(
            color: kBlue.withValues(alpha: 0.16),
            blurRadius: mobile ? 16 : 28,
            offset: Offset(0, mobile ? 6 : 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: mobile ? (16 / 10.5) : (1024 / 412),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            // حساب التكبير والإزاحة وفق BoxFit.cover بدقة رياضية ميكرومترية تناسب أي شاشة
            final s = max(w / 1024.0, h / 412.0);
            final imgW = 1024.0 * s;
            final imgH = 412.0 * s;
            final xOffset = (w - imgW) / 2.0;
            final yOffset = (h - imgH) / 2.0;

            // تكبير الساعة على الموبايل لتكون بارزة ومقروءة بفخامة مع تناسق تام مع جدار المعرض
            final clockDiameter = mobile ? max(52.0, 92.0 * s) : (72.0 * s);
            final clockCenterX = xOffset + (263.0 * s);
            final clockCenterY = yOffset + (mobile ? (60.0 * s) : (64.0 * s));
            final clockLeft = clockCenterX - (clockDiameter / 2.0);
            final clockTop = clockCenterY - (clockDiameter / 2.0);

            final evoPlusLeft = xOffset + (1024.0 * 0.25 * s);
            final evoPlusTop = yOffset + (412.0 * 0.40 * s);
            final evoPlusW = 1024.0 * 0.16 * s;
            final evoPlusH = 412.0 * 0.55 * s;

            final evoStarLeft = xOffset + (1024.0 * 0.14 * s);
            final evoStarTop = yOffset + (412.0 * 0.42 * s);
            final evoStarW = 1024.0 * 0.12 * s;
            final evoStarH = 412.0 * 0.52 * s;

            final testKitsLeft = xOffset + (1024.0 * 0.66 * s);
            final testKitsTop = yOffset + (412.0 * 0.08 * s);
            final testKitsW = 1024.0 * 0.30 * s;
            final testKitsH = 412.0 * 0.88 * s;

            return Stack(
              children: [
                // 1. صورة المعرض الطبي (Showroom Hero Image) مع Fallback آمن بالذاكرة
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/showroom_hero.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.high,
                    isAntiAlias: true,
                    errorBuilder: (context, error, stackTrace) => Image.memory(
                      kShowroomHeroBytes,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.high,
                      isAntiAlias: true,
                    ),
                  ),
                ),

                // 2. ساعة الحائط التفاعلية الحية (Live Real-time Clock)
                Positioned(
                  left: clockLeft,
                  top: clockTop,
                  child: LiveEvoWallClock(size: clockDiameter),
                ),

                // 3. مناطق النقر التفاعلية الذكية (Interactive Hotspots)
                // منطقة جهاز EVO PLUS
                Positioned(
                  left: evoPlusLeft,
                  top: evoPlusTop,
                  width: evoPlusW,
                  height: evoPlusH,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => openRelated('EVO PLUS'),
                      child: const Tooltip(
                        message: 'انقر لتشغيل المحاكاة ثلاثية الأبعاد لجهاز EVO PLUS 3D',
                        child: SizedBox.expand(),
                      ),
                    ),
                  ),
                ),

                // منطقة جهاز EVO STAR
                Positioned(
                  left: evoStarLeft,
                  top: evoStarTop,
                  width: evoStarW,
                  height: evoStarH,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => openRelated('EVO STAR'),
                      child: const Tooltip(
                        message: 'انقر لعرض جهاز EVO STAR 3D',
                        child: SizedBox.expand(),
                      ),
                    ),
                  ),
                ),

                // منطقة دواليب التحاليل السريعة (Rapid Test Kits Showcase)
                Positioned(
                  left: testKitsLeft,
                  top: testKitsTop,
                  width: testKitsW,
                  height: testKitsH,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _scrollToSection(AppPage.products),
                      child: const Tooltip(
                        message: 'استعراض كواشف التحاليل السريعة Rapid Test Kits',
                        child: SizedBox.expand(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _footer(bool mobile) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: kGrey,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                EvoLogo(width: 34, height: 26),
                SizedBox(width: 10),
                Text(
                  'EVO MED • Precision Diagnostics',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.black54),
                ),
              ],
            ),
            if (!mobile)
              const Text(
                '© 2026 EVO MED L.L.C. All rights reserved.',
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),
          ],
        ),
      );
}
