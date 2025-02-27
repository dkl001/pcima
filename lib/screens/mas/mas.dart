// import 'package:flutter/material.dart';

// class MASPage extends StatelessWidget {
//   final double taille;
//   final double poids;
//   final String sexe;

//   const MASPage({super.key, required this.taille, required this.poids, required this.sexe});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Admis au MAS")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "L'enfant est admis au programme MAS.",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Naviguer vers traitement systématique
//               },
//               child: const Text("Traitement Systématique"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Naviguer vers nutrition
//               },
//               child: const Text("Nutrition"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
