import 'package:flutter/material.dart';
import 'package:pcima/models/patients.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TraitementSystematiquePage extends StatefulWidget {
  final Patient patient; // Identifiant unique de l'enfant dans la base

  const TraitementSystematiquePage({super.key, required this.patient});

  @override
  _TraitementSystematiquePageState createState() =>
      _TraitementSystematiquePageState();
}

class _TraitementSystematiquePageState
    extends State<TraitementSystematiquePage> {
  final supabase = Supabase.instance.client;

  double? age; // Âge en mois
  double? poids; // Poids en kg
  String? medicament; // Médicament sélectionné
  String? resultat; // Résultat du traitement

  bool isLoading = true; // Indicateur de chargement

  /// Récupère les données de l'enfant depuis Supabase
  Future<void> fetchEnfantData() async {
    try {
      final response = await supabase
          .from('enfants') // Remplacez 'enfants' par le nom de votre table
          .select('age, poids')
          .eq('id', widget.patient.id)
          .single();

      if (response.isEmpty) {
        throw Exception("Aucune donnée trouvée pour l'enfant.");
      }

      setState(() {
        age = (response['age'] as num?)?.toDouble();
        poids = (response['poids'] as num?)?.toDouble();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        resultat = "Erreur lors du chargement des données : $e";
        isLoading = false;
      });
    }
  }

  /// Fonction de calcul du traitement
  void calculerTraitement() {
    if (age == null || poids == null) {
      setState(() {
        resultat = "Les données de l'enfant sont manquantes.";
      });
      return;
    }

    if (age! < 12 || poids! <= 8) {
      setState(() {
        resultat = "Pas de déparasitage nécessaire pour les enfants de 6 à 11 mois ou ≤ 8 kg.";
      });
      return;
    }

    if (medicament == null) {
      setState(() {
        resultat = "Veuillez sélectionner un médicament disponible.";
      });
      return;
    }

    if (medicament == "Mébendazole 500 mg") {
      setState(() {
        resultat =
            "Donnez 1 comprimé de 500 mg à une prise unique pour l'enfant.";
      });
    } else if (medicament == "Mébendazole 100 mg") {
      setState(() {
        resultat =
            "Donnez 1 comprimé de 100 mg deux fois par jour, pendant 3 jours.";
      });
    } else if (medicament == "Albendazole") {
      if (age! >= 12 && age! <= 23) {
        setState(() {
          resultat =
              "Pour un enfant de 12-23 mois :\n- 1/2 comprimé de 400 mg à une prise unique\nOU\n- 1 comprimé de 200 mg à une prise unique.";
        });
      } else if (age! >= 24 && age! <= 59) {
        setState(() {
          resultat =
              "Pour un enfant de 24-59 mois :\n- 1 comprimé de 400 mg à une prise unique\nOU\n- 2 comprimés de 200 mg à une prise unique.";
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEnfantData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Traitement Médical Systématique"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Données de l'enfant",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text("Âge : ${age?.toStringAsFixed(1)} mois"),
                    Text("Poids : ${poids?.toStringAsFixed(1)} kg"),
                    const SizedBox(height: 20),

                    // Sélection du médicament
                    DropdownButtonFormField<String>(
                      value: medicament,
                      items: const [
                        DropdownMenuItem(
                          value: "Mébendazole 500 mg",
                          child: Text("Mébendazole 500 mg"),
                        ),
                        DropdownMenuItem(
                          value: "Mébendazole 100 mg",
                          child: Text("Mébendazole 100 mg"),
                        ),
                        DropdownMenuItem(
                          value: "Albendazole",
                          child: Text("Albendazole"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          medicament = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Médicament disponible",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Bouton pour calculer le traitement
                    ElevatedButton(
                      onPressed: calculerTraitement,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text("Calculer le Traitement"),
                    ),
                    const SizedBox(height: 20),

                    // Résultat du traitement
                    if (resultat != null)
                      Text(
                        resultat!,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.blue),
                      ),
                    const SizedBox(height: 20),

                    // Boutons pour redirection
                    const Text(
                      "Autres Actions",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Rediriger vers Nutrition
                      },
                      child: const Text("Nutrition"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Rediriger vers Suivi
                      },
                      child: const Text("Suivi"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
