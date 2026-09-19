import 'package:flutter/material.dart';

import '../models/commodity_model.dart';
import '../models/recommendation_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class PackagingRecommendationScreen extends StatelessWidget {
  final CommodityModel commodity;
  final PackagingRecommendation recommendation;

  final bool useLabValues;
  final double moisture;
  final double ph;
  final double fat;

  final String shelfLife;
  final String storageType;
  final double temperature;
  final double humidity;
  final String transportMode;
  final String transportDuration;

  const PackagingRecommendationScreen({
    super.key,
    required this.commodity,
    required this.recommendation,
    required this.useLabValues,
    required this.moisture,
    required this.ph,
    required this.fat,
    required this.shelfLife,
    required this.storageType,
    required this.temperature,
    required this.humidity,
    required this.transportMode,
    required this.transportDuration,
  });

  @override
  Widget build(BuildContext context) {
    final alternatives = recommendation.alternatives;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF4F1),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 430,
            child: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  _buildHeader(context),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHero(),

                          const SizedBox(height: 18),

                          _buildAnalysisContext(),

                          const SizedBox(height: 22),

                          Text(
                            'Recommended Packaging',
                            style: AppTextStyles.sectionTitle.copyWith(
                              fontSize: 22,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            'Ranked options based on food properties, storage and transport conditions.',
                            style: AppTextStyles.caption,
                          ),

                          const SizedBox(height: 14),

                          if (recommendation.recommendedMaterial.isEmpty)
                            _buildNoRecommendation()
                          else ...[
                            _buildTopRecommendation(recommendation),
                            if (alternatives.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              for (int i = 0; i < alternatives.length; i++)
                                _buildAlternativeCard(alternatives[i], i + 2),
                            ],
                          ],
                          const SizedBox(height: 18),

                          _buildConditionsConsidered(),

                          const SizedBox(height: 20),

                          _buildDisclaimer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
              size: 21,
            ),
          ),

          const SizedBox(width: 2),

          Expanded(
            child: Text(
              'AI Recommendation',
              style: AppTextStyles.screenTitle.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(width: 45),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.white,
              size: 23,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Packaging Recommendation',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Optimized for ${commodity.name}',
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.82),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisContext() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: AppColors.primaryGreen,
                  size: 20,
                ),
              ),

              const SizedBox(width: 11),

              const Text('Analysis Context', style: AppTextStyles.cardTitle),
            ],
          ),

          const SizedBox(height: 16),

          _buildContextRow('Commodity', commodity.name),

          _buildContextDivider(),

          _buildContextRow('Respiration Rate', commodity.respirationLevel),

          _buildContextDivider(),

          _buildContextRow('Moisture', '${moisture.toStringAsFixed(1)}%'),

          _buildContextDivider(),

          _buildContextRow('pH', ph.toStringAsFixed(1)),

          _buildContextDivider(),

          _buildContextRow('Fat / Oil', '${fat.toStringAsFixed(1)}%'),

          _buildContextDivider(),

          _buildContextRow('Shelf Life', shelfLife),

          _buildContextDivider(),

          _buildContextRow('Storage', storageType),

          _buildContextDivider(),

          _buildContextRow(
            'Temperature',
            '${temperature.toStringAsFixed(1)} °C',
          ),

          _buildContextDivider(),

          _buildContextRow(
            'Relative Humidity',
            '${humidity.toStringAsFixed(1)}%',
          ),

          _buildContextDivider(),

          _buildContextRow('Transport', transportMode),

          _buildContextDivider(),

          _buildContextRow('Transport Duration', transportDuration),
        ],
      ),
    );
  }

  Widget _buildContextRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(fontSize: 12),
          ),
        ),

        const SizedBox(width: 12),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContextDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Divider(height: 1, color: AppColors.divider),
    );
  }

  Widget _buildTopRecommendation(PackagingRecommendation recommendation) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.35),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: const BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(21),
                topRight: Radius.circular(21),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'BEST MATCH',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),

                const Spacer(),

                const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primaryGreen,
                  size: 21,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation.recommendedMaterial,
                  style: AppTextStyles.heroTitle.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 23,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  recommendation.structure,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 15),

                _buildPackagingType(recommendation),

                const SizedBox(height: 16),

                _buildSpecificationGrid(recommendation),

                const SizedBox(height: 16),

                _buildWhyRecommended(recommendation),

                const SizedBox(height: 16),

                _buildScores(recommendation),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackagingType(PackagingRecommendation recommendation) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.inventory_2_rounded,
            color: AppColors.primaryGreen,
            size: 20,
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              recommendation.packagingType,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationGrid(PackagingRecommendation recommendation) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSpecification(
                Icons.straighten_rounded,
                'Thickness',
                recommendation.thickness,
              ),
            ),
            const SizedBox(width: 9),

            Expanded(
              child: _buildSpecification(
                Icons.shield_outlined,
                'Barrier',
                recommendation.barrierLevel,
              ),
            ),
          ],
        ),

        const SizedBox(height: 9),

        Row(
          children: [
            Expanded(
              child: _buildSpecification(
                Icons.water_drop_outlined,
                'WVTR',
                recommendation.wvtr,
              ),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: _buildSpecification(
                Icons.air_rounded,
                'OTR',
                recommendation.otr,
              ),
            ),
          ],
        ),

        const SizedBox(height: 9),

        Row(
          children: [
            Expanded(
              child: _buildSpecification(
                Icons.lock_outline_rounded,
                'Sealability',
                recommendation.sealability,
              ),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: _buildSpecification(
                Icons.fitness_center_rounded,
                'Strength',
                recommendation.mechanicalStrength,
              ),
            ),
          ],
        ),

        const SizedBox(height: 9),

        Row(
          children: [
            Expanded(
              child: _buildSpecification(
                Icons.swap_horiz_rounded,
                'Gas',
                recommendation.gasPermeability,
              ),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: _buildSpecification(
                Icons.airplay_rounded,
                'MAP',
                recommendation.mapSuitability,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecification(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 18),

          const SizedBox(width: 7),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption.copyWith(fontSize: 9)),

                const SizedBox(height: 2),

                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhyRecommended(PackagingRecommendation recommendation) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_rounded,
            color: AppColors.warning,
            size: 21,
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why this packaging?',
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                ),

                const SizedBox(height: 5),

                Text(recommendation.reasoning.join(' '), style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScores(PackagingRecommendation recommendation) {
    return Row(
      children: [
        Expanded(
          child: _buildScore(
            Icons.eco_rounded,
            'Sustainability',
            recommendation.sustainabilityScore.round(),
          ),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: _buildScore(
            Icons.payments_outlined,
            'Cost',
            recommendation.costScore.round(),
          ),
        ),
      ],
    );
  }

  Widget _buildScore(IconData icon, String label, int score) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 19),

          const SizedBox(width: 7),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                ),

                const SizedBox(height: 2),

                Text(
                  '$score/100',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativeCard(PackagingAlternative candidate, int rank) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(candidate.material, style: AppTextStyles.cardTitle),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            candidate.structure,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryGreen,
            ),
          ),

          const SizedBox(height: 11),

          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              _buildMiniChip('Score: /100'),
              _buildMiniChip('Eco: ${recommendation.sustainabilityScore.round()}/100'),
            ],
          ),

          const SizedBox(height: 11),

          Text(recommendation.reasoning.join(' '), style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildMiniChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          fontSize: 9,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildConditionsConsidered() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Conditions Considered',
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 21),
        ),

        const SizedBox(height: 11),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildConditionRow(
                Icons.water_drop_outlined,
                'Moisture',
                '${moisture.toStringAsFixed(1)}%',
              ),

              _buildInputDivider(),

              _buildConditionRow(
                Icons.science_outlined,
                'pH',
                ph.toStringAsFixed(1),
              ),

              _buildInputDivider(),

              _buildConditionRow(
                Icons.opacity_outlined,
                'Fat / Oil',
                '${fat.toStringAsFixed(1)}%',
              ),

              _buildInputDivider(),

              _buildConditionRow(
                Icons.thermostat_outlined,
                'Temperature',
                '${temperature.toStringAsFixed(1)} °C',
              ),

              _buildInputDivider(),

              _buildConditionRow(
                Icons.water_outlined,
                'Humidity',
                '${humidity.toStringAsFixed(1)}%',
              ),

              _buildInputDivider(),

              _buildConditionRow(
                Icons.warehouse_outlined,
                'Storage',
                storageType,
              ),

              _buildInputDivider(),

              _buildConditionRow(
                Icons.local_shipping_outlined,
                'Transport',
                transportMode,
              ),

              _buildInputDivider(),

              _buildConditionRow(
                Icons.route_outlined,
                'Transport Duration',
                transportDuration,
              ),

              _buildInputDivider(),

              _buildConditionRow(
                useLabValues ? Icons.biotech_rounded : Icons.menu_book_rounded,
                'Profile Source',
                useLabValues ? 'Laboratory' : 'Reference',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConditionRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryGreen, size: 19),

        const SizedBox(width: 10),

        Expanded(child: Text(label, style: AppTextStyles.body)),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Divider(height: 1, color: AppColors.divider),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.info,
            size: 19,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              'ECO WRAP provides an AI-assisted prototype recommendation. Final packaging specifications should be validated using supplier data, laboratory testing and applicable standards before industrial use.',
              style: AppTextStyles.caption.copyWith(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoRecommendation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 46,
            color: AppColors.textMuted,
          ),

          const SizedBox(height: 12),

          const Text(
            'No packaging candidate available',
            style: AppTextStyles.cardTitle,
          ),

          const SizedBox(height: 5),

          const Text(
            'More packaging options can be added to the ECO WRAP database.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  String _otrLevel(PackagingCandidate candidate) {
    final value = candidate.barrierLevel.toLowerCase();

    if (value.contains('high')) {
      return 'Low OTR';
    }

    if (value.contains('medium')) {
      return 'Medium OTR';
    }

    if (value.contains('low')) {
      return 'Higher OTR';
    }

    return 'Requirement-based';
  }

  String _wvtrLevel(PackagingCandidate candidate) {
    final value = candidate.barrierLevel.toLowerCase();

    if (value.contains('high')) {
      return 'Low WVTR';
    }

    if (value.contains('medium')) {
      return 'Medium WVTR';
    }

    if (value.contains('low')) {
      return 'Higher WVTR';
    }

    return 'Requirement-based';
  }

  String _mapSuitability(PackagingCandidate candidate) {
    final gas = candidate.gasPermeability.toLowerCase();
    final type = recommendation.packagingType.toLowerCase();

    if (gas.contains('controlled') ||
        gas.contains('permeable') ||
        type.contains('map')) {
      return 'Suitable';
    }

    return 'Review';
  }
}




