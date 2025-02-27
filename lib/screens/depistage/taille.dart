// import 'package:flutter/material.dart';

// class MeasurementPage extends StatefulWidget {
//   const MeasurementPage({super.key});

//   @override
//   _MeasurementPageState createState() => _MeasurementPageState();
// }

// class _MeasurementPageState extends State<MeasurementPage> {
//   final TextEditingController _pbController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();
//   String? _errorMessage;
//   String? _nextStepMessage;

//   void _validatePB() {
//     double? pbValue = double.tryParse(_pbController.text);

//     if (pbValue == null || pbValue <= 0) {
//       setState(() {
//         _errorMessage = "Veuillez entrer une valeur valide (en mm).";
//         _nextStepMessage = null;
//       });
//       return;
//     }

//     setState(() {
//       _errorMessage = null;
//     });

//     if (pbValue < 115) {
//       _nextStepMessage = "Inscrire l'enfant au MAS.";
//     } else if (pbValue >= 115 && pbValue < 125) {
//       _nextStepMessage = "Passez à la mesure du poids et de la taille.";
//     } else {
//       _nextStepMessage = "Aucun problème identifié, passez à l'étape suivante.";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Prise des Mesures de l'Enfant"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Étape 1 : Mesure du PB
//             const Text(
//               "Étape 1 : Mesure du Périmètre Brachial (PB)",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/images/pb_measurement.png', // Remplacez par l'illustration du PB
//                   width: 150,
//                   height: 150,
//                   fit: BoxFit.cover,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _pbController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: "Entrez la mesure du PB en mm",
//                 border: const OutlineInputBorder(),
//                 errorText: _errorMessage,
//               ),
//               onChanged: (_) {
//                 if (_errorMessage != null) {
//                   setState(() => _errorMessage = null);
//                 }
//               },
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _validatePB,
//               child: const Text("Vérifier le PB"),
//             ),
//             if (_nextStepMessage != null) ...[
//               const SizedBox(height: 20),
//               Text(
//                 _nextStepMessage!,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ],

//             // Étape 2 : Mesure du Poids
//             if (_nextStepMessage == "Passez à la mesure du poids et de la taille.")
//               Column(
//                 children: [
//                   const SizedBox(height: 40),
//                   const Text(
//                     "Étape 2 : Mesure du Poids",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'assets/images/weight_measurement.png', // Remplacez par l'illustration de la mesure du poids
//                         width: 150,
//                         height: 150,
//                         fit: BoxFit.cover,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _weightController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: "Entrez le poids en kg",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Logique de validation de la mesure du poids
//                     },
//                     child: const Text("Valider le Poids"),
//                   ),
//                 ],
//               ),

//             // Étape 3 : Mesure de la Taille
//             if (_nextStepMessage == "Passez à la mesure du poids et de la taille.")
//               Column(
//                 children: [
//                   const SizedBox(height: 40),
//                   const Text(
//                     "Étape 3 : Mesure de la Taille",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'assets/images/height_measurement.png', // Illustration pour la mesure de la taille
//                         width: 150,
//                         height: 150,
//                         fit: BoxFit.cover,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _heightController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: "Entrez la taille en cm",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Logique de validation de la mesure de la taille
//                     },
//                     child: const Text("Valider la Taille"),
//                   ),
//                 ],
//               ),

//             // Étape 4 : Calcul du Z-score
//             if (_nextStepMessage == "Passez à la mesure du poids et de la taille.")
//               Column(
//                 children: [
//                   const SizedBox(height: 40),
//                   const Text(
//                     "Étape 4 : Calcul du Z-score",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     "Utilisez la table OMS bisexe pour trouver le Z-score",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 20),
//                   Image.asset(
//                     'assets/images/z_score_table.png', // Illustration de la table Z-score
//                     width: 200,
//                     height: 200,
//                     fit: BoxFit.cover,
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     "Exemple : Si le Z-score est entre -2 et -3, l’enfant est MAM.",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:pcima/models/patients.dart';
import 'package:pcima/screens/depistage/poids.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// import 'z_score.dart';

