import 'package:flutter/material.dart';
import 'package:pcima/screens/depistage/mesurePB.dart';
// import 'package:pcima/screens/depistage/taille.dart';

import '../models/patients.dart';
// import '../screen1.dart/depistage.dart';
import '../servises/database_helper.dart';

class PatientsListScreen extends StatefulWidget {
  const PatientsListScreen({super.key});

  @override
  _PatientsListScreenState createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  List<Patient> patients = [];

  @override
  void initState() {
    super.initState();
    
    _loadPatients();
  }

  SupabaseService sb = SupabaseService();
  Future<void> _loadPatients() async {
  // // final db = await DatabaseHelper.instance.database;
  // final result = sb.getAllPatients();
  // // await db.query('patients');
  // print('Résultats de la requête : $result'); // Vérifiez les données récupérées
  // setState(() {
  //   patients = result.map((p) => Patient.fromMap(p)).toList();
  // });
  try {
    final result = await sb.getAllPatients(); // Attente de la complétion du Future

    setState(() {
      patients = result;
      //.map((p) => Patient.fromMap(p)).toList();
      // patients = result as; // Utilisation de map après avoir attendu
      print("//// ${patients}");
    });
  } catch (e) {
    print('Erreur lors du chargement des patients : $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des Patients')),
      body: patients.isEmpty
          ? const Center(child: Text('Aucun patient enregistré.'))
          : ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                print(patient.toMap());
                return Card(
                  child: ListTile(
                    title: Text(patient.nomPrenom),
                    subtitle: Text(
                        '${patient.ageMois} - ${patient.localite}'),
                    trailing: patient.synchronise
                        ? const Icon(Icons.cloud_done, color: Colors.green)
                        : const Icon(Icons.cloud_off, color: Colors.red),
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  PBGuidePage(patient: patient,))); //PBMeasurementPage(patientId: patient.id,))); //DepistageScreen(patientId: patient.id,)));
                    },
                  ),
                );
              },
            ),
    );
  }
}
