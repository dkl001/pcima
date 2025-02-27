import 'package:flutter/material.dart';
import 'package:pcima/models/patients.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/anje/aliment.dart';
import 'models/anje/evaluation.dart';
import 'models/anje/liquide.dart';


/// Formulaire Évaluation ANJE/DPE
class EvaluationAnjeDpeForm extends StatefulWidget {
  final Patient patient; final String type; final String depistageId;

  const EvaluationAnjeDpeForm({super.key, required this.patient, required this.type, required this.depistageId});

  @override
  State<EvaluationAnjeDpeForm> createState() => _EvaluationAnjeDpeFormState();
}

class _EvaluationAnjeDpeFormState extends State<EvaluationAnjeDpeForm> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  // Variables pour stocker les données du formulaire
  // String? nomAccompagnant;
  // String? observationMere;
  // String? courbeCroissance;
  // String? allaitementDifficultes;
  // List<Aliment> alimentsDetails = [];
  // List<Liquide> liquidesDetails = [];
  // String? autresDifficultes;
  // String? aideEnfant;
  // List<String> pratiquesHygiene = [];
  late EvaluationAnje evaluation;

  @override
  void initState() {
    super.initState();
    evaluation = EvaluationAnje(
      patientId: widget.patient.id,
      nomAccompagnant: '',
      alimentsDetails: [],
      liquidesDetails: [],
      pratiquesHygiene: [], depistageId: widget.depistageId,
    );
  }

  // Méthode pour sauvegarder les données dans Supabase
    Future<void> sauvegarderDonnees() async {
    try {
      final response = await supabase.from('anjeForm').insert(evaluation.toJson());

      if (response.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Données sauvegardées avec succès.")),
        );
      } else {
        throw response.error!;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la sauvegarde : $e")),
      );
    }
  }

  // Ajouter une catégorie (aliment ou liquide)
  void ajouterCategorie(String type) {
    if (type == 'aliment') {
      evaluation.alimentsDetails.add(Aliment(type: '', frequence: '', quantite: '', texture: ''));
    } else if (type == 'liquide') {
      evaluation.liquidesDetails.add(Liquide(type: '', frequence: '', quantite: '', biberon: 'Non'));
    }
    setState(() {});
  }

  // Supprimer une catégorie (aliment ou liquide)
  void supprimerCategorie(String type, int index) {
    if (type == 'aliment') {
      evaluation.alimentsDetails.removeAt(index);
    } else if (type == 'liquide') {
      evaluation.liquidesDetails.removeAt(index);
    }
    setState(() {});
  }

  // Méthode pour confirmer la soumission
  void confirmerSoumission() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmer la soumission"),
          content: const Text("Êtes-vous sûr de vouloir soumettre les données ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                sauvegarderDonnees();
              },
              child: const Text("Confirmer"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Évaluation ANJE/DPE Pour Enfant du ${widget.type}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom de l'accompagnant
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nom de la mère/gardienne'),
                  validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
                  onSaved: (value) => evaluation.nomAccompagnant = value!,
                ),

                // Observation de la mère
                TextFormField(
                  decoration: const InputDecoration(labelText: "Observation de la mère/gardienne"),
                  onSaved: (value) => evaluation.observationMere = value,
                ),

                // Courbe de croissance
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Courbe de croissance"),
                  items: const [
                    DropdownMenuItem(value: 'Oui', child: Text('Oui')),
                    DropdownMenuItem(value: 'Non', child: Text('Non')),
                    DropdownMenuItem(value: 'Statique', child: Text('Statique')),
                  ],
                  onChanged: (value) => evaluation.courbeCroissance = value,
                ),

                // Difficultés liées à l'allaitement
                TextFormField(
                  decoration: const InputDecoration(labelText: "Difficultés liées à l’allaitement"),
                  onSaved: (value) => evaluation.allaitementDifficultes = value,
                ),

                // Aliments de complément
                const SizedBox(height: 20),
                const Text("Aliments de complément", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...evaluation.alimentsDetails.asMap().entries.map((entry) {
                  int index = entry.key;
                  Aliment aliment = entry.value;
                  return Card(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: "Type d’aliment ${index + 1}"),
                          onChanged: (value) => aliment.type = value,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: "Fréquence (fois/jour)"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => aliment.frequence = value,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: "Quantité (250 mL)"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => aliment.quantite = value,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: "Texture"),
                          onChanged: (value) => aliment.texture = value,
                        ),
                        TextButton(
                          onPressed: () => supprimerCategorie('aliment', index),
                          child: const Text("Supprimer"),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: () => ajouterCategorie('aliment'),
                  child: const Text("Ajouter un aliment"),
                ),

                // Liquides
                const SizedBox(height: 20),
                const Text("Liquides", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...evaluation.liquidesDetails.asMap().entries.map((entry) {
                  int index = entry.key;
                  Liquide liquide = entry.value;
                  return Card(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: "Type de liquide ${index + 1}"),
                          onChanged: (value) => liquide.type = value,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: "Fréquence (fois/jour)"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => liquide.frequence = value,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: "Quantité (250 mL)"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => liquide.quantite = value,
                        ),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: "Utilisation du biberon"),
                          items: const [
                            DropdownMenuItem(value: 'Oui', child: Text('Oui')),
                            DropdownMenuItem(value: 'Non', child: Text('Non')),
                          ],
                          onChanged: (value) => liquide.biberon = value ?? 'Non',
                        ),
                        TextButton(
                          onPressed: () => supprimerCategorie('liquide', index),
                          child: const Text("Supprimer"),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: () => ajouterCategorie('liquide'),
                  child: const Text("Ajouter un liquide"),
                ),

                // Bouton Soumettre
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      confirmerSoumission();
                    }
                  },
                  child: const Text("Soumettre"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
