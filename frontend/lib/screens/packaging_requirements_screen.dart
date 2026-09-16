import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/eco_button.dart';
import '../widgets/eco_card.dart';
import 'analysis_screen.dart';

class PackagingRequirementsScreen extends StatefulWidget {
  const PackagingRequirementsScreen({super.key});

  @override
  State<PackagingRequirementsScreen> createState() =>
      _PackagingRequirementsScreenState();
}

class _PackagingRequirementsScreenState
    extends State<PackagingRequirementsScreen> {
  String packageType = 'Flexible Pouch';
  String protectionPriority = 'Balanced';
  String gasRequirement = 'Standard';
  String sustainability = 'High';
  String costPreference = 'Balanced';

  final List<String> packageTypes = [
    'Flexible Pouch',
    'Rigid Container',
    'Tray',
    'Bag',
  ];

  final List<String> protectionOptions = ['Maximum', 'Balanced', 'Basic'];

  final List<String> gasOptions = ['High Barrier', 'Standard', 'Breathable'];

  final List<String> sustainabilityOptions = ['Maximum', 'High', 'Standard'];

  final List<String> costOptions = ['Low Cost', 'Balanced', 'Premium'];

  void startAiAnalysis() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AnalysisScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Packaging Requirements',
          style: AppTextStyles.cardTitle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─────────────────────────────
              // TITLE
              // ─────────────────────────────
              const Text(
                'What does your\npackage need?',
                style: AppTextStyles.screenTitle,
              ),

              const SizedBox(height: 8),

              const Text(
                'Set your packaging priorities. ECO WRAP will '
                'use these preferences when ranking suitable '
                'materials and structures.',
                style: AppTextStyles.body,
              ),

              const SizedBox(height: 25),

              // ─────────────────────────────
              // PACKAGE TYPE
              // ─────────────────────────────
              _RequirementSection(
                title: 'Package Type',
                subtitle: 'What type of package are you considering?',
                icon: Icons.inventory_2_outlined,
                options: packageTypes,
                selected: packageType,
                onSelected: (value) {
                  setState(() {
                    packageType = value;
                  });
                },
              ),

              const SizedBox(height: 18),

              // ─────────────────────────────
              // PROTECTION
              // ─────────────────────────────
              _RequirementSection(
                title: 'Protection Priority',
                subtitle: 'How important is maximum product protection?',
                icon: Icons.shield_outlined,
                options: protectionOptions,
                selected: protectionPriority,
                onSelected: (value) {
                  setState(() {
                    protectionPriority = value;
                  });
                },
              ),

              const SizedBox(height: 18),

              // ─────────────────────────────
              // GAS / MAP
              // ─────────────────────────────
              _RequirementSection(
                title: 'Gas / MAP Requirement',
                subtitle: 'Choose the required gas barrier or exchange level.',
                icon: Icons.air_outlined,
                options: gasOptions,
                selected: gasRequirement,
                onSelected: (value) {
                  setState(() {
                    gasRequirement = value;
                  });
                },
              ),

              const SizedBox(height: 18),

              // ─────────────────────────────
              // SUSTAINABILITY
              // ─────────────────────────────
              _RequirementSection(
                title: 'Sustainability',
                subtitle:
                    'How strongly should eco-friendly options be preferred?',
                icon: Icons.eco_outlined,
                options: sustainabilityOptions,
                selected: sustainability,
                onSelected: (value) {
                  setState(() {
                    sustainability = value;
                  });
                },
              ),

              const SizedBox(height: 18),

              // ─────────────────────────────
              // COST
              // ─────────────────────────────
              _RequirementSection(
                title: 'Cost Preference',
                subtitle: 'Choose the expected packaging cost level.',
                icon: Icons.currency_rupee_outlined,
                options: costOptions,
                selected: costPreference,
                onSelected: (value) {
                  setState(() {
                    costPreference = value;
                  });
                },
              ),

              const SizedBox(height: 22),

              // ─────────────────────────────
              // AI INSIGHT
              // ─────────────────────────────
              EcoCard(
                color: AppColors.cream,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        color: AppColors.mintGreen,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
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
                            'How ECO WRAP uses your preferences',
                            style: AppTextStyles.cardTitle,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Your choices are combined with food properties '
                            'and storage conditions to rank materials based '
                            'on protection, barrier performance, sustainability '
                            'and cost.',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ─────────────────────────────
              // ANALYZE BUTTON
              // ─────────────────────────────
              EcoButton(
                label: 'START AI ANALYSIS',
                icon: Icons.auto_awesome_rounded,
                onPressed: startAiAnalysis,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
          child: _ProgressIndicator(currentStep: 4, totalSteps: 5),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// REQUIREMENT SECTION
// ═══════════════════════════════════════════════

class _RequirementSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const _RequirementSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return EcoCard(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: AppColors.primaryGreen, size: 23),
              ),
              const SizedBox(width: 12),
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
          ),

          const SizedBox(height: 14),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = selected == option;

              return GestureDetector(
                onTap: () => onSelected(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.lightGreen
                        : AppColors.softGreen,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 17,
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.textMuted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        option,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// PROGRESS INDICATOR
// ═══════════════════════════════════════════════

class _ProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _ProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final active = index < currentStep;

        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 5),
            decoration: BoxDecoration(
              color: active ? AppColors.primaryGreen : AppColors.border,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }),
    );
  }
}
