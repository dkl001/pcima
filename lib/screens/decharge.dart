// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import '../models/nutrition.dart';
// // import '../provider/nutrition.dart';

// // class DischargeCriteriaScreen extends ConsumerWidget {
// //   const DischargeCriteriaScreen({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final patients = ref.watch(nutritionCasesProvider);

// //     final dischargeEligiblePatients = patients.where((patient) {
// //       return (patient.weight >= -2 && patient.muac >= 125); // Exemples des critères de sortie
// //     }).toList();

// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Critères de Sortie')),
// //       body: dischargeEligiblePatients.isEmpty
// //           ? const Center(child: Text('Aucun patient prêt pour la sortie.'))
// //           : ListView.builder(
// //               itemCount: dischargeEligiblePatients.length,
// //               itemBuilder: (context, index) {
// //                 final patient = dischargeEligiblePatients[index];
// //                 return Card(
// //                   margin: const EdgeInsets.all(8.0),
// //                   child: ListTile(
// //                     title: Text(patient.patientName),
// //                     subtitle: const Text("Statut de sortie : Guéri"),
// //                     trailing: const Icon(Icons.exit_to_app),
// //                     onTap: () {
// //                       // Logique pour sortir le patient
// //                       _showDischargeDialog(context, patient);
// //                     },
// //                   ),
// //                 );
// //               },
// //             ),
// //     );
// //   }

// //   void _showDischargeDialog(BuildContext context, NutritionCase patient) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text("Sortir du programme"),
// //         content: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text("Nom du patient : ${patient.patientName}"),
// //             Text("Critères de sortie remplis : ${patient.status == 'Guéri' ? 'Oui' : 'Non'}"),
// //             // Autres critères
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('OK'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import '../models/nutrition.dart';

// class DischargeCriteriaScreen extends StatelessWidget {
//   final NutritionCase patient;

//   const DischargeCriteriaScreen({super.key, required this.patient});

//   String evaluateDischarge() {
//     if (patient.muac >= 125 && patient.weight / patient.height >= -2) {
//       return "Guéri (critères de sortie atteints)";
//     } else if (patient.muac < 125 && patient.weight / patient.height < -2) {
//       return "Non-répondant (échec après 12 semaines)";
//     } else {
//       return "Encore en traitement (critères non atteints)";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dischargeStatus = evaluateDischarge();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Critères de Sortie')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           margin: const EdgeInsets.all(16.0),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Patient : ${patient.patientName}",
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Text("MUAC : ${patient.muac} mm"),
//                 Text("Poids/Taille : ${(patient.weight / patient.height).toStringAsFixed(2)} Z-score"),
//                 const SizedBox(height: 16),
//                 Text(
//                   "Statut : $dischargeStatus",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: dischargeStatus.contains("Guéri")
//                         ? Colors.green
//                         : Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
