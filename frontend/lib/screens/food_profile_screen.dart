import 'package:flutter/material.dart';

import '../models/commodity_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'packaging_analysis_screen.dart';

class FoodProfileScreen extends StatefulWidget {
  final CommodityModel commodity;

  const FoodProfileScreen({super.key, required this.commodity});

  @override
  State<FoodProfileScreen> createState() => _FoodProfileScreenState();
}

class _FoodProfileScreenState extends State<FoodProfileScreen> {
  String _shelfLife = '7 days';
  String _storageType = 'Refrigerated';
  String _transportMode = 'Refrigerated';
  String _transportDuration = '1–2 days';

  double _temperature = 8;
  double _humidity = 80;

  String _respirationRate = 'Medium';

  bool _useLabValues = false;

  late final TextEditingController _moistureController;
  late final TextEditingController _phController;
  late final TextEditingController _fatController;

  @override
  void initState() {
    super.initState();

    _respirationRate = widget.commodity.respirationLevel;

    _moistureController = TextEditingController(
      text: _midpoint(
        widget.commodity.moistureMin,
        widget.commodity.moistureMax,
      ),
    );

    _phController = TextEditingController(
      text: _midpoint(widget.commodity.phMin, widget.commodity.phMax),
    );

    _fatController = TextEditingController(
      text: _midpoint(widget.commodity.fatMin, widget.commodity.fatMax),
    );
  }

  String _midpoint(double min, double max) {
    return ((min + max) / 2).toStringAsFixed(1);
  }

