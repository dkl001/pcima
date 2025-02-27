class Liquide {
  String type;
  String frequence;
  String quantite;
  String biberon;

  Liquide({
    required this.type,
    required this.frequence,
    required this.quantite,
    required this.biberon,
  });

  // Convertit un objet Liquide en JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'frequence': frequence,
      'quantite': quantite,
      'biberon': biberon,
    };
  }

  // Crée un objet Liquide depuis un JSON
  factory Liquide.fromJson(Map<String, dynamic> json) {
    return Liquide(
      type: json['type'],
      frequence: json['frequence'],
      quantite: json['quantite'],
      biberon: json['biberon'],
    );
  }
}