class TaillePage extends StatelessWidget {
  final Patient patient;
  final String idDepistage;

  const TaillePage({
    super.key,
    required this.patient,
    required this.idDepistage,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController heightController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mesure de la Taille"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre principal
            _buildTitle("Mesure de la taille pour ${patient.nomPrenom}"),

            // Étape 3 : Enfant < 87 cm (Allongé)
            const SizedBox(height: 20),
            _buildStepCard(
              title: "Étape 3 : Enfant < 87 cm (Allongé)",
              description:
                  "1. Placez une toise au sol.\n"
                  "2. Couchez l'enfant sur la toise, les pieds côté curseur.\n"
                  "3. Maintenez la tête et allongez les jambes jusqu'à ce que les chevilles touchent le curseur.\n"
                  "4. Lisez la mesure à 0,1 cm près.",
              imagePath: 'assets/images/enfant_allonge_taille.png',
            ),

            // Étape 4 : Enfant ≥ 87 cm (Debout)
            const SizedBox(height: 20),
            _buildStepCard(
              title: "Étape 4 : Enfant ≥ 87 cm (Debout)",
              description:
                  "1. Placez une toise verticale sur une surface plane ou contre un mur.\n"
                  "2. L'enfant doit se tenir droit, pieds nus, en contact avec la toise.\n"
                  "3. Maintenez la tête, les épaules, les fesses, les genoux et les chevilles bien droits.\n"
                  "4. Lisez la mesure à 0,1 cm près.",
              imagePath: 'assets/images/enfant_debout_taille.png',
            ),

            // Étape 5 : Calcul du rapport Poids/Taille
            const SizedBox(height: 20),
            _buildStepCard(
              title: "Étape 5 : Calcul du rapport Poids/Taille",
              description:
                  "1. Utilisez la table OMS bisexe pour le Z-score.\n"
                  "2. Trouvez la taille de l'enfant dans la colonne centrale de la table.\n"
                  "3. Recherchez la correspondance du poids sur la même ligne.\n"
                  "4. Identifiez le Z-score (exemple : entre -2 et -3, l’enfant est MAM).",
              imagePath: 'assets/images/table_zscore.png',
            ),

            // Cas particuliers d'arrondi
            const SizedBox(height: 20),
            _buildStepCard(
              title: "Cas particuliers d'arrondi",
              description:
                  "Taille :\n"
                  "- < 0,5 cm : arrondir vers le bas.\n"
                  "- ≥ 0,5 cm : arrondir vers le haut.\n\n"
                  "Poids :\n"
                  "- Si le poids tombe entre deux colonnes, indiquez les écarts réduits correspondants.\n"
                  "- Exemple : 7,9 kg entre 7,7 et 8,3 kg → Z-score entre -4 et -3.",
            ),

            const SizedBox(height: 20),

            // Champ de saisie pour la taille
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Entrez la taille en cm",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // Bouton Continuer
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _onContinue(context, heightController);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Continuer"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Affiche un titre principal
  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Génère une carte avec une étape
  Widget _buildStepCard({
    required String title,
    required String description,
    String? imagePath,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
            if (imagePath != null) ...[
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  imagePath,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Action lors de la validation
  Future<void> _onContinue(
      BuildContext context, TextEditingController heightController) async {
    final tailleString = heightController.text;
    final taille = double.tryParse(tailleString);

    if (taille == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez entrer une taille valide."),
        ),
      );
      return;
    }

    try {
      // Mettre à jour la table 'depistage' avec la taille
      final supabase = Supabase.instance.client;
      final response = await supabase.from('depistage').update({
        'taille': taille,
      }).eq('id', idDepistage);

      if (response.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Taille enregistrée avec succès.")),
        );

        // Rediriger vers la page Z-Score
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PoidsPage(
              patient: patient,
              taille: taille,
              idDepistage: idDepistage,
            ),
          ),
        );
      } else {
        throw response.error!;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors de l'enregistrement : ${e.toString()}"),
        ),
      );
    }
  }
}
