import 'package:flutter/material.dart';
// import 'package:pcima/screens/mam/add.dart';
import 'package:pcima/screens/list_patient.dart';
import 'package:pcima/screens/protocole.dart';

import 'depistage/normale.dart';
import 'diagnostic.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PCIMA - Accueil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFeatureCard(
                context,
                "Protocole PCIMA",
                "Consultez les lignes directrices",
                Icons.book,
                Colors.blue,
                () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  ProtocoleScreen()),
                    ) //Navigator.pushNamed(context, '/protocole'),
                ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              "Outils de Diagnostic",
              "Calculez et diagnostiquez rapidement",
              Icons.health_and_safety,
              Colors.green,
              () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  const DiagnosticScreen()),
                    ) //Navigator.pushNamed(context, '/diagnostic'),
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              "Formulaires Ajout Patients",
              "Saisissez les données des patients",
              Icons.person,
              Colors.orange,
              () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  const NormalResultPage()), //AddPatientScreen()),
                    )//Navigator.pushNamed(context, '/formulaires'),
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              "Liste Patients",
              "Consulter la liste des Patients",
              Icons.list_alt,
              Colors.red,
              () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  const PatientsListScreen()),
                    )//Navigator.pushNamed(context, '/formulaires'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String subtitle,
      IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: ListTile(
          leading: Icon(icon, color: color, size: 40),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
          trailing: Icon(Icons.arrow_forward_ios, color: color),
        ),
      ),
    );
  }
}
