import 'package:flutter/material.dart';

import 'user_type_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;

  final PageController _pageController = PageController();

  static const int totalPages = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToUserType() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const UserTypeScreen()),
    );
  }

  void _nextAnnouncement() {
    if (currentPage < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      _goToUserType();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCF9),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth > 430
                ? 430.0
                : constraints.maxWidth;

            return Center(
              child: SizedBox(
                width: width,
                height: constraints.maxHeight,
                child: Stack(
                  children: [
                    // Tap anywhere except Skip
                    Positioned.fill(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _nextAnnouncement,
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (page) {
                            setState(() {
                              currentPage = page;
                            });
                          },
                          children: const [
                            _AnnouncementOne(),
                            _AnnouncementTwo(),
                            _AnnouncementThree(),
                            _AnnouncementFour(),
                            _AnnouncementFive(),
                          ],
                        ),
                      ),
                    ),

                    // Skip button
                    Positioned(
                      top: 8,
                      right: 16,
                      child: TextButton(
                        onPressed: _goToUserType,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF26352F),
                          ),
                        ),
                      ),
                    ),

                    // Page dots
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 94,
                      child: _PageIndicator(currentPage: currentPage),
                    ),

                    // Bottom feature bar
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 12,
                      child: const _BottomFeatures(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// ANNOUNCEMENT 1
// ============================================================

class _AnnouncementOne extends StatelessWidget {
  const _AnnouncementOne();

  @override
  Widget build(BuildContext context) {
    return const _AnnouncementLayout(
      title: 'Smart Packaging',
      titleSecondLine: 'Starts Here',
      description: 'AI-powered recommendations\nfor better food preservation.',
      illustration: _PackagingIllustration(),
    );
  }
}

// ============================================================
// ANNOUNCEMENT 2
// ============================================================

class _AnnouncementTwo extends StatelessWidget {
  const _AnnouncementTwo();

  @override
  Widget build(BuildContext context) {
    return const _AnnouncementLayout(
      title: 'Predict Shelf Life',
      description:
          'Estimate packaging suitability\nfor better food preservation.',
      illustration: _ShelfLifeIllustration(),
    );
  }
}

// ============================================================
// ANNOUNCEMENT 3
// ============================================================

class _AnnouncementThree extends StatelessWidget {
  const _AnnouncementThree();

  @override
  Widget build(BuildContext context) {
    return const _AnnouncementLayout(
      title: 'Compare Materials',
      description: 'Compare packaging materials\nusing performance parameters.',
      illustration: _CompareIllustration(),
    );
  }
}

// ============================================================
// ANNOUNCEMENT 4
// ============================================================

class _AnnouncementFour extends StatelessWidget {
  const _AnnouncementFour();

  @override
  Widget build(BuildContext context) {
    return const _AnnouncementLayout(
      title: 'Optimize Cost',
      description: 'Find practical packaging options\nwith cost in mind.',
      illustration: _CostIllustration(),
    );
  }
}

// ============================================================
// ANNOUNCEMENT 5
// ============================================================

class _AnnouncementFive extends StatelessWidget {
  const _AnnouncementFive();

  @override
  Widget build(BuildContext context) {
    return const _AnnouncementLayout(
      title: 'Choose Sustainability',
      description:
          'Discover greener packaging alternatives\nfor a better tomorrow.',
      illustration: _SustainabilityIllustration(),
    );
  }
}

// ============================================================
// COMMON ANNOUNCEMENT LAYOUT
// ============================================================

class _AnnouncementLayout extends StatelessWidget {
  final String title;
  final String? titleSecondLine;
  final String description;
  final Widget illustration;

  const _AnnouncementLayout({
    required this.title,
    required this.description,
    required this.illustration,
    this.titleSecondLine,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 54, 22, 120),
      child: Column(
        children: [
          const SizedBox(height: 14),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              height: 1.12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF08623F),
            ),
          ),

          if (titleSecondLine != null)
            Text(
              titleSecondLine!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 21,
                height: 1.12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF08623F),
              ),
            ),

          const SizedBox(height: 8),

          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              height: 1.4,
              fontWeight: FontWeight.w400,
              color: Color(0xFF586861),
            ),
          ),

          const Expanded(child: SizedBox()),

          illustration,

          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

// ============================================================
// SCREEN 1 ILLUSTRATION
// ============================================================

class _PackagingIllustration extends StatelessWidget {
  const _PackagingIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      height: 280,
      child: CustomPaint(painter: _PackagingPainter()),
    );
  }
}

