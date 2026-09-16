import 'dart:async';

import 'package:flutter/material.dart';

import '../models/commodity_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/eco_button.dart';
import 'packaging_recommendation_screen.dart';

class PackagingAnalysisScreen extends StatefulWidget {
  final CommodityModel commodity;

  final bool useLabValues;
  final double moisture;
  final double ph;
  final double fat;

  final String respirationRate;

  final String shelfLife;
  final String storageType;
  final String temperature;
  final String humidity;

  final String transportMode;
  final String transportDuration;

  const PackagingAnalysisScreen({
    super.key,
    required this.commodity,
    required this.useLabValues,
    required this.moisture,
    required this.ph,
    required this.fat,
    required this.respirationRate,
    required this.shelfLife,
    required this.storageType,
    required this.temperature,
    required this.humidity,
    required this.transportMode,
    required this.transportDuration,
  });

  @override
  State<PackagingAnalysisScreen> createState() =>
      _PackagingAnalysisScreenState();
}

class _PackagingAnalysisScreenState extends State<PackagingAnalysisScreen> {
  double _progress = 0.0;

  Timer? _timer;

  final List<String> _analysisSteps = [
    'Loading commodity profile...',
    'Evaluating respiration requirements...',
    'Analyzing moisture and oxygen sensitivity...',
    'Evaluating storage humidity...',
    'Evaluating transportation requirements...',
    'Comparing packaging materials...',
    'Ranking packaging compatibility...',
    'Preparing recommendation...',
  ];

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnalysis() {
    const totalDuration = Duration(seconds: 4);
    const interval = Duration(milliseconds: 100);

    final totalTicks = totalDuration.inMilliseconds ~/ interval.inMilliseconds;

    var tick = 0;

    _timer = Timer.periodic(interval, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      tick++;

      final progress = tick / totalTicks;

      setState(() {
        _progress = progress.clamp(0.0, 1.0);

        _currentStep = ((_progress * _analysisSteps.length).floor()).clamp(
          0,
          _analysisSteps.length - 1,
        );
      });

      if (tick >= totalTicks) {
        timer.cancel();

        setState(() {
          _progress = 1.0;
          _currentStep = _analysisSteps.length - 1;
        });
      }
    });
  }

  double _parseValue(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9.\-]'), '');

    return double.tryParse(cleaned) ?? 0.0;
  }

  void _openRecommendations() {
    final temperature = _parseValue(widget.temperature);

    final humidity = _parseValue(widget.humidity);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PackagingRecommendationScreen(
          commodity: widget.commodity,
          useLabValues: widget.useLabValues,
          moisture: widget.moisture,
          ph: widget.ph,
          fat: widget.fat,
          shelfLife: widget.shelfLife,
          storageType: widget.storageType,
          temperature: temperature,
          humidity: humidity,
          transportMode: widget.transportMode,
          transportDuration: widget.transportDuration,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completed = _progress >= 1.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 430,
            child: Column(
              children: [
                _buildHeader(),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHero(),

                        const SizedBox(height: 22),

                        _buildProgressCard(),

                        const SizedBox(height: 20),

                        _buildInputSummary(),

                        const SizedBox(height: 20),

                        _buildFoodProfile(),

                        const SizedBox(height: 28),

                        SizedBox(
                          width: double.infinity,
                          child: EcoButton(
                            label: completed
                                ? 'View Packaging Recommendations'
                                : 'Analyzing...',
                            icon: completed
                                ? Icons.arrow_forward_rounded
                                : Icons.auto_awesome,
                            onPressed: completed ? _openRecommendations : null,
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
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
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

          const Expanded(
            child: Text(
              'Packaging Analysis',
              textAlign: TextAlign.center,
              style: AppTextStyles.screenTitle,
            ),
          ),

          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.white,
              size: 26,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Analyzing ${widget.commodity.name}',
            style: AppTextStyles.heroTitle.copyWith(
              color: AppColors.white,
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'ECO WRAP is evaluating food properties, respiration, storage, transport and packaging compatibility.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.white.withValues(alpha: 0.86),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    final percentage = (_progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
              const Icon(
                Icons.psychology_outlined,
                color: AppColors.primaryGreen,
                size: 21,
              ),

              const SizedBox(width: 9),

              Expanded(
                child: Text(
                  _analysisSteps[_currentStep],
                  style: AppTextStyles.cardTitle,
                ),
              ),

              Text(
                '$percentage%',
                style: AppTextStyles.value.copyWith(
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 9,
              backgroundColor: AppColors.lightGreen,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryGreen,
              ),
            ),
          ),

          const SizedBox(height: 13),

          Row(
            children: [
              Icon(
                _progress >= 1.0
                    ? Icons.check_circle_rounded
                    : Icons.auto_awesome_rounded,
                size: 17,
                color: AppColors.primaryGreen,
              ),

              const SizedBox(width: 7),

              Text(
                _progress >= 1.0
                    ? 'Analysis complete'
                    : 'Intelligent compatibility analysis in progress',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputSummary() {
    return _buildCard(
      title: 'Analysis Inputs',
      icon: Icons.tune_rounded,
      child: Column(
        children: [
          _buildSummaryRow(
            'Respiration Rate',
            widget.respirationRate,
            Icons.air_rounded,
          ),

          _buildSummaryRow(
            'Desired Shelf Life',
            widget.shelfLife,
            Icons.schedule_outlined,
          ),

          _buildSummaryRow(
            'Storage Type',
            widget.storageType,
            Icons.inventory_2_outlined,
          ),

          _buildSummaryRow(
            'Temperature',
            widget.temperature,
            Icons.thermostat_outlined,
          ),

          _buildSummaryRow(
            'Relative Humidity',
            widget.humidity,
            Icons.water_drop_outlined,
          ),

          _buildSummaryRow(
            'Transport',
            widget.transportMode,
            Icons.local_shipping_outlined,
          ),

          _buildSummaryRow(
            'Transport Duration',
            widget.transportDuration,
            Icons.timelapse_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildFoodProfile() {
    return _buildCard(
      title: 'Food Profile Used',
      icon: Icons.science_outlined,
      child: Column(
        children: [
          _buildSummaryRow(
            'Moisture',
            '${widget.moisture.toStringAsFixed(1)}%',
            Icons.water_drop_outlined,
          ),

          _buildSummaryRow(
            'pH',
            widget.ph.toStringAsFixed(1),
            Icons.science_outlined,
          ),

          _buildSummaryRow(
            'Fat / Oil',
            '${widget.fat.toStringAsFixed(1)}%',
            Icons.opacity_outlined,
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.softGreen,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                Icon(
                  widget.useLabValues
                      ? Icons.biotech_rounded
                      : Icons.menu_book_rounded,
                  color: AppColors.primaryGreen,
                  size: 19,
                ),

                const SizedBox(width: 9),

                Expanded(
                  child: Text(
                    widget.useLabValues
                        ? 'Laboratory measurements are being used.'
                        : 'Reference commodity profile is being used.',
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
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
                child: Icon(icon, color: AppColors.primaryGreen, size: 20),
              ),

              const SizedBox(width: 10),

              Text(title, style: AppTextStyles.cardTitle),
            ],
          ),

          const SizedBox(height: 14),

          child,
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryGreen),

          const SizedBox(width: 9),

          Expanded(child: Text(label, style: AppTextStyles.caption)),

          const SizedBox(width: 8),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
