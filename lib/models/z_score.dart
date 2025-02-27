import 'csvjson.dart' as table;

class ZScoreCalculator {
  

  ZScoreCalculator();

  String calculateZScore({
    required double taille,
    required double poids,
    required String sexe,
  }) {
    final List<Map<String, dynamic>> tableOMS = table.tableOMS ;

    double tailleArrondie = _arrondirTaille(taille);

    Map<String, dynamic>? ligneCorrespondante = tableOMS.firstWhere(
      (ligne) => ligne['longueur_cm'] == tailleArrondie,
      orElse: () => {},
    );

    if (ligneCorrespondante.isEmpty) {
      return "Taille ($taille cm) non trouvée dans la table OMS.";
    }

    double moins3 = ligneCorrespondante["${sexe}_moins_3"];
    double moins2 = ligneCorrespondante["${sexe}_moins_2"];
    double median = ligneCorrespondante["${sexe}_median"];

    if (poids <= moins3) {
      return "MAS-3";
    } else if (poids <= moins2) {
      return "MAM-2";
    } else if (poids <= median) {
      return "Normal";
    } else {
      return "Poids supérieur à la médiane";
    }
  }

  double _arrondirTaille(double taille) {
    double decimalPart = taille - taille.floor();
    return decimalPart < 0.5 ? taille.floorToDouble() : taille.ceilToDouble();
  }
}
