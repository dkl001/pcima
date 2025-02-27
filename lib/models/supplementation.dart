class SupplementationPlan {
  final String productName;
  final double dailyRation;
  final double energy;
  final double protein;
  final double fat;
  final String targetGroup;

  SupplementationPlan({
    required this.productName,
    required this.dailyRation,
    required this.energy,
    required this.protein,
    required this.fat,
    required this.targetGroup,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'dailyRation': dailyRation,
      'energy': energy,
      'protein': protein,
      'fat': fat,
      'targetGroup': targetGroup,
    };
  }

  factory SupplementationPlan.fromMap(Map<String, dynamic> map) {
    return SupplementationPlan(
      productName: map['productName'],
      dailyRation: map['dailyRation'],
      energy: map['energy'],
      protein: map['protein'],
      fat: map['fat'],
      targetGroup: map['targetGroup'],
    );
  }
}