class _PackagingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 330;

    canvas.save();
    canvas.scale(scale);

    final linePaint = Paint()
      ..color = const Color(0xFF9FD5BA)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Technical packaging lines
    canvas.drawLine(const Offset(35, 105), const Offset(35, 195), linePaint);

    canvas.drawLine(const Offset(35, 105), const Offset(68, 90), linePaint);

    canvas.drawLine(const Offset(68, 90), const Offset(68, 185), linePaint);

    canvas.drawLine(const Offset(265, 86), const Offset(296, 105), linePaint);

    canvas.drawLine(const Offset(296, 105), const Offset(296, 190), linePaint);

    canvas.drawLine(const Offset(265, 86), const Offset(265, 183), linePaint);

    // Technical circles
    final circlePaint = Paint()
      ..color = const Color(0xFF7FC5A4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const points = [
      Offset(27, 112),
      Offset(44, 93),
      Offset(67, 75),
      Offset(286, 91),
      Offset(303, 110),
      Offset(52, 197),
      Offset(279, 194),
    ];

    for (final point in points) {
      canvas.drawCircle(point, 2.5, circlePaint);
    }

    // Container
    final containerPaint = Paint()
      ..color = const Color(0xFFB9DED0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final container = RRect.fromRectAndRadius(
      const Rect.fromLTWH(62, 93, 208, 108),
      const Radius.circular(15),
    );

    canvas.drawRRect(container, containerPaint);

    // Lid
    final lidPath = Path()
      ..moveTo(59, 94)
      ..quadraticBezierTo(72, 78, 95, 79)
      ..lineTo(235, 79)
      ..quadraticBezierTo(258, 79, 272, 94)
      ..lineTo(267, 105)
      ..quadraticBezierTo(245, 91, 224, 91)
      ..lineTo(101, 91)
      ..quadraticBezierTo(77, 91, 63, 105)
      ..close();

    canvas.drawPath(lidPath, containerPaint);

    // Wooden tray
    final tray = RRect.fromRectAndRadius(
      const Rect.fromLTWH(82, 151, 168, 78),
      const Radius.circular(5),
    );

    canvas.drawRRect(
      tray,
      Paint()
        ..color = const Color(0xFFA86B38)
        ..style = PaintingStyle.fill,
    );

    // Tray top
    final trayTop = Path()
      ..moveTo(82, 151)
      ..lineTo(250, 151)
      ..lineTo(239, 169)
      ..lineTo(93, 169)
      ..close();

    canvas.drawPath(
      trayTop,
      Paint()
        ..color = const Color(0xFFC28A4E)
        ..style = PaintingStyle.fill,
    );

    // Strawberries
    _drawStrawberry(canvas, const Offset(116, 137), 0.9);
    _drawStrawberry(canvas, const Offset(151, 130), 1.0);
    _drawStrawberry(canvas, const Offset(188, 137), 0.9);
    _drawStrawberry(canvas, const Offset(218, 131), 0.82);

    // Broccoli
    _drawBroccoli(canvas, const Offset(104, 157), 0.55);
    _drawBroccoli(canvas, const Offset(232, 157), 0.50);

    canvas.restore();
  }

  void _drawStrawberry(Canvas canvas, Offset center, double scale) {
    final fruitPaint = Paint()
      ..color = const Color(0xFFE64A45)
      ..style = PaintingStyle.fill;

    final fruit = Path()
      ..moveTo(center.dx, center.dy - 22 * scale)
      ..cubicTo(
        center.dx - 21 * scale,
        center.dy - 18 * scale,
        center.dx - 20 * scale,
        center.dy + 13 * scale,
        center.dx,
        center.dy + 23 * scale,
      )
      ..cubicTo(
        center.dx + 20 * scale,
        center.dy + 13 * scale,
        center.dx + 21 * scale,
        center.dy - 18 * scale,
        center.dx,
        center.dy - 22 * scale,
      )
      ..close();

    canvas.drawPath(fruit, fruitPaint);

    final leafPaint = Paint()
      ..color = const Color(0xFF16834F)
      ..style = PaintingStyle.fill;

    final leaves = Path()
      ..moveTo(center.dx, center.dy - 18 * scale)
      ..lineTo(center.dx - 12 * scale, center.dy - 29 * scale)
      ..lineTo(center.dx - 3 * scale, center.dy - 16 * scale)
      ..lineTo(center.dx, center.dy - 28 * scale)
      ..lineTo(center.dx + 4 * scale, center.dy - 16 * scale)
      ..lineTo(center.dx + 15 * scale, center.dy - 25 * scale)
      ..lineTo(center.dx + 7 * scale, center.dy - 13 * scale)
      ..close();

    canvas.drawPath(leaves, leafPaint);
  }

  void _drawBroccoli(Canvas canvas, Offset center, double scale) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + 20 * scale),
          width: 10 * scale,
          height: 38 * scale,
        ),
        Radius.circular(4 * scale),
      ),
      Paint()
        ..color = const Color(0xFF72A846)
        ..style = PaintingStyle.fill,
    );

    final green = Paint()
      ..color = const Color(0xFF25874D)
      ..style = PaintingStyle.fill;

    final circles = [
      Offset(center.dx - 13 * scale, center.dy + 3 * scale),
      Offset(center.dx + 1 * scale, center.dy - 4 * scale),
      Offset(center.dx + 14 * scale, center.dy + 4 * scale),
      Offset(center.dx - 4 * scale, center.dy + 10 * scale),
      Offset(center.dx + 9 * scale, center.dy + 12 * scale),
    ];

    for (final point in circles) {
      canvas.drawCircle(point, 13 * scale, green);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// ============================================================
// SCREEN 2 ILLUSTRATION
// ============================================================

class _ShelfLifeIllustration extends StatelessWidget {
  const _ShelfLifeIllustration();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 280,
      height: 250,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.schedule_rounded, size: 150, color: Color(0xFFDCEFE4)),
            Icon(Icons.timelapse_rounded, size: 105, color: Color(0xFF2C9A68)),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SCREEN 3 ILLUSTRATION
// ============================================================

class _CompareIllustration extends StatelessWidget {
  const _CompareIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _materialCard(Icons.inventory_2_outlined, 'PET'),
          const SizedBox(width: 14),
          const Icon(
            Icons.compare_arrows_rounded,
            size: 38,
            color: Color(0xFF0B5D3B),
          ),
          const SizedBox(width: 14),
          _materialCard(Icons.layers_outlined, 'ECO'),
        ],
      ),
    );
  }

  Widget _materialCard(IconData icon, String label) {
    return Container(
      width: 82,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFCDE5D7)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 38, color: const Color(0xFF27895D)),
          const SizedBox(height: 9),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF315A48),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SCREEN 4 ILLUSTRATION
