// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../models/nutrition.dart';
// import '../provider/nutrition.dart';

// class AdmissionFormScreen extends StatefulWidget {
//   const AdmissionFormScreen({super.key});

//   @override
//   _AdmissionFormScreenState createState() => _AdmissionFormScreenState();
// }

// class _AdmissionFormScreenState extends State<AdmissionFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String patientName = '';
//   int ageMonths = 0;
//   double muac = 0.0;
//   double weight = 0.0;
//   double height = 0.0;
//   bool hasEdema = false;
//   String edemaSeverity = 'Non spécifié';

//   void submitForm(WidgetRef ref) {
//     if (_formKey.currentState!.validate()) {
//       final newCase = NutritionCase(
//         id: 0, // Auto-incrément
//         patientName: patientName,
//         ageMonths: ageMonths,
//         muac: muac,
//         weight: weight,
//         height: height,
//         hasEdema: hasEdema,
//         edemaSeverity: hasEdema ? edemaSeverity : 'Non spécifié',
//         admissionType: "Nouvelle Admission",
//         status: "Actif",
//         admissionDate: DateTime.now(),
//         isVaccinated: false,
//       );

//       ref.read(nutritionCasesProvider.notifier).addCase(newCase);
//       Navigator.pop(context); // Retour à l'écran précédent
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isTablet = screenWidth > 600;

//     return Consumer(
//       builder: (context, ref, _) => Scaffold(
//         appBar: AppBar(title: const Text("Formulaire d'Admission")),
//         body: Center(
//           child: Container(
//             width: isTablet ? 600 : double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Form(
//               key: _formKey,
//               child: ListView(
//                 children: [
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "Nom du Patient"),
//                     validator: (value) => value!.isEmpty ? 'Requis' : null,
//                     onChanged: (value) => patientName = value,
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "Âge (en mois)"),
//                     keyboardType: TextInputType.number,
//                     validator: (value) =>
//                         value!.isEmpty ? 'Requis' : null,
//                     onChanged: (value) => ageMonths = int.parse(value),
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "MUAC (mm)"),
//                     keyboardType: TextInputType.number,
//                     validator: (value) =>
//                         value!.isEmpty ? 'Requis' : null,
//                     onChanged: (value) => muac = double.parse(value),
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "Poids (kg)"),
//                     keyboardType: TextInputType.number,
//                     onChanged: (value) => weight = double.parse(value),
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "Taille (cm)"),
//                     keyboardType: TextInputType.number,
//                     onChanged: (value) => height = double.parse(value),
//                   ),
//                   SwitchListTile(
//                     title: const Text("Œdèmes présents"),
//                     value: hasEdema,
//                     onChanged: (value) {
//                       setState(() => hasEdema = value);
//                       if (!value) {
//                         edemaSeverity = 'Non spécifié';
//                       }
//                     },
//                   ),
//                   if (hasEdema)
//                     DropdownButtonFormField<String>(
//                       decoration:
//                           const InputDecoration(labelText: "Sévérité des œdèmes"),
//                       items: ['+', '++', '+++']
//                           .map((severity) => DropdownMenuItem(
//                                 value: severity,
//                                 child: Text(severity),
//                               ))
//                           .toList(),
//                       onChanged: (value) => setState(() {
//                         edemaSeverity = value!;
//                       }),
//                     ),
//                   SizedBox(height: isTablet ? 32 : 16),
//                   ElevatedButton(
//                     onPressed: () => submitForm(ref),
//                     child: const Text("Soumettre"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class MAMPage extends StatelessWidget {
  final double taille;
  final double poids;
  final String sexe;

  const MAMPage({super.key, required this.taille, required this.poids, required this.sexe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admis au MAM")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "L'enfant est admis au programme MAM.",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers traitement systématique
              },
              child: const Text("Traitement Systématique"),
            ),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers nutrition
              },
              child: const Text("Nutrition"),
            ),
          ],
        ),
      ),
    );
  }
}
