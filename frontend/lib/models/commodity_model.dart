// ============================================================
// ECO WRAP - Commodity Data Models
// ============================================================

class CommodityModel {
  final String name;
  final String category;

  final double moistureMin;
  final double moistureMax;

  final double phMin;
  final double phMax;

  final double fatMin;
  final double fatMax;

  final String respirationLevel;
  final String moistureSensitivity;
  final String oxygenSensitivity;
  final String lightSensitivity;
  final String mechanicalSensitivity;
  final String gasExchangeRequirement;

  final List<PackagingCandidate> packagingCandidates;

  const CommodityModel({
    required this.name,
    required this.category,
    required this.moistureMin,
    required this.moistureMax,
    required this.phMin,
    required this.phMax,
    required this.fatMin,
    required this.fatMax,
    required this.respirationLevel,
    required this.moistureSensitivity,
    required this.oxygenSensitivity,
    required this.lightSensitivity,
    required this.mechanicalSensitivity,
    required this.gasExchangeRequirement,
    required this.packagingCandidates,
  });

  String get moistureRange {
    return '${moistureMin.toStringAsFixed(1)}–'
        '${moistureMax.toStringAsFixed(1)}%';
  }

  String get phRange {
    return '${phMin.toStringAsFixed(1)}–'
        '${phMax.toStringAsFixed(1)}';
  }

  String get fatRange {
    return '${fatMin.toStringAsFixed(1)}–'
        '${fatMax.toStringAsFixed(1)}%';
  }

  String get displayName => name;

  String get displayCategory => category;

  CommodityModel copyWith({
    String? name,
    String? category,
    double? moistureMin,
    double? moistureMax,
    double? phMin,
    double? phMax,
    double? fatMin,
    double? fatMax,
    String? respirationLevel,
    String? moistureSensitivity,
    String? oxygenSensitivity,
    String? lightSensitivity,
    String? mechanicalSensitivity,
    String? gasExchangeRequirement,
    List<PackagingCandidate>? packagingCandidates,
  }) {
    return CommodityModel(
      name: name ?? this.name,
      category: category ?? this.category,
      moistureMin: moistureMin ?? this.moistureMin,
      moistureMax: moistureMax ?? this.moistureMax,
      phMin: phMin ?? this.phMin,
      phMax: phMax ?? this.phMax,
      fatMin: fatMin ?? this.fatMin,
      fatMax: fatMax ?? this.fatMax,
      respirationLevel: respirationLevel ?? this.respirationLevel,
      moistureSensitivity: moistureSensitivity ?? this.moistureSensitivity,
      oxygenSensitivity: oxygenSensitivity ?? this.oxygenSensitivity,
      lightSensitivity: lightSensitivity ?? this.lightSensitivity,
      mechanicalSensitivity:
          mechanicalSensitivity ?? this.mechanicalSensitivity,
      gasExchangeRequirement:
          gasExchangeRequirement ?? this.gasExchangeRequirement,
      packagingCandidates: packagingCandidates ?? this.packagingCandidates,
    );
  }

  @override
  String toString() {
    return 'CommodityModel(name: $name, category: $category)';
  }
}

class PackagingCandidate {
  final String material;
  final String structure;
  final String packagingType;
  final String barrierLevel;
  final String sealability;
  final String mechanicalStrength;
  final String gasPermeability;

  final double thicknessMin;
  final double thicknessMax;

  final int sustainabilityScore;
  final int costScore;

  final String reason;

  const PackagingCandidate({
    required this.material,
    required this.structure,
    required this.packagingType,
    required this.barrierLevel,
    required this.sealability,
    required this.mechanicalStrength,
    required this.gasPermeability,
    required this.thicknessMin,
    required this.thicknessMax,
    required this.sustainabilityScore,
    required this.costScore,
    required this.reason,
  });

  String get thicknessRange {
    return '${thicknessMin.toStringAsFixed(0)}–'
        '${thicknessMax.toStringAsFixed(0)} µm';
  }

  String get displayMaterial => material;

  String get displayStructure => structure;

  String get displayPackagingType => packagingType;

  PackagingCandidate copyWith({
    String? material,
    String? structure,
    String? packagingType,
    String? barrierLevel,
    String? sealability,
    String? mechanicalStrength,
    String? gasPermeability,
    double? thicknessMin,
    double? thicknessMax,
    int? sustainabilityScore,
    int? costScore,
    String? reason,
  }) {
    return PackagingCandidate(
      material: material ?? this.material,
      structure: structure ?? this.structure,
      packagingType: packagingType ?? this.packagingType,
      barrierLevel: barrierLevel ?? this.barrierLevel,
      sealability: sealability ?? this.sealability,
      mechanicalStrength: mechanicalStrength ?? this.mechanicalStrength,
      gasPermeability: gasPermeability ?? this.gasPermeability,
      thicknessMin: thicknessMin ?? this.thicknessMin,
      thicknessMax: thicknessMax ?? this.thicknessMax,
      sustainabilityScore: sustainabilityScore ?? this.sustainabilityScore,
      costScore: costScore ?? this.costScore,
      reason: reason ?? this.reason,
    );
  }

  @override
  String toString() {
    return 'PackagingCandidate(material: $material, '
        'structure: $structure)';
  }
}
