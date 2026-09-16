import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    Timer(const Duration(seconds: 4), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = math.min(constraints.maxWidth, 430.0);

          return Container(
            color: const Color(0xFFF0FAF4),
            child: Center(
              child: SizedBox(
                width: width,
                height: constraints.maxHeight,
                child: Stack(
                  children: [
                    const Positioned.fill(child: _PremiumBackground()),

                    SafeArea(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            child: Column(
                              children: [
                                const SizedBox(height: 28),

                                const _PremiumLogo(),

                                const SizedBox(height: 13),

                                const Text(
                                  'ECO WRAP',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 29,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0B5D3B),
                                    letterSpacing: 1.2,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                const Text(
                                  'Smart Packaging for a\nSustainable Tomorrow',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.35,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF527267),
                                  ),
                                ),

                                const SizedBox(height: 18),

                                Expanded(
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/splash/food_basket.jpeg',
                                      width: width * 0.88,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                const _BenefitsRow(),

                                const SizedBox(height: 20),

                                const _BrandStatement(),

                                const SizedBox(height: 18),

                                const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Color(0xFF0B5D3B),
                                  ),
                                ),

                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PremiumLogo extends StatelessWidget {
  const _PremiumLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      height: 52,
      child: CustomPaint(painter: _PremiumLogoPainter()),
    );
  }
}

class _PremiumLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0B5D3B)
      ..style = PaintingStyle.fill;

    final leftLeaf = Path()
      ..moveTo(size.width * 0.48, size.height * 0.78)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.70,
        size.width * 0.04,
        size.height * 0.40,
        size.width * 0.15,
        size.height * 0.10,
      )
      ..cubicTo(
        size.width * 0.43,
        size.height * 0.12,
        size.width * 0.57,
        size.height * 0.34,
        size.width * 0.48,
        size.height * 0.78,
      )
      ..close();

    final rightLeaf = Path()
      ..moveTo(size.width * 0.50, size.height * 0.82)
      ..cubicTo(
        size.width * 0.55,
        size.height * 0.42,
        size.width * 0.78,
        size.height * 0.13,
        size.width * 0.98,
        size.height * 0.11,
      )
      ..cubicTo(
        size.width * 0.99,
        size.height * 0.43,
        size.width * 0.80,
        size.height * 0.72,
        size.width * 0.50,
        size.height * 0.82,
      )
      ..close();

    canvas.drawPath(leftLeaf, paint);
    canvas.drawPath(rightLeaf, paint);

    final stem = Paint()
      ..color = const Color(0xFF0B5D3B)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.50, size.height * 0.88),
      Offset(size.width * 0.50, size.height * 0.42),
      stem,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BenefitsRow extends StatelessWidget {
  const _BenefitsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _PremiumBenefit(
            icon: Icons.shield_outlined,
            title: 'Protect Food',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _PremiumBenefit(
            icon: Icons.recycling_outlined,
            title: 'Reduce Waste',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _PremiumBenefit(
            icon: Icons.eco_outlined,
            title: 'Greener Future',
          ),
        ),
      ],
    );
  }
}

class _PremiumBenefit extends StatelessWidget {
  final IconData icon;
  final String title;

  const _PremiumBenefit({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2E7),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFC7E4D2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 23, color: const Color(0xFF0B5D3B)),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF285A45),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandStatement extends StatelessWidget {
  const _BrandStatement();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Better Packaging',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0B5D3B),
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Healthier Food  •  Brighter Tomorrow',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF71847B),
          ),
        ),
      ],
    );
  }
}

class _PremiumBackground extends StatelessWidget {
  const _PremiumBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BackgroundPainter());
  }
}

class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = const Color(0xFFB8DCC5)
      ..style = PaintingStyle.fill;

    final leafPaint = Paint()
      ..color = const Color(0xFFD6ECDD)
      ..style = PaintingStyle.fill;

    final dots = [
      Offset(size.width * 0.10, size.height * 0.16),
      Offset(size.width * 0.87, size.height * 0.12),
      Offset(size.width * 0.92, size.height * 0.31),
      Offset(size.width * 0.07, size.height * 0.39),
      Offset(size.width * 0.90, size.height * 0.68),
      Offset(size.width * 0.08, size.height * 0.78),
    ];

    for (final dot in dots) {
      canvas.drawCircle(dot, 3, dotPaint);
    }

    final leaf1 = Path()
      ..moveTo(size.width * 0.04, size.height * 0.22)
      ..quadraticBezierTo(
        size.width * 0.14,
        size.height * 0.18,
        size.width * 0.18,
        size.height * 0.26,
      )
      ..quadraticBezierTo(
        size.width * 0.10,
        size.height * 0.29,
        size.width * 0.04,
        size.height * 0.22,
      )
      ..close();

    final leaf2 = Path()
      ..moveTo(size.width * 0.91, size.height * 0.48)
      ..quadraticBezierTo(
        size.width * 0.82,
        size.height * 0.43,
        size.width * 0.79,
        size.height * 0.51,
      )
      ..quadraticBezierTo(
        size.width * 0.86,
        size.height * 0.55,
        size.width * 0.91,
        size.height * 0.48,
      )
      ..close();

    canvas.drawPath(leaf1, leafPaint);
    canvas.drawPath(leaf2, leafPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
