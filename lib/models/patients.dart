class Patient {
  final String id;
  final String nomPrenom;
  final String categorie;
  final int ageMois;
  final String sexe;
  final String localite;
  final String nomMere;
  final bool synchronise;

  Patient({
    required this.id,
    required this.nomPrenom,
    required this.categorie,
    required this.ageMois,
    required this.sexe,
    required this.localite,
    required this.nomMere,
    this.synchronise = false,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'nomPrenom': nomPrenom,
      'categorie': categorie,
      'ageMois': ageMois,
      'sexe': sexe,
      'localite': localite,
      'centreSante': nomMere,
      'synchronise': synchronise ? 1 : 0,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] ?? 'Inconnu',
      nomPrenom: map['nomPrenom'] ?? 'InconnuNp' ,
      categorie: map['categorie'] ?? 'InconnuC',
      ageMois: map['ageMois'],
      sexe: map['sexe'],
      localite: map['localite'] ?? 'InconnuL',
      nomMere: map['nomMere'] ?? 'InconnuNM',
      synchronise: map['synchronise'] ?? false,
    );
  }
}
