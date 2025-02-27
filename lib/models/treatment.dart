class MedicalTreatment {
  final String treatmentName;
  final String description;
  final String targetGroup;
  final String dosage;
  final String administrationPeriod;
  final String category;

  MedicalTreatment({
    required this.treatmentName,
    required this.description,
    required this.targetGroup,
    required this.dosage,
    required this.administrationPeriod,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'treatmentName': treatmentName,
      'description': description,
      'targetGroup': targetGroup,
      'dosage': dosage,
      'administrationPeriod': administrationPeriod,
      'category': category,
    };
  }

  factory MedicalTreatment.fromMap(Map<String, dynamic> map) {
    return MedicalTreatment(
      treatmentName: map['treatmentName'],
      description: map['description'],
      targetGroup: map['targetGroup'],
      dosage: map['dosage'],
      administrationPeriod: map['administrationPeriod'],
      category: map['category'],
    );
  }
}
