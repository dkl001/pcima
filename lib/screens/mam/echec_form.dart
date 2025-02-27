// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/nutrition.dart';
// import '../provider/nutrition.dart';

// class FailureManagementScreen extends ConsumerWidget {
//   const FailureManagementScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final patients = ref.watch(nutritionCasesProvider);

//     final failedCases = patients
//         .where((patient) => patient.hasFailedTreatment && patient.status != 'Guéri')
//         .toList();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Gestion des Échecs de Traitement')),
//       body: failedCases.isEmpty
//           ? const Center(child: Text('Aucun échec de traitement enregistré.'))
//           : ListView.builder(
//               itemCount: failedCases.length,
//               itemBuilder: (context, index) {
//                 final patient = failedCases[index];
//                 return Card(
//                   margin: const EdgeInsets.all(8.0),
//                   child: ListTile(
//                     title: Text(patient.patientName),
//                     subtitle: Text("Cause de l'échec : ${patient.failureCause}"),
//                     trailing: const Icon(Icons.warning),
//                     onTap: () {
//                       // Logique pour gérer les échecs
//                       _showFailureDialog(context, patient);
//                     },
//                   ),
//                 );
//               },
//             ),
//     );
//   }

//   void _showFailureDialog(BuildContext context, NutritionCase patient) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Analyse de l'échec de traitement"),
//         content: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Nom du patient : ${patient.patientName}"),
//             Text("Cause de l'échec : ${patient.failureCause}"),
//             // Autres informations à afficher
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../../models/echec.dart';
import '../../servises/db.dart';

class FailureManagementScreen extends StatefulWidget {
  final int patientId;
  final String patientName;

  const FailureManagementScreen({super.key, required this.patientId, required this.patientName});

  @override
  _FailureManagementScreenState createState() =>
      _FailureManagementScreenState();
}

class _FailureManagementScreenState extends State<FailureManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  String failureCause = '';
  String actionsTaken = '';
  List<FailureRecord> failureRecords = [];

  @override
  void initState() {
    super.initState();
    loadFailureRecords();
  }

  Future<void> loadFailureRecords() async {
    final db = await DatabaseHelper().database;
    final records = await db.query(
      'failure_records',
      where: 'patientId = ?',
      whereArgs: [widget.patientId],
    );
    setState(() {
      failureRecords = records.map((r) => FailureRecord.fromMap(r)).toList();
    });
  }

  Future<void> submitFailureAnalysis() async {
    if (_formKey.currentState!.validate()) {
      final db = await DatabaseHelper().database;
      final newRecord = FailureRecord(
        id: 0,
        patientId: widget.patientId,
        cause: failureCause,
        actions: actionsTaken,
        dateRecorded: DateTime.now(),
      );

      await db.insert('failure_records', newRecord.toMap());
      loadFailureRecords();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Analyse d\'échec enregistrée avec succès')),
      );
      setState(() {
        failureCause = '';
        actionsTaken = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Échecs de Traitement : ${widget.patientName}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Cause"),
                    items: [
                      'Pathologies sous-jacentes',
                      'Substitution d’un enfant',
                      'Partage ou mauvaise préparation de la ration',
                      'Problème socio-économique',
                    ]
                        .map((cause) => DropdownMenuItem(
                              value: cause,
                              child: Text(cause),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => failureCause = value!),
                    validator: (value) =>
                        value == null ? 'Veuillez sélectionner une cause' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Actions entreprises (facultatif)"),
                    maxLines: 4,
                    onChanged: (value) => actionsTaken = value,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: submitFailureAnalysis,
                    child: const Text("Enregistrer"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: failureRecords.length,
                itemBuilder: (context, index) {
                  final record = failureRecords[index];
                  return Card(
                    child: ListTile(
                      title: Text(record.cause),
                      subtitle: Text(record.actions.isEmpty
                          ? "Aucune action spécifiée"
                          : record.actions),
                      trailing: Text(record.dateRecorded.toLocal().toString()),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
