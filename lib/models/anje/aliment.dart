class Aliment {
  String type;
  String frequence;
  String quantite;
  String texture;

  Aliment({
    required this.type,
    required this.frequence,
    required this.quantite,
    required this.texture,
  });

  // Convertit un objet Aliment en JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'frequence': frequence,
      'quantite': quantite,
      'texture': texture,
    };
  }

  // Crée un objet Aliment depuis un JSON
  factory Aliment.fromJson(Map<String, dynamic> json) {
    return Aliment(
      type: json['type'],
      frequence: json['frequence'],
      quantite: json['quantite'],
      texture: json['texture'],
    );
  }
}
