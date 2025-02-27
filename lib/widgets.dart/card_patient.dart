// import 'package:flutter/material.dart';

// import '../models/nutrition.dart';

// class PatientCard extends StatelessWidget {
//   // final NutritionCase nutritionCase;

//   const PatientCard({super.key, required this.nutritionCase});

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isTablet = screenWidth > 600;

//     return Card(
//       margin: EdgeInsets.symmetric(vertical: isTablet ? 16 : 8),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Nom : ${nutritionCase.patientName}",
//               style: TextStyle(
//                 fontSize: isTablet ? 20 : 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               "Âge : ${nutritionCase.ageMonths} mois",
//               style: TextStyle(fontSize: isTablet ? 18 : 14),
//             ),
//             Text(
//               "MUAC : ${nutritionCase.muac} mm",
//               style: TextStyle(fontSize: isTablet ? 18 : 14),
//             ),
//             Text(
//               "Statut : ${nutritionCase.status}",
//               style: TextStyle(fontSize: isTablet ? 18 : 14),
//             ),
//             if (nutritionCase.hasEdema)
//               Text(
//                 "Œdèmes : ${nutritionCase.edemaSeverity}",
//                 style: TextStyle(fontSize: isTablet ? 18 : 14),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
