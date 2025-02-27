// // import 'package:flutter/material.dart';

// // class DepistagePage extends StatefulWidget {
// //   final String patientId; // ID du patient sélectionné

// //   const DepistagePage({super.key, required this.patientId});

// //   @override
// //   _DepistagePageState createState() => _DepistagePageState();
// // }

// // class _DepistagePageState extends State<DepistagePage> {
// //   final _formKey = GlobalKey<FormState>();
// //   double perimetreBraquial = 0.0;
// //   double poids = 0.0;
// //   double taille = 0.0;
// //   bool odeme = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Dépistage'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             children: [
// //               TextFormField(
// //                 decoration: const InputDecoration(labelText: 'Périmètre braquial (cm)'),
// //                 keyboardType: TextInputType.number,
// //                 onSaved: (value) => perimetreBraquial = double.parse(value!),
// //               ),
// //               TextFormField(
// //                 decoration: const InputDecoration(labelText: 'Poids (kg)'),
// //                 keyboardType: TextInputType.number,
// //                 onSaved: (value) => poids = double.parse(value!),
// //               ),
// //               TextFormField(
// //                 decoration: const InputDecoration(labelText: 'Taille (cm)'),
// //                 keyboardType: TextInputType.number,
// //                 onSaved: (value) => taille = double.parse(value!),
// //               ),
// //               SwitchListTile(
// //                 title: const Text('Présence d\'œdème'),
// //                 value: odeme,
// //                 onChanged: (value) => setState(() => odeme = value),
// //               ),
// //               const SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: () {
// //                   if (_formKey.currentState!.validate()) {
// //                     _formKey.currentState!.save();
// //                     // Sauvegarder dans SQLite et/ou Supabase
// //                   }
// //                 },
// //                 child: const Text('Enregistrer'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }



// import 'package:flutter/material.dart';
// import '../models/depistage.dart';
// import '../servises/database_helper.dart';

// class DepistageScreen extends StatefulWidget {
//   final String patientId;

//   const DepistageScreen({super.key, required this.patientId});

//   @override
//   _DepistageScreenState createState() => _DepistageScreenState();
// }

// class _DepistageScreenState extends State<DepistageScreen> {
//   final _formKey = GlobalKey<FormState>();
//   double perimetreBraquial = 0.0;
//   double poids = 0.0;
//   double taille = 0.0;
//   String oedeme = 'Absence';
//   String? tri;

//   void effectuerDepistage() {
//     setState(() {
//       tri = effectuerTri(perimetreBraquial, oedeme);
//     });
//   }

//   Future<void> enregistrerDepistage() async {
//     final depistage = Depistage(
//       id: UniqueKey().toString(),
//       patientId: widget.patientId,
//       perimetreBraquial: perimetreBraquial,
//       poids: poids,
//       taille: taille,
//       oedeme: oedeme,
//       tri: tri ?? 'Inconnu',
//     );

//     // Sauvegarde locale
//     await DatabaseHelper.instance.insertDepistage(depistage.toMap());

//     // Synchronisation avec Supabase
//     await SupabaseService().saveDepistage(depistage.toMap());

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Dépistage enregistré avec succès !')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Dépistage')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Périmètre braquial (mm)'),
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) => perimetreBraquial = double.parse(value),
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Poids (kg)'),
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) => poids = double.parse(value),
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Taille (cm)'),
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) => taille = double.parse(value),
//               ),
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(labelText: 'Œdème'),
//                 value: oedeme,
//                 items: ['Absence', '+', '++', '+++']
//                     .map((value) => DropdownMenuItem(
//                           value: value,
//                           child: Text(value),
//                         ))
//                     .toList(),
//                 onChanged: (value) => setState(() => oedeme = value!),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     effectuerDepistage();
//                   }
//                 },
//                 child: const Text('Effectuer le Tri'),
//               ),
//               if (tri != null)
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     'Résultat du tri : $tri',
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ElevatedButton(
//                 onPressed: enregistrerDepistage,
//                 child: const Text('Enregistrer'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// String effectuerTri(double pb, String oedeme) {
//   if (oedeme == '+++' || pb < 115) {
//     return 'CRENI';
//   } else if (pb >= 115 && pb < 125 && oedeme == 'Absence') {
//     return 'CRENAM';
//   } else if (pb >= 125) {
//     return 'Normal';
//   }
//   return 'Analyse supplémentaire requise';
// }

