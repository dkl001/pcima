import 'package:flutter/material.dart';
// import 'package:pcima/models/depistage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../eval_anje.dart';
import '../../models/patients.dart';
import '../../models/z_score.dart';
import 'normale.dart';

class ZScorePage extends StatefulWidget {
  
  final Patient patient;
  final String depistageId;
  final dynamic taille; // Taille fournie
  final dynamic poids; // Poids fourni

  const ZScorePage({
    super.key,
    required this.patient,
    required this.depistageId,
    this.taille,
    this.poids,
  });

  @override
  _ZScorePageState createState() => _ZScorePageState();
}

class _ZScorePageState extends State<ZScorePage> {
  final supabase = Supabase.instance.client;
  // final List<Map<String, dynamic>> tableOMS = tableOMS;

  /// Calcul et gestion du Z-Score
  Future<void> _calculerZScore() async {
    try {
      final double? taille = widget.taille;
      final double? poids = widget.poids;

      if (taille == null || poids == null || taille <= 0 || poids <= 0) {
        _showError("Données invalides pour la taille ou le poids.");
        return;
      }

      // Calcul du Z-score à l'aide du modèle
      ZScoreCalculator calculator = ZScoreCalculator();
      String zScoreResult = calculator.calculateZScore(
        taille: taille,
        poids: poids,
        sexe: widget.patient.sexe,
      );

      // Gérer le résultat
      switch (zScoreResult.substring(0, 3)) {
        case "MAM":
          await _insertInTable(
            tri: 'CRENAM',
            zScore: zScoreResult, table: 'mam',
            // additionalFields: {'status': 'active'},
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EvaluationAnjeDpeForm(
                 patient: widget.patient , type: "MAM", depistageId: widget.depistageId,
              ),
            ),
          );
          break;

        case "MAS":
          await _insertInTable(
            tri: 'CRENAS',
            zScore: zScoreResult, table: 'mas',
            // additionalFields: {'status': 'active'},
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EvaluationAnjeDpeForm(
                 patient: widget.patient , type: "MAS", depistageId: widget.depistageId,
              ),
            ),
          );
          break;

        case "Normal":
          await _insertInTable(
            tri: 'NORMAL',
            zScore: zScoreResult, table: '',
            // additionalFields: {'status': 'active'},
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NormalResultPage(),
            ),
          );
          break;

        default:
          _showError("Erreur lors du calcul du Z-score.");
      }
    } catch (e) {
      _showError("Une erreur est survenue : ${e.toString()}.");
    }
  }

  /// Insère dans la table `mam` ou `mas`
  Future<void> _insertInTable({
    required String tri,
    // Map<String, dynamic>? additionalFields,
    required String zScore,
    required String table,
  }) async {
    try {
      // final Map<String, dynamic> data = {
      //   'patient_id': widget.patient.id,
      //   'taille': widget.taille,
      //   'poids': widget.poids,
      //   'date': DateTime.now().toIso8601String(),
      //   ...?additionalFields,
      // };
      final response = await supabase
          .from('depistage')
          .update({'z-score': zScore.substring(3, 5), 'tri': tri}).eq(
              'id', widget.depistageId);
      // final response = await supabase.from('depistage').insert(data);

      if (response.error != null) {
        throw Exception(
            "Erreur lors de l'insertion dans la tabe depistage : ${response.error!.message}");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Données ajoutées à la table depistage.")),
      );

      if (tri == "CRENAM") { 
        table = "mam";
      }else if (tri == "CRENAS") {
        table = "mas";
      }
      final masResponse = await supabase.from(table).insert({
          'patient_id': widget.patient.id,
          'depistage_id': widget.depistageId,
          'date': DateTime.now().toIso8601String(),
        });

        if (masResponse.error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Patient ajouté à MAS avec succès.")),
          );
        } else {
          throw masResponse.error!;
        }
      } catch (e) {
      _showError("Erreur lors de l'insertion : ${e.toString()}");
    }
  }

  /// Affiche un message d'erreur
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calcul du Z-Score")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichage de la taille
            Text(
              "Taille : ${widget.taille?.toStringAsFixed(1)} cm",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),

            // Affichage du poids
            Text(
              "Poids : ${widget.poids?.toStringAsFixed(1)} kg",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),

            // Affichage du sexe
            Text(
              "Sexe : ${widget.patient.sexe == 'garcons' ? 'Garçon' : 'Fille'}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Bouton pour calculer le Z-Score
            ElevatedButton(
              onPressed: _calculerZScore,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Calculer Z-Score"),
            ),
          ],
        ),
      ),
    );
  }
}
