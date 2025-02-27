import 'package:flutter/material.dart';

class AdmissionCriteriaScreen extends StatelessWidget {
  const AdmissionCriteriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    final admissionCriteria = [
      {
        "category": "Enfants (6-59 mois)",
        "criteria": [
          "MUAC >= 115 mm et < 125 mm, absence d’œdèmes",
          "Poids pour Taille >= -3 Z-score et < -2 Z-score, absence d’œdèmes",
        ],
      },
      {
        "category": "Femmes enceintes",
        "criteria": ["MUAC < 230 mm"],
      },
      {
        "category": "Femmes allaitantes",
        "criteria": [
          "Enfant de moins de 6 mois et MUAC < 230 mm",
        ],
      },
      {
        "category": "Cas spéciaux",
        "criteria": [
          "Réadmission après abandon (moins de 2 mois)",
          "Transfert interne depuis un autre centre",
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Critères d\'Admission')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isTablet
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: admissionCriteria.length,
                itemBuilder: (context, index) {
                  final category = admissionCriteria[index];
                  return _buildCriteriaCard(category);
                },
              )
            : ListView.builder(
                itemCount: admissionCriteria.length,
                itemBuilder: (context, index) {
                  final category = admissionCriteria[index];
                  return _buildCriteriaCard(category);
                },
              ),
      ),
    );
  }

  Widget _buildCriteriaCard(Map<String, dynamic> category) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category['category'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...category['criteria'].map<Widget>((criteria) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text("- $criteria"),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
