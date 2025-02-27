// import 'package:flutter/material.dart';

// import '../../models/patients.dart';
// import '../../servises/database_helper.dart';

// class AddPatientScreen extends StatefulWidget {
//   const AddPatientScreen({super.key});

//   @override
//   _AddPatientScreenState createState() => _AddPatientScreenState();
// }

// class _AddPatientScreenState extends State<AddPatientScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String nom = '';
//   String categorie = 'Enfant';
//   int? ageMois;
//   String localite = '';
//   String centreSante = '';

//   Future<void> _savePatient() async {
//   final patient = Patient(
//     // Supprimez l'attribution de `id` ici
//     id: 'll',
//     nomPrenom: nom,
//     categorie: categorie,
//     ageMois: categorie == 'Enfant' ? ageMois : null,
//     localite: localite,
//     centreSante: centreSante,
//   );

//   try {
//     await SupabaseService().addPatient(patient);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Patient ajouté avec succès !')),
//     );
//     Navigator.pop(context);
//   } catch (e) {
//     print('Erreur : $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Erreur : $e')),
//     );
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Ajouter un Patient')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Nom'),
//                 onChanged: (value) => nom = value,
//                 validator: (value) => value!.isEmpty ? 'Requis' : null,
//               ),
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(labelText: 'Catégorie'),
//                 value: categorie,
//                 onChanged: (value) => setState(() => categorie = value!),
//                 items: ['Enfant', 'Femme enceinte', 'Femme allaitante']
//                     .map((cat) => DropdownMenuItem(
//                           value: cat,
//                           child: Text(cat),
//                         ))
//                     .toList(),
//               ),
//               if (categorie == 'Enfant')
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: 'Âge (en mois)'),
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) => ageMois = int.tryParse(value),
//                 ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Localité'),
//                 onChanged: (value) => localite = value,
//                 validator: (value) => value!.isEmpty ? 'Requis' : null,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Centre de Santé'),
//                 onChanged: (value) => centreSante = value,
//                 validator: (value) => value!.isEmpty ? 'Requis' : null,
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     _savePatient();
//                   }
//                 },
//                 child: const Text('Enregistrer'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
