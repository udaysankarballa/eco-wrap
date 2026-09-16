import 'package:flutter/material.dart';

import 'home_screen.dart';

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  int? selectedIndex;

  final List<_UserTypeOption> options = const [
    _UserTypeOption(
      title: 'Farmer',
      subtitle: 'Get simple recommendations',
      icon: Icons.agriculture_outlined,
      color: Color(0xFFE8F5E9),
    ),
    _UserTypeOption(
      title: 'Food Processor',
      subtitle: 'Optimize packaging for production',
      icon: Icons.factory_outlined,
      color: Color(0xFFEAF6F0),
    ),
    _UserTypeOption(
      title: 'Startup',
      subtitle: 'Innovate with sustainable solutions',
      icon: Icons.verified_outlined,
      color: Color(0xFFEDE9FF),
    ),
    _UserTypeOption(
      title: 'Researcher',
      subtitle: 'Access advanced analysis tools',
      icon: Icons.science_outlined,
      color: Color(0xFFE5F5FA),
    ),
  ];

  void _continue() {
    if (selectedIndex == null) {
      return;
    }

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
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
                    // Decorative background
                    const Positioned.fill(child: _UserTypeBackground()),

                    Column(
                      children: [
                        // ------------------------------------------------
                        // TOP BAR
                        // ------------------------------------------------
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 5, 14, 0),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 17,
                                ),
                                color: const Color(0xFF26352F),
                                tooltip: 'Back',
                              ),
                              const Spacer(),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2E7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.eco_rounded,
                                  size: 19,
                                  color: Color(0xFF0B5D3B),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ------------------------------------------------
                        // HEADER
                        // ------------------------------------------------
                        const SizedBox(height: 4),

                        const Text(
                          'Who are you?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF17251F),
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Choose your profile to get a personalized\nexperience.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10.5,
                              height: 1.35,
                              color: Color(0xFF596861),
                            ),
                          ),
                        ),

                        // ------------------------------------------------
                        // USER TYPE CARDS
                        // ------------------------------------------------
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(14, 13, 14, 8),
                            child: Column(
                              children: List.generate(options.length, (index) {
                                final option = options[index];

                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: index == options.length - 1 ? 0 : 8,
                                  ),
                                  child: _UserTypeCard(
                                    option: option,
                                    selected: selectedIndex == index,
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    },
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),

                        // ------------------------------------------------
                        // NEXT BUTTON
                        // ------------------------------------------------
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 17),
                          child: SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: _continue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF087A4B),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              child: const Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
// USER TYPE MODEL
// ============================================================

class _UserTypeOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _UserTypeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

// ============================================================
// USER TYPE CARD
// ============================================================

class _UserTypeCard extends StatelessWidget {
  final _UserTypeOption option;
  final bool selected;
  final VoidCallback onTap;

  const _UserTypeCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: double.infinity,
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: selected ? const Color(0xFF0B8A57) : const Color(0xFFE1EAE4),
            width: selected ? 1.7 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: selected ? 0.06 : 0.025),
              blurRadius: selected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: option.color,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                option.icon,
                size: 23,
                color: selected
                    ? const Color(0xFF087A4B)
                    : const Color(0xFF27885D),
              ),
            ),

            const SizedBox(width: 11),

            // Text
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E2924),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    option.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF728078),
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 19,
              height: 19,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? const Color(0xFF0B8A57) : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? const Color(0xFF0B8A57)
                      : const Color(0xFFC8D5CE),
                  width: 1.3,
                ),
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// BACKGROUND DECORATION
// ============================================================

class _UserTypeBackground extends StatelessWidget {
  const _UserTypeBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _UserTypeBackgroundPainter());
  }
}

class _UserTypeBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final leafPaint = Paint()
      ..color = const Color(0xFFDCEFE3)
      ..style = PaintingStyle.fill;

    // Bottom-left leaf
    final leftLeaf = Path()
      ..moveTo(0, size.height * 0.93)
      ..quadraticBezierTo(
        size.width * 0.07,
        size.height * 0.88,
        size.width * 0.12,
        size.height * 0.94,
      )
      ..quadraticBezierTo(size.width * 0.07, size.height * 0.98, 0, size.height)
      ..close();

    canvas.drawPath(leftLeaf, leafPaint);

    // Bottom-right leaf
    final rightLeaf = Path()
      ..moveTo(size.width, size.height * 0.79)
      ..quadraticBezierTo(
        size.width * 0.91,
        size.height * 0.75,
        size.width * 0.88,
        size.height * 0.82,
      )
      ..quadraticBezierTo(
        size.width * 0.94,
        size.height * 0.86,
        size.width,
        size.height * 0.87,
      )
      ..close();

    canvas.drawPath(rightLeaf, leafPaint);

    // Small decorative stem
    final stemPaint = Paint()
      ..color = const Color(0xFFB7DCC5)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width * 0.91, size.height * 0.79),
      Offset(size.width * 0.97, size.height * 0.73),
      stemPaint,
    );

    // Small dots
    final dotPaint = Paint()
      ..color = const Color(0xFFB8DCC5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.08, size.height * 0.17),
      2.5,
      dotPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.91, size.height * 0.31),
      2,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