  @override
  void dispose() {
    _moistureController.dispose();
    _phController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                _buildHeader(),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildReferenceMessage(),

                        const SizedBox(height: 15),

                        _buildLabToggle(),

                        const SizedBox(height: 28),

                        _buildSectionHeader(
                          'Storage Conditions',
                          'Tell us about the actual conditions for this packaging requirement.',
                        ),

                        const SizedBox(height: 14),

                        _buildDropdownCard(
                          label: 'Desired Shelf Life',
                          value: _shelfLife,
                          icon: Icons.timelapse_rounded,
                          items: const [
                            '3 days',
                            '5 days',
                            '7 days',
                            '10 days',
                            '14 days',
                            '21 days',
                            '30 days',
                            '60 days',
                            '90 days',
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _shelfLife = value;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 12),

                        _buildDropdownCard(
                          label: 'Storage Type',
                          value: _storageType,
                          icon: Icons.warehouse_rounded,
                          items: const [
                            'Ambient',
                            'Cold',
                            'Refrigerated',
                            'Frozen',
                            'Controlled Atmosphere',
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _storageType = value;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 12),

                        _buildSliderCard(
                          title: 'Storage Temperature',
                          value: _temperature,
                          min: -20,
                          max: 40,
                          divisions: 60,
                          valueText: '${_temperature.round()} °C',
                          icon: Icons.thermostat_rounded,
                          onChanged: (value) {
                            setState(() {
                              _temperature = value;
                            });
                          },
                        ),

                        const SizedBox(height: 12),

                        _buildSliderCard(
                          title: 'Relative Humidity',
                          value: _humidity,
                          min: 20,
                          max: 100,
                          divisions: 80,
                          valueText: '${_humidity.round()}%',
                          icon: Icons.water_drop_rounded,
                          onChanged: (value) {
                            setState(() {
                              _humidity = value;
                            });
                          },
                        ),

                        const SizedBox(height: 28),

                        _buildSectionHeader(
                          'Transport Conditions',
                          'Transportation conditions help determine mechanical protection needs.',
                        ),

                        const SizedBox(height: 14),

                        _buildDropdownCard(
                          label: 'Transport Mode',
                          value: _transportMode,
                          icon: Icons.local_shipping_rounded,
                          items: const [
                            'Normal',
                            'Refrigerated',
                            'Insulated',
                            'Controlled Temperature',
                            'Air Transport',
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _transportMode = value;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 12),

                        _buildDropdownCard(
                          label: 'Transport Duration',
                          value: _transportDuration,
                          icon: Icons.route_rounded,
                          items: const [
                            '<1 day',
                            '1–2 days',
                            '3–5 days',
                            '6–10 days',
                            '>10 days',
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _transportDuration = value;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 28),

                        _buildRespirationCard(),

                        const SizedBox(height: 20),

                        if (_useLabValues) ...[
                          _buildLabValues(),
                          const SizedBox(height: 20),
                        ],

                        _buildAnalyzeButton(),

                        const SizedBox(height: 12),

                        const Center(
                          child: Text(
                            'ECO WRAP uses these inputs to rank suitable packaging options.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.caption,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
      child: Row(
        children: [
          Material(
            color: AppColors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 23,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          const Text('Food Profile', style: AppTextStyles.screenTitle),

          const Spacer(),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.eco_rounded,
                  size: 15,
                  color: AppColors.primaryGreen,
                ),
                SizedBox(width: 5),
                Text(
                  'ECO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 8, 2, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 16,
              color: AppColors.primaryGreen,
            ),
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              'Reference values are automatically provided for the selected commodity.',
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabToggle() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
      decoration: BoxDecoration(
        color: _useLabValues ? AppColors.lightGreen : AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _useLabValues
              ? AppColors.primaryGreen.withValues(alpha: 0.35)
              : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.biotech_rounded,
              color: AppColors.primaryGreen,
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Use laboratory measurements',
                  style: AppTextStyles.cardTitle,
                ),
                SizedBox(height: 4),
                Text(
                  'Override reference values with your measured food properties.',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          Switch(
            value: _useLabValues,
            activeThumbColor: AppColors.primaryGreen,
            activeTrackColor: AppColors.mintGreen,
            inactiveThumbColor: const Color(0xFF7C8580),
            inactiveTrackColor: const Color(0xFFE4E8E5),
            onChanged: (value) {
              setState(() {
                _useLabValues = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.sectionTitle.copyWith(fontSize: 24)),
        const SizedBox(height: 4),
        Text(subtitle, style: AppTextStyles.body),
      ],
    );
  }

  // FIXED:
  // The selected value is displayed only once.
  // Previously it was rendered manually AND by DropdownButton.
  Widget _buildDropdownCard({
    required String label,
    required String value,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primaryGreen, size: 23),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary,
              ),
              borderRadius: BorderRadius.circular(14),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderCard({
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String valueText,
    required IconData icon,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primaryGreen, size: 23),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 16),
                ),
              ),

              Text(
                valueText,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),

          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primaryGreen,
              inactiveTrackColor: AppColors.mintGreen,
              thumbColor: AppColors.primaryGreen,
              overlayColor: AppColors.primaryGreen.withValues(alpha: 0.10),
              trackHeight: 5,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRespirationCard() {
    final options = ['Low', 'Medium', 'High', 'Very High'];

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
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.air_rounded,
                  color: AppColors.primaryGreen,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Respiration Rate', style: AppTextStyles.cardTitle),
                    SizedBox(height: 3),
                    Text(
                      'Reference classification for gas exchange.',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              final selected = _respirationRate == option;

              return ChoiceChip(
                label: Text(option),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    _respirationRate = option;
                  });
                },
                selectedColor: AppColors.lightGreen,
                backgroundColor: AppColors.softGreen,
                labelStyle: TextStyle(
                  color: selected
                      ? AppColors.primaryGreen
                      : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
                side: BorderSide(
                  color: selected ? AppColors.primaryGreen : AppColors.border,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLabValues() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.biotech_rounded,
                color: AppColors.primaryGreen,
                size: 24,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Laboratory Measurements',
                  style: AppTextStyles.cardTitle,
                ),
              ),
              const Icon(
                Icons.verified_rounded,
                color: AppColors.primaryGreen,
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: 6),

          const Text(
            'Enter measured values to override the commodity reference profile.',
            style: AppTextStyles.caption,
          ),

          const SizedBox(height: 16),

          _buildLabInput(
            controller: _moistureController,
            label: 'Moisture Content',
            suffix: '%',
            icon: Icons.water_drop_rounded,
            hint: 'Measured moisture',
          ),

          const SizedBox(height: 10),

          _buildLabInput(
            controller: _phController,
            label: 'pH',
            suffix: '',
            icon: Icons.science_rounded,
            hint: 'Measured pH',
          ),

          const SizedBox(height: 10),

          _buildLabInput(
            controller: _fatController,
            label: 'Fat / Oil',
            suffix: '%',
            icon: Icons.opacity_rounded,
            hint: 'Measured fat/oil',
          ),
        ],
      ),
    );
  }

  Widget _buildLabInput({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required IconData icon,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix.isEmpty ? null : suffix,
        prefixIcon: Icon(icon, color: AppColors.primaryGreen),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primaryGreen,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _continueToAnalysis,
        icon: const Icon(Icons.auto_awesome_rounded, size: 21),
        label: const Text(
          'Analyze Packaging Requirements',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
    );
  }

  double _labValue(TextEditingController controller, double fallback) {
    return double.tryParse(controller.text.trim()) ?? fallback;
  }

  void _continueToAnalysis() {
    final moistureFallback =
        (widget.commodity.moistureMin + widget.commodity.moistureMax) / 2;

    final phFallback = (widget.commodity.phMin + widget.commodity.phMax) / 2;

    final fatFallback = (widget.commodity.fatMin + widget.commodity.fatMax) / 2;

    final moisture = _useLabValues
        ? _labValue(_moistureController, moistureFallback)
        : moistureFallback;

    final ph = _useLabValues
        ? _labValue(_phController, phFallback)
        : phFallback;

    final fat = _useLabValues
        ? _labValue(_fatController, fatFallback)
        : fatFallback;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PackagingAnalysisScreen(
          commodity: widget.commodity,
          useLabValues: _useLabValues,
          moisture: moisture,
          ph: ph,
          fat: fat,
          respirationRate: _respirationRate,
          shelfLife: _shelfLife,
          storageType: _storageType,
          temperature: '${_temperature.round()} °C',
          humidity: '${_humidity.round()}%',
          transportMode: _transportMode,
          transportDuration: _transportDuration,
        ),
      ),
    );
  }
}
