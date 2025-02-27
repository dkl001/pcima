import 'package:flutter/material.dart';
import 'package:pcima/models/patients.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PoidsPage extends StatelessWidget {
  final Patient patient;
  final String idDepistage;
  final double taille;

  const PoidsPage({
    super.key,
    required this.patient,
    required this.idDepistage, required this.taille,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController weightController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mesure du Poids"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre principal
            _buildTitle("Prendre le poids de ${patient.nomPrenom}"),

            // Instructions pour la prise du poids
            const SizedBox(height: 20),
            _buildStepCard(
              title: "Instructions pour la prise du poids",
              description:
                  "1. Utilisez une balance Salter de 25 kg graduée à 0,100 kg ou une balance électronique précise à 0,100 kg.\n"
                  "2. Ajustez la balance à 0 avant chaque pesée.\n"
                  "3. Placez l'enfant dans une bassine en plastique attachée solidement avec des cordes.\n"
                  "4. Assurez-vous que la bassine est proche du sol pour la sécurité.\n"
                  "5. Quand l’enfant ne bouge plus, lisez le poids à 100 g près, en positionnant l’aiguille au niveau des yeux.\n"
                  "6. Vérifiez la balance chaque jour avec un poids standard.",
              imagePath: 'assets/images/mesure_poids.png',
            ),

            const SizedBox(height: 20),

            // Champ de saisie pour le poids
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Entrez le poids en kg",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // Bouton Continuer
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _onContinue(context, weightController);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Continuer"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Affiche un titre principal
  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Génère une carte avec une étape
  Widget _buildStepCard({
    required String title,
    required String description,
    String? imagePath,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
            if (imagePath != null) ...[
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  imagePath,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Action lors de la validation
  Future<void> _onContinue(
      BuildContext context, TextEditingController weightController) async {
    final poidsString = weightController.text;
    final poids = double.tryParse(poidsString);

    if (poids == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez entrer un poids valide."),
        ),
      );
      return;
    }

    try {
      // Mettre à jour la table 'depistage' avec le poids
      final supabase = Supabase.instance.client;
      final response = await supabase.from('depistage').update({
        'poids': poids,
      }).eq('id', idDepistage);

      if (response.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Poids enregistré avec succès.")),
        );

        // Rediriger vers la page suivante
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const Placeholder(), // Remplacez par la page suivante
          ),
        );
      } else {
        throw response.error!;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors de l'enregistrement : ${e.toString()}"),
        ),
      );
    }
  }
}