// ============================================================

class _CostIllustration extends StatelessWidget {
  const _CostIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 250,
      child: Center(
        child: Container(
          width: 145,
          height: 145,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFE1F2E8),
            border: Border.all(color: const Color(0xFFB6DCC6), width: 2),
          ),
          child: const Icon(
            Icons.account_balance_wallet_outlined,
            size: 75,
            color: Color(0xFF218657),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SCREEN 5 ILLUSTRATION
// ============================================================

class _SustainabilityIllustration extends StatelessWidget {
  const _SustainabilityIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 250,
      child: Center(
        child: Container(
          width: 155,
          height: 155,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFE0F2E7),
          ),
          child: const Icon(
            Icons.eco_rounded,
            size: 100,
            color: Color(0xFF218657),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PAGE INDICATOR
// ============================================================

class _PageIndicator extends StatelessWidget {
  final int currentPage;

  const _PageIndicator({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: index == currentPage ? 7 : 5,
          height: index == currentPage ? 7 : 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentPage
                ? const Color(0xFF0B5D3B)
                : const Color(0xFFC9D8D0),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// BOTTOM FEATURES
// ============================================================

class _BottomFeatures extends StatelessWidget {
  const _BottomFeatures();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE1EAE4)),
      ),
      child: const Row(
        children: [
          Expanded(
            child: _FeatureItem(
              icon: Icons.speed_outlined,
              label: 'Predict\nShelf Life',
            ),
          ),
          Expanded(
            child: _FeatureItem(
              icon: Icons.widgets_outlined,
              label: 'Compare\nMaterials',
            ),
          ),
          Expanded(
            child: _FeatureItem(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Optimize\nCost',
            ),
          ),
          Expanded(
            child: _FeatureItem(
              icon: Icons.eco_outlined,
              label: 'Choose\nSustainability',
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 19, color: const Color(0xFF176B49)),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 8.5,
            height: 1.15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF52645B),
          ),
        ),
      ],
    );
  }
}
