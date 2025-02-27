import 'aliment.dart';
import 'liquide.dart';

class EvaluationAnje {
  String patientId;
  String depistageId;
  String nomAccompagnant;
  String? observationMere;
  String? courbeCroissance;
  String? allaitementDifficultes;
  List<Aliment> alimentsDetails;
  List<Liquide> liquidesDetails;
  String? autresDifficultes;
  String? aideEnfant;
  List<String> pratiquesHygiene;

  EvaluationAnje({
    required this.patientId,
    required this.depistageId,
    required this.nomAccompagnant,
    this.observationMere,
    this.courbeCroissance,
    this.allaitementDifficultes,
    required this.alimentsDetails,
    required this.liquidesDetails,
    this.autresDifficultes,
    this.aideEnfant,
    required this.pratiquesHygiene,
  });

  // Convertit un objet EvaluationAnje en JSON
  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'depistageId': depistageId,
      'nom_accompagnat': nomAccompagnant,
      'observation_mere': observationMere,
      'courbe_croissance': courbeCroissance,
      'allaitement_difficultes': allaitementDifficultes,
      'aliments_details': alimentsDetails.map((a) => a.toJson()).toList(),
      'liquides_details': liquidesDetails.map((l) => l.toJson()).toList(),
      'autres_difficultes': autresDifficultes,
      'aide_enfant': aideEnfant,
      'pratiques_hygiene': pratiquesHygiene,
    };
  }

  // Crée un objet EvaluationAnje depuis un JSON
  factory EvaluationAnje.fromJson(Map<String, dynamic> json) {
    return EvaluationAnje(
      patientId: json['patient_id'],
      depistageId: json['depistageId'],
      nomAccompagnant: json['nom_accompagnat'],
      observationMere: json['observation_mere'],
      courbeCroissance: json['courbe_croissance'],
      allaitementDifficultes: json['allaitement_difficultes'],
      alimentsDetails: (json['aliments_details'] as List)
          .map((a) => Aliment.fromJson(a))
          .toList(),
      liquidesDetails: (json['liquides_details'] as List)
          .map((l) => Liquide.fromJson(l))
          .toList(),
      autresDifficultes: json['autres_difficultes'],
      aideEnfant: json['aide_enfant'],
      pratiquesHygiene: List<String>.from(json['pratiques_hygiene'] ?? []),
    );
  }
}
