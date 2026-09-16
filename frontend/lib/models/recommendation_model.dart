class PackagingAlternative {
  final String material;
  final String structure;
  final String packagingType;
  final double score;
  final String reason;

  PackagingAlternative({
    required this.material,
    required this.structure,
    required this.packagingType,
    required this.score,
    required this.reason,
  });

  factory PackagingAlternative.fromJson(Map<String, dynamic> json) {
    return PackagingAlternative(
      material: json['material']?.toString() ?? '',
      structure: json['structure']?.toString() ?? '',
      packagingType: json['packaging_type']?.toString() ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      reason: json['reason']?.toString() ?? '',
    );
  }
}

class PackagingRecommendation {
  final String commodity;
  final String recommendedMaterial;
  final String structure;
  final String packagingType;
  final double compatibilityScore;
  final String thickness;
  final String barrierLevel;
  final String otr;
  final String wvtr;
  final String sealability;
  final String mechanicalStrength;
  final String gasPermeability;
  final String mapSuitability;
  final double sustainabilityScore;
  final double costScore;
  final List<String> reasoning;
  final List<PackagingAlternative> alternatives;
  final String disclaimer;

  PackagingRecommendation({
    required this.commodity,
    required this.recommendedMaterial,
    required this.structure,
    required this.packagingType,
    required this.compatibilityScore,
    required this.thickness,
    required this.barrierLevel,
    required this.otr,
    required this.wvtr,
    required this.sealability,
    required this.mechanicalStrength,
    required this.gasPermeability,
    required this.mapSuitability,
    required this.sustainabilityScore,
    required this.costScore,
    required this.reasoning,
    required this.alternatives,
    required this.disclaimer,
  });

  factory PackagingRecommendation.fromJson(Map<String, dynamic> json) {
    return PackagingRecommendation(
      commodity: json['commodity']?.toString() ?? '',
      recommendedMaterial: json['recommended_material']?.toString() ?? '',
      structure: json['structure']?.toString() ?? '',
      packagingType: json['packaging_type']?.toString() ?? '',
      compatibilityScore:
          (json['compatibility_score'] as num?)?.toDouble() ?? 0.0,
      thickness: json['thickness']?.toString() ?? '',
      barrierLevel: json['barrier_level']?.toString() ?? '',
      otr: json['otr']?.toString() ?? '',
      wvtr: json['wvtr']?.toString() ?? '',
      sealability: json['sealability']?.toString() ?? '',
      mechanicalStrength: json['mechanical_strength']?.toString() ?? '',
      gasPermeability: json['gas_permeability']?.toString() ?? '',
      mapSuitability: json['map_suitability']?.toString() ?? '',
      sustainabilityScore:
          (json['sustainability_score'] as num?)?.toDouble() ?? 0.0,
      costScore: (json['cost_score'] as num?)?.toDouble() ?? 0.0,
      reasoning:
          (json['reasoning'] as List?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      alternatives:
          (json['alternatives'] as List?)
              ?.map(
                (item) => PackagingAlternative.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          [],
      disclaimer: json['disclaimer']?.toString() ?? '',
    );
  }
}
