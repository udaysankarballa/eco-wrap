import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/eco_button.dart';
import '../widgets/eco_card.dart';
import 'packaging_requirements_screen.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  final temperatureController = TextEditingController(text: '12');
  final humidityController = TextEditingController(text: '85');
  final durationController = TextEditingController(text: '24');

  String storageType = 'Chilled';
  String transportation = 'Normal';

  final List<String> storageTypes = ['Ambient', 'Chilled', 'Frozen'];

  final List<String> transportationTypes = ['Normal', 'Moderate', 'Rough'];

  @override
  void dispose() {
    temperatureController.dispose();
    humidityController.dispose();
    durationController.dispose();
    super.dispose();
  }

  void continueToPackagingRequirements() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PackagingRequirementsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 35),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProgress(),

                        const SizedBox(height: 25),

                        const Text(
                          'Storage &\ntransport conditions',
                          style: AppTextStyles.screenTitle,
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Tell ECO WRAP how the commodity will be '
                          'stored and transported.',
                          style: AppTextStyles.body,
                        ),

                        const SizedBox(height: 28),

                        _buildSectionTitle(
                          '01',
                          'Storage environment',
                          'Conditions surrounding the commodity.',
                        ),

                        const SizedBox(height: 14),

                        _buildInputCard(
                          icon: Icons.thermostat_rounded,
                          title: 'Storage temperature',
                          subtitle: 'Expected product temperature',
                          controller: temperatureController,
                          suffix: '°C',
                        ),

                        const SizedBox(height: 12),

                        _buildInputCard(
                          icon: Icons.water_drop_rounded,
                          title: 'Relative humidity',
                          subtitle: 'Expected surrounding humidity',
                          controller: humidityController,
                          suffix: '% RH',
                        ),

                        const SizedBox(height: 22),

                        _buildSectionTitle(
                          '02',
                          'Storage type',
                          'Choose the primary storage environment.',
                        ),

                        const SizedBox(height: 14),

                        _buildStorageSelector(),

                        const SizedBox(height: 25),

                        _buildSectionTitle(
                          '03',
                          'Transportation',
                          'Expected physical stress during movement.',
                        ),

                        const SizedBox(height: 14),

                        _buildTransportSelector(),

                        const SizedBox(height: 12),

                        _buildInputCard(
                          icon: Icons.schedule_rounded,
                          title: 'Transport duration',
                          subtitle: 'Approximate journey duration',
                          controller: durationController,
                          suffix: 'hours',
                        ),

                        const SizedBox(height: 22),

                        _buildSmartInsight(),

                        const SizedBox(height: 25),

                        EcoButton(
                          label: 'CONTINUE',
                          icon: Icons.arrow_forward_rounded,
                          onPressed: continueToPackagingRequirements,
                        ),

                        const SizedBox(height: 12),

                        const Center(
                          child: Text(
                            'ECO WRAP will use these conditions during analysis.',
                            style: AppTextStyles.caption,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 5),
      child: Row(
        children: [
          _iconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.pop(context),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Storage Conditions', style: AppTextStyles.cardTitle),
                SizedBox(height: 2),
                Text('Packaging analysis setup', style: AppTextStyles.caption),
              ],
            ),
          ),

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

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return Row(
      children: List.generate(5, (index) {
        final active = index < 3;

        return Expanded(
          child: Container(
            height: 5,
            margin: EdgeInsets.only(right: index == 4 ? 0 : 5),
            decoration: BoxDecoration(
              color: active ? AppColors.primaryGreen : AppColors.border,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String number, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 31,
          height: 31,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.cardTitle),
              const SizedBox(height: 3),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required String suffix,
  }) {
    return EcoCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: AppColors.primaryGreen, size: 22),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.cardTitle),
                const SizedBox(height: 3),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 88,
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                suffixText: suffix,
                suffixStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor: AppColors.softGreen,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryGreen,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageSelector() {
    return EcoCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          for (int i = 0; i < storageTypes.length; i++) ...[
            Expanded(
              child: _storageOption(
                title: storageTypes[i],
                icon: _storageIcon(storageTypes[i]),
                selected: storageType == storageTypes[i],
                onTap: () {
                  setState(() {
                    storageType = storageTypes[i];
                  });
                },
              ),
            ),

            if (i != storageTypes.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  IconData _storageIcon(String type) {
    switch (type) {
      case 'Chilled':
        return Icons.ac_unit_rounded;
      case 'Frozen':
        return Icons.severe_cold_rounded;
      default:
        return Icons.home_work_rounded;
    }
  }

  Widget _storageOption({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.lightGreen : AppColors.softGreen,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: selected ? AppColors.primaryGreen : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 21,
              color: selected
                  ? AppColors.primaryGreen
                  : AppColors.textSecondary,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportSelector() {
    return EcoCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          for (int i = 0; i < transportationTypes.length; i++) ...[
            _transportOption(
              title: transportationTypes[i],
              description: _transportDescription(transportationTypes[i]),
              icon: _transportIcon(transportationTypes[i]),
              selected: transportation == transportationTypes[i],
              onTap: () {
                setState(() {
                  transportation = transportationTypes[i];
                });
              },
            ),
            if (i != transportationTypes.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  IconData _transportIcon(String type) {
    switch (type) {
      case 'Moderate':
        return Icons.directions_car_rounded;
      case 'Rough':
        return Icons.warning_amber_rounded;
      default:
        return Icons.local_shipping_rounded;
    }
  }

  String _transportDescription(String type) {
    switch (type) {
      case 'Moderate':
        return 'Regular handling with some stress';
      case 'Rough':
        return 'Higher impact and vibration';
      default:
        return 'Standard handling conditions';
    }
  }

  Widget _transportOption({
    required String title,
    required String description,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: selected ? AppColors.lightGreen : AppColors.softGreen,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primaryGreen : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, size: 20, color: AppColors.primaryGreen),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(description, style: AppTextStyles.caption),
                ],
              ),
            ),

            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 21,
              color: selected ? AppColors.primaryGreen : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartInsight() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.mintGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primaryGreen,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ECO WRAP intelligence', style: AppTextStyles.cardTitle),
                SizedBox(height: 5),
                Text(
                  'Temperature, humidity and transport stress '
                  'help determine the barrier and mechanical '
                  'protection required by the package.',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
