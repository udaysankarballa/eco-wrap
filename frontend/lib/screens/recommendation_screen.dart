import 'package:flutter/material.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'AI Recommendation',
          style: TextStyle(
            color: Color(0xFF12372A),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined, color: Color(0xFF12372A)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Best Packaging Match',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF12372A),
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Based on the food profile, storage conditions and '
                'packaging preferences you provided.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 22),

              // Overall recommendation
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0B5D3B), Color(0xFF168A58)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recommended Material',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'PET / PE Laminated Pouch',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    Row(
                      children: [
                        Expanded(
                          child: _ScoreItem(
                            value: '92%',
                            label: 'Compatibility',
                          ),
                        ),
                        Expanded(
                          child: _ScoreItem(value: 'High', label: 'Protection'),
                        ),
                        Expanded(
                          child: _ScoreItem(value: 'A', label: 'Overall'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              const Text(
                'Recommended Specifications',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF12372A),
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _SpecificationCard(
                      icon: Icons.straighten_outlined,
                      title: 'Thickness',
                      value: '80–100 µm',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SpecificationCard(
                      icon: Icons.air_outlined,
                      title: 'OTR',
                      value: '< 10 cc/m²/day',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _SpecificationCard(
                      icon: Icons.water_drop_outlined,
                      title: 'WVTR',
                      value: '< 5 g/m²/day',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SpecificationCard(
                      icon: Icons.local_shipping_outlined,
                      title: 'Strength',
                      value: 'High',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _SpecificationCard(
                      icon: Icons.lock_outline,
                      title: 'Sealability',
                      value: 'High',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SpecificationCard(
                      icon: Icons.speed_outlined,
                      title: 'Gas Permeability',
                      value: 'Low',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // Reasoning
              const Text(
                'Why ECO WRAP recommends this',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF12372A),
                ),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: Colors.black12),
                ),
                child: const Column(
                  children: [
                    _ReasonRow(
                      icon: Icons.shield_outlined,
                      title: 'Strong barrier protection',
                      description:
                          'Helps limit oxygen and moisture transfer '
                          'to support product protection.',
                    ),
                    SizedBox(height: 16),
                    _ReasonRow(
                      icon: Icons.schedule_outlined,
                      title: 'Supports shelf-life goals',
                      description:
                          'The selected structure is suitable for '
                          'the specified storage and shelf-life target.',
                    ),
                    SizedBox(height: 16),
                    _ReasonRow(
                      icon: Icons.local_shipping_outlined,
                      title: 'Good mechanical performance',
                      description:
                          'The laminate structure provides useful '
                          'strength during handling and transportation.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // MAP
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F3EA),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.air, color: Color(0xFF0B5D3B), size: 27),
                    SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MAP Suitability',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF12372A),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Suitable for modified atmosphere packaging '
                            'when commodity respiration and gas composition '
                            'are properly validated.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.45,
                              color: Color(0xFF12372A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // Sustainability
              const Text(
                'Sustainability',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF12372A),
                ),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: Colors.black12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4F3EA),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.eco_outlined,
                        color: Color(0xFF0B5D3B),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good sustainability potential',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF12372A),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Consider recyclable mono-material alternatives '
                            'where barrier requirements allow.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // Alternative materials
              const Text(
                'Alternative Materials',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF12372A),
                ),
              ),

              const SizedBox(height: 14),

              const _AlternativeCard(
                rank: '02',
                material: 'HDPE / PE Structure',
                score: '87%',
                reason: 'Good moisture and mechanical protection',
              ),

              const SizedBox(height: 10),

              const _AlternativeCard(
                rank: '03',
                material: 'Metallized Film Laminate',
                score: '84%',
                reason: 'Excellent barrier performance',
              ),

              const SizedBox(height: 10),

              const _AlternativeCard(
                rank: '04',
                material: 'Recyclable Mono-PE',
                score: '81%',
                reason: 'Better recyclability with moderate barrier',
              ),

              const SizedBox(height: 28),

              // Shelf life
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: Colors.black12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      color: Color(0xFF0B5D3B),
                      size: 27,
                    ),
                    SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI-Assisted Shelf-Life Suitability',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF12372A),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'The recommendation is designed to support '
                            'the requested shelf-life target. Actual shelf '
                            'life should be validated through testing.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B5D3B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.analytics_outlined, size: 21),
                      SizedBox(width: 8),
                      Text(
                        'VIEW DETAILED ANALYSIS',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  final String value;
  final String label;

  const _ScoreItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}

class _SpecificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _SpecificationCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0B5D3B), size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF12372A),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ReasonRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE4F3EA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF0B5D3B), size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF12372A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AlternativeCard extends StatelessWidget {
  final String rank;
  final String material;
  final String score;
  final String reason;

  const _AlternativeCard({
    required this.rank,
    required this.material,
    required this.score,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE4F3EA),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              rank,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B5D3B),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF12372A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  reason,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
          Text(
            score,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B5D3B),
            ),
          ),
        ],
      ),
    );
  }
}
