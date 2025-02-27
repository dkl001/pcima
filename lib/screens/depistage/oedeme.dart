// import 'package:flutter/material.dart';

// class OedemaEvaluationPage extends StatelessWidget {
//   final List<String> oedemaDescriptions = [
//     "Œdèmes Légers: des 2 pieds (+)",
//     "Œdèmes Modérés: des 2 pieds et la partie inférieure des jambes ou bras (++).",
//     "Œdèmes Sévères : généralisés (incluant les pieds, jambes, bras, mains, visage +++).",
//   ];

//    OedemaEvaluationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Évaluation des Œdèmes"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Recherche des Œdèmes Bilatéraux",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "Étapes d'évaluation :",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "1. Appuyez avec votre pouce sur les deux pieds pendant au moins 3 secondes.",
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 5),
//             const Text(
//               "2. Si une empreinte persiste sur les deux pieds, l'enfant présente des œdèmes.",
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 5),
//             const Text(
//               "3. Seuls les enfants avec des œdèmes bilatéraux sont enregistrés.",
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "Codification des Œdèmes :",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             ...oedemaDescriptions.map(
//               (desc) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4.0),
//                 child: Text("• $desc", style: const TextStyle(fontSize: 16)),
//               ),
//             ),
//             const Spacer(),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text("Retour"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:pcima/models/patients.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'taille.dart'; // Importer la page Taille

class OedemaEvaluationPage extends StatelessWidget {
  final double pbValue;
  final Patient patient;
  final String depistageId;

  OedemaEvaluationPage({
    super.key,
    required this.pbValue,
    required this.patient,
    required this.depistageId,
  });

  final supabase = Supabase.instance.client;

  final List<String> oedemaLevels = ["Absence", "+", "++", "+++"];

  Future<void> _saveToSupabase(BuildContext context, String severity) async {
    try {
      // Vérification que la valeur est valide
      if (!oedemaLevels.contains(severity)) {
        throw Exception("Valeur non valide pour œdème : $severity");
      }

      // Mise à jour des données dans la table 'depistage'
      final response = await supabase.from('depistage').update({
        'oedeme': severity,
      }).eq('id', depistageId);

      if (response.error != null) {
        throw response.error!;
      }

      // Si l'œdème est de type "+", "++" ou "+++", insérer dans la table 'mas'
      if (severity == "+" || severity == "++" || severity == "+++") {
        final masResponse = await supabase.from('mas').insert({
          'patient_id': patient.id,
          'depistage_id': depistageId,
          'date': DateTime.now().toIso8601String(),
        });

        if (masResponse.error != null) {
          throw masResponse.error!;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Données enregistrées avec succès !")),
      );

      // Redirection vers la page de mesure de taille
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaillePage(
            patient: patient,
            idDepistage: depistageId,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'enregistrement : ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Évaluation des Œdèmes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recherche des Œdèmes Bilatéraux",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Étapes d'évaluation :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "1. Appuyez avec votre pouce sur les deux pieds pendant au moins 3 secondes.",
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              "2. Si une empreinte persiste sur les deux pieds, l'enfant présente des œdèmes.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Codification des Œdèmes :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...oedemaLevels.map(
              (level) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => _saveToSupabase(context, level),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(level),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
