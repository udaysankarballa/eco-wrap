import 'dart:async';

import 'package:flutter/material.dart';

import 'recommendation_screen.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  int currentStep = 0;

  final List<Map<String, dynamic>> analysisSteps = [
    {'title': 'Analyzing food properties', 'icon': Icons.science_outlined},
    {
      'title': 'Evaluating storage conditions',
      'icon': Icons.thermostat_outlined,
    },
    {
      'title': 'Calculating barrier requirements',
      'icon': Icons.shield_outlined,
    },
    {
      'title': 'Comparing packaging materials',
      'icon': Icons.inventory_2_outlined,
    },
    {'title': 'Ranking sustainable options', 'icon': Icons.eco_outlined},
  ];

  @override
  void initState() {
    super.initState();
    startAnalysis();
  }

  void startAnalysis() {
    Timer.periodic(const Duration(milliseconds: 900), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (currentStep < analysisSteps.length - 1) {
        setState(() {
          currentStep++;
        });
      } else {
        timer.cancel();

        Future.delayed(const Duration(milliseconds: 700), () {
          if (!mounted) {
            return;
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const RecommendationScreen(),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / analysisSteps.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
          child: Column(
            children: [
              const Spacer(),

              Container(
                width: 130,
                height: 130,
                decoration: const BoxDecoration(
                  color: Color(0xFFE4F3EA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 68,
                  color: Color(0xFF0B5D3B),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'AI Analysis',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF12372A),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'ECO WRAP is analyzing your requirements '
                'to find the most suitable packaging solution.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 35),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Analysis Progress',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF12372A),
                          ),
                        ),
                        Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B5D3B),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 9,
                        backgroundColor: const Color(0xFFE4F3EA),
                        color: const Color(0xFF0B5D3B),
                      ),
                    ),

                    const SizedBox(height: 24),

                    ...List.generate(analysisSteps.length, (index) {
                      final completed = index < currentStep;

                      final active = index == currentStep;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: completed || active
                                    ? const Color(0xFFE4F3EA)
                                    : const Color(0xFFF7FBF8),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                completed
                                    ? Icons.check
                                    : analysisSteps[index]['icon'] as IconData,
                                size: 20,
                                color: completed || active
                                    ? const Color(0xFF0B5D3B)
                                    : Colors.black26,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                analysisSteps[index]['title'] as String,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: active || completed
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: active || completed
                                      ? const Color(0xFF12372A)
                                      : Colors.black38,
                                ),
                              ),
                            ),

                            if (active)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF0B5D3B),
                                ),
                              )
                            else if (completed)
                              const Icon(
                                Icons.check_circle,
                                size: 18,
                                color: Color(0xFF0B5D3B),
                              ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Evaluating material compatibility, barrier '
                'performance, sustainability and cost.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: Colors.black45,
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
