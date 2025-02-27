// import 'package:flutter/material.dart';

// import 'normale.dart';
// import 'oedeme.dart';

// class PBMeasurementPage extends StatefulWidget {
//   const PBMeasurementPage({super.key, required String patientId});

//   @override
//   _PBMeasurementPageState createState() => _PBMeasurementPageState();
// }

// class _PBMeasurementPageState extends State<PBMeasurementPage> {
//   final TextEditingController _pbController = TextEditingController();
//   String? errorText;

//   void handlePBCheck() {
//     double? pbValue = double.tryParse(_pbController.text);

//     if (pbValue == null) {
//       setState(() {
//         errorText = "Veuillez entrer une valeur valide (en mm).";
//       });
//       return;
//     }

//     if (pbValue >= 125) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const NormalResultPage()),
//       );
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => OedemaEvaluationPage(pbValue: pbValue,)),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Prise de Périmètre Brachial"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "Entrez la mesure du PB (en mm)",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _pbController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: "PB (en mm)",
//                 border: const OutlineInputBorder(),
//                 errorText: errorText,
//               ),
//               onChanged: (value) {
//                 if (errorText != null) setState(() => errorText = null);
//               },
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: handlePBCheck,
//               child: const Text("Vérifier le Résultat"),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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

import 'normale.dart';
import 'oedeme.dart';

class PBGuidePage extends StatefulWidget {
  final Patient patient;
  const PBGuidePage({super.key, required this.patient});

  @override
  _PBGuidePageState createState() => _PBGuidePageState();
}

class _PBGuidePageState extends State<PBGuidePage> {
  int currentStep = 0;
  double? measurement;
  String mode = "Chargement..."; // Mode actuel : Dépistage ou Suivi
  bool isLoading = true; // Indique si la vérification est en cours

  final supabase = Supabase.instance.client;

  final List<String> steps = [
    "Demander à la mère d’enlever les habits qui couvrent le bras gauche.",
    "Trouver le point à mi-distance entre l’épaule et le coude.",
    "Placer le ruban autour du bras au niveau de la marque.",
    "Vérifier la tension du ruban (ni trop lâche, ni trop serré).",
    "Lire la mesure et l’enregistrer immédiatement."
  ];

  /// Vérifie si le patient est en mode Suivi ou Dépistage
  Future<void> checkMode() async {
    try {
      // Vérifie dans la table 'mam'
      final mamResponse = await supabase
          .from('mam')
          .select('active')
          .eq('patient_id', widget.patient.id)
          .maybeSingle();

      // Vérifie dans la table 'mas'
      final masResponse = await supabase
          .from('mas')
          .select('active')
          .eq('patient_id', widget.patient.id)
          .maybeSingle();

      final mamData = mamResponse != null ? mamResponse['active'] as bool? : null;
      final masData = masResponse != null ? masResponse['active'] as bool? : null;

      setState(() {
        if (mamData == true || masData == true) {
          mode = "Suivi"; // Si 'active' est true dans l'une des tables
        } else {
          mode = "Dépistage"; // Sinon, mode Dépistage
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        mode = "Erreur lors de la vérification.";
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${e.toString()}")),
      );
    }
  }

  /// Enregistre les données dans la table 'depistage' et insère dans 'mas' si nécessaire
  Future<void> saveMeasurementToSupabase() async {
    if (measurement == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer une mesure valide.")),
      );
      return;
    }

    try {
      // Insertion dans la table 'depistage'
      final response = await supabase.from('depistage').insert({
        'patient_id': widget.patient.id,
        'mode': mode,
        'pb_value': measurement,
        'date': DateTime.now().toIso8601String(),
      }).select('id').single();

      if (response.isEmpty) {
        final depistageId = response['id'];

        // Si PB < 115mm, insérer dans la table 'mas'
        if (measurement! < 115) {
          final masResponse = await supabase.from('mas').insert({
            'patient_id': widget.patient.id,
            'depistage_id': depistageId,
            'date': DateTime.now().toIso8601String(),
          });

          if (masResponse.error == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Patient ajouté à MAS avec succès.")),
            );
          } else {
            throw masResponse.error!;
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Données enregistrées avec succès.")),
        );

        // Redirection selon la valeur de PB
        if (measurement! >= 125) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NormalResultPage(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OedemaEvaluationPage(
                pbValue: measurement!,
                patient: widget.patient,
                depistageId: depistageId,
              ),
            ),
          );
        }
      } else {
        throw Exception("Aucune réponse de Supabase.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'enregistrement : ${e.toString()}")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkMode(); // Vérifie le mode avant de commencer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guide Prise de PB"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Indique le chargement
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Mode actuel : $mode",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Étape ${currentStep + 1} sur ${steps.length}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          steps[currentStep],
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        if (currentStep == steps.length - 1)
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Entrez la mesure en cm",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              measurement = double.tryParse(value);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: currentStep > 0
                          ? () => setState(() => currentStep--)
                          : null,
                      child: const Text("Retour"),
                    ),
                    if (currentStep == steps.length - 1)
                      ElevatedButton(
                        onPressed: saveMeasurementToSupabase,
                        child: const Text("Enregistrer"),
                      )
                    else
                      ElevatedButton(
                        onPressed: currentStep < steps.length - 1
                            ? () => setState(() => currentStep++)
                            : null,
                        child: const Text("Suivant"),
                      ),
                  ],
                ),
              ],
            ),
    );
  }
}
