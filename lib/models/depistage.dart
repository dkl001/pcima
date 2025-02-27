class Depistage {
  final String id;
  final String patientId;
  final double perimetreBraquial;
  final double poids;
  final double taille;
  final String oedeme; // +, ++, +++, ou "Absence"
  final String mode;
  final String tri; // CRENI, CRENAS, CRENAM, Normal

  Depistage({
    required this.id,
    required this.patientId,
    required this.perimetreBraquial,
    required this.poids,
    required this.taille,
    required this.oedeme,
    required this.mode,
    required this.tri,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'perimetreBraquial': perimetreBraquial,
      'poids': poids,
      'taille': taille,
      'oedeme': oedeme,
      'mode': mode,
      'tri': tri,
    };
  }

  static Depistage fromMap(Map<String, dynamic> map) {
    return Depistage(
      id: map['id'],
      patientId: map['patientId'],
      perimetreBraquial: map['perimetreBraquial'],
      poids: map['poids'],
      taille: map['taille'],
      oedeme: map['oedeme'],
      mode: map['mode'],
      tri: map['tri'],
    );
  }
}
