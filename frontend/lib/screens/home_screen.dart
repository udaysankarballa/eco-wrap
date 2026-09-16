import 'package:flutter/material.dart';

import 'commodity_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedBottomIndex = 0;

  final TextEditingController searchController = TextEditingController();

  final List<_CommodityItem> popularCommodities = const [
    _CommodityItem(
      name: 'Tomato',
      emoji: '🍅',
      backgroundColor: Color(0xFFFFE9E9),
    ),
    _CommodityItem(
      name: 'Mango',
      emoji: '🥭',
      backgroundColor: Color(0xFFFFF2D5),
    ),
    _CommodityItem(
      name: 'Apple',
      emoji: '🍎',
      backgroundColor: Color(0xFFFFE9E9),
    ),
    _CommodityItem(
      name: 'Potato',
      emoji: '🥔',
      backgroundColor: Color(0xFFF1E8DA),
    ),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _openCommodityScreen() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CommodityScreen()));
  }

  void _openFeatureScreen({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FeaturePlaceholderScreen(
          title: title,
          subtitle: subtitle,
          icon: icon,
        ),
      ),
    );
  }

  void _handleBottomNavigation(int index) {
    if (index == 0) {
      setState(() {
        selectedBottomIndex = 0;
      });
      return;
    }

    setState(() {
      selectedBottomIndex = index;
    });

    switch (index) {
      case 1:
        _openFeatureScreen(
          title: 'History',
          subtitle: 'Your previous packaging analyses will appear here.',
          icon: Icons.history_rounded,
        );
        break;

      case 2:
        _openFeatureScreen(
          title: 'Reports',
          subtitle: 'Your packaging recommendation reports will appear here.',
          icon: Icons.description_outlined,
        );
        break;

      case 3:
        _openFeatureScreen(
          title: 'Profile',
          subtitle: 'Manage your ECO WRAP profile and preferences.',
          icon: Icons.person_outline_rounded,
        );
        break;
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
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(19, 8, 19, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 18),
                            _buildSearchBar(),
                            const SizedBox(height: 22),
                            _buildPopularSection(),
                            const SizedBox(height: 18),
                            _buildAiBanner(),
                            const SizedBox(height: 22),
                            _buildQuickActions(),
                          ],
                        ),
                      ),
                    ),
                    _buildBottomNavigation(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning!',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF17251F),
                  height: 1.1,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Let's pack a better future 🌱",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF718078),
                ),
              ),
            ],
          ),
        ),
        CustomPaint(size: const Size(48, 48), painter: _LeafLogoPainter()),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 51,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFDCE6E0)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 17),
          const Icon(Icons.search_rounded, size: 22, color: Color(0xFF728078)),
          const SizedBox(width: 13),
          Expanded(
            child: TextField(
              controller: searchController,
              style: const TextStyle(fontSize: 14, color: Color(0xFF26352F)),
              decoration: const InputDecoration(
                hintText: 'Search commodity...',
                hintStyle: TextStyle(fontSize: 14, color: Color(0xFF8C9993)),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              onSubmitted: (_) {
                _openCommodityScreen();
              },
            ),
          ),
          GestureDetector(
            onTap: _openCommodityScreen,
            child: Container(
              width: 42,
              height: 42,
              margin: const EdgeInsets.only(right: 4),
              decoration: const BoxDecoration(
                color: Color(0xFF07834E),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Popular Commodities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF23322C),
                ),
              ),
            ),
            GestureDetector(
              onTap: _openCommodityScreen,
              child: const Text(
                'See all',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF00804B),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 11),
        SizedBox(
          height: 102,
          child: Row(
            children: List.generate(popularCommodities.length, (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == popularCommodities.length - 1 ? 0 : 8,
                  ),
                  child: _PopularCommodityCard(
                    commodity: popularCommodities[index],
                    onTap: _openCommodityScreen,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildAiBanner() {
    return GestureDetector(
      onTap: _openCommodityScreen,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF108953),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF35A66F),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.eco_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 11),
            const Expanded(
              child: Text(
                'AI powered. Sustainable tomorrow.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white,
              size: 27,
            ),
            const SizedBox(width: 9),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF23322C),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.inventory_2_outlined,
                title: 'Recommend',
                subtitle: 'Packaging',
                iconColor: const Color(0xFF3F4DA3),
                backgroundColor: const Color(0xFFF0F0FF),
                onTap: _openCommodityScreen,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.compare_arrows_rounded,
                title: 'Compare',
                subtitle: 'Materials',
                iconColor: const Color(0xFF3949AB),
                backgroundColor: const Color(0xFFF0F0FF),
                onTap: () {
                  _openFeatureScreen(
                    title: 'Compare Materials',
                    subtitle:
                        'Compare packaging materials based on performance, cost and sustainability.',
                    icon: Icons.compare_arrows_rounded,
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.access_time_rounded,
                title: 'Shelf Life',
                subtitle: 'Prediction',
                iconColor: const Color(0xFF0B9961),
                backgroundColor: const Color(0xFFEAF8F1),
                onTap: () {
                  _openFeatureScreen(
                    title: 'Shelf Life Prediction',
                    subtitle:
                        'AI-assisted shelf-life suitability estimation will be available here.',
                    icon: Icons.access_time_rounded,
                  );
                },
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.center_focus_strong_rounded,
                title: 'Identify Food',
                subtitle: '(Scan Image)',
                iconColor: const Color(0xFF3949AB),
                backgroundColor: const Color(0xFFF0F0FF),
                onTap: () {
                  _openFeatureScreen(
                    title: 'Identify Food',
                    subtitle:
                        'Food identification using image recognition will be available here.',
                    icon: Icons.center_focus_strong_rounded,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 77,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E9E5), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _BottomNavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              selected: selectedBottomIndex == 0,
              onTap: () => _handleBottomNavigation(0),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.history_rounded,
              label: 'History',
              selected: selectedBottomIndex == 1,
              onTap: () => _handleBottomNavigation(1),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.description_outlined,
              label: 'Reports',
              selected: selectedBottomIndex == 2,
              onTap: () => _handleBottomNavigation(2),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.person_outline_rounded,
              label: 'Profile',
              selected: selectedBottomIndex == 3,
              onTap: () => _handleBottomNavigation(3),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommodityItem {
  final String name;
  final String emoji;
  final Color backgroundColor;

  const _CommodityItem({
    required this.name,
    required this.emoji,
    required this.backgroundColor,
  });
}

class _PopularCommodityCard extends StatelessWidget {
  final _CommodityItem commodity;
  final VoidCallback onTap;

  const _PopularCommodityCard({required this.commodity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFDCE5E0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 51,
              height: 51,
              decoration: BoxDecoration(
                color: commodity.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  commodity.emoji,
                  style: const TextStyle(fontSize: 31),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              commodity.name,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF45534C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFDCE5E0)),
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: iconColor, size: 23),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF26352F),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF78857F),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22,
            color: selected ? const Color(0xFF00804B) : const Color(0xFF7D8983),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected
                  ? const Color(0xFF00804B)
                  : const Color(0xFF7D8983),
            ),
          ),
        ],
      ),
    );
  }
}

class FeaturePlaceholderScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const FeaturePlaceholderScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCF9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF17251F),
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth > 430
                ? 430.0
                : constraints.maxWidth;

            return Center(
              child: SizedBox(
                width: width,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1F2E8),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Icon(
                          icon,
                          size: 44,
                          color: const Color(0xFF07834E),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF17342A),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF718078),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF6EF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'ECO WRAP • Coming next',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF087A4B),
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
      ),
    );
  }
}

class _LeafLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2C9A60)
      ..style = PaintingStyle.fill;

    final leftLeaf = Path()
      ..moveTo(size.width * 0.48, size.height * 0.58)
      ..quadraticBezierTo(
        size.width * 0.07,
        size.height * 0.38,
        size.width * 0.15,
        size.height * 0.07,
      )
      ..quadraticBezierTo(
        size.width * 0.43,
        size.height * 0.12,
        size.width * 0.48,
        size.height * 0.58,
      )
      ..close();

    final rightLeaf = Path()
      ..moveTo(size.width * 0.51, size.height * 0.58)
      ..quadraticBezierTo(
        size.width * 0.59,
        size.height * 0.18,
        size.width * 0.95,
        size.height * 0.03,
      )
      ..quadraticBezierTo(
        size.width * 0.96,
        size.height * 0.40,
        size.width * 0.51,
        size.height * 0.58,
      )
      ..close();

    canvas.drawPath(leftLeaf, paint);
    canvas.drawPath(rightLeaf, paint);

    final stemPaint = Paint()
      ..color = const Color(0xFF207B4C)
      ..strokeWidth = 1.4;

    canvas.drawLine(
      Offset(size.width * 0.49, size.height * 0.96),
      Offset(size.width * 0.50, size.height * 0.42),
      stemPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
