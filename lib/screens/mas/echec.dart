import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EchecCRENASPage extends StatefulWidget {
  final String idDepistage; // ID du dépistage en cours

  const EchecCRENASPage({super.key, required this.idDepistage});

  @override
  State<EchecCRENASPage> createState() => _EchecCRENASPageState();
}

class _EchecCRENASPageState extends State<EchecCRENASPage> {
  final supabase = Supabase.instance.client;

  bool isLoading = true;
  bool echecCRENAS = false;
  bool sortieCRENAS = false;
  String errorMessage = "";
  List<Map<String, dynamic>> historiqueSuivis = [];

  @override
  void initState() {
    super.initState();
    _verifierEchecEtSortieCRENAS();
  }

  /// Vérifie les critères d'échec et de sortie pour le traitement CRENAS
  Future<void> _verifierEchecEtSortieCRENAS() async {
    try {
      // Récupère l'historique des dépistages de type suivi pour ce patient
      final response = await supabase
          .from('depistage')
          .select('created_at, poids, oedeme, perimetreBraquial, zScore')
          .eq('id', widget.idDepistage)
          .order('created_at', ascending: true);

      if (response.isEmpty) {
        throw Exception("Erreur lors de la récupération des données de dépistage.");
      }

      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(response);

      bool echec = false;
      bool sortie = false;

      for (int i = 0; i < data.length; i++) {
        final poidsActuel = data[i]['poids'] as double;
        final oedeme = data[i]['oedeme'] as bool;
        final pb = data[i]['perimetreBraquial'] as double;
        final zScore = data[i]['zScore'] as double;
        final createdAt = DateTime.parse(data[i]['created_at']);

        // Vérifie critères d'échec
        if (i > 0) {
          final poidsPrecedent = data[i - 1]['poids'] as double;
          final datePrecedente = DateTime.parse(data[i - 1]['created_at']);

          // Perte ou stagnation de poids
          if (poidsActuel <= poidsPrecedent &&
              createdAt.difference(datePrecedente).inDays >= 14) {
            echec = true;
            break;
          }

          // Absence d'amorce de fonte des œdèmes ou persistance (14 ou 21 jours)
          if (oedeme && 
              createdAt.difference(DateTime.parse(data.first['created_at'])).inDays >= 14) {
            echec = true;
            break;
          }
        }

        // Vérifie critères de sortie
        if (i > 1) {
          final pbPrecedent = data[i - 1]['perimetreBraquial'] as double;
          final zScorePrecedent = data[i - 1]['zScore'] as double;
          final oedemePrecedent = data[i - 1]['oedeme'] as bool;

          if (pb >= 125 &&
              pbPrecedent >= 125 &&
              zScore >= -2 &&
              zScorePrecedent >= -2 &&
              !oedeme &&
              !oedemePrecedent) {
            sortie = true;
            break;
          }
        }
      }

      setState(() {
        echecCRENAS = echec;
        sortieCRENAS = sortie;
        historiqueSuivis = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Erreur : ${e.toString()}";
        isLoading = false;
      });
    }
  }

  /// Référer le patient au CRENI en cas d'échec
  Future<void> _transfererAuCRENI() async {
    try {
      final response = await supabase
          .from('creni')
          .insert({
            'idDepistage': widget.idDepistage,
            'raison': 'Échec au traitement CRENAS'
          });

      if (response.error != null) {
        throw Exception("Erreur lors du transfert au CRENI.");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Patient transféré au CRENI avec succès.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Échec et sortie CRENAS"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Historique des suivis (CRENAS)",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: historiqueSuivis.length,
                        itemBuilder: (context, index) {
                          final suivi = historiqueSuivis[index];
                          return ListTile(
                            title: Text(
                              "Date : ${DateTime.parse(suivi['created_at']).toLocal()}",
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Poids : ${suivi['poids']} kg"),
                                Text("Œdème : ${suivi['oedeme'] ? 'Oui' : 'Non'}"),
                                Text("PB : ${suivi['perimetreBraquial']} mm"),
                                Text("Z-Score : ${suivi['zScore']}"),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        echecCRENAS
                            ? "Échec détecté : Transférez le patient au CRENI."
                            : "Pas d'échec détecté.",
                        style: TextStyle(
                          fontSize: 18,
                          color: echecCRENAS ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (echecCRENAS)
                        ElevatedButton(
                          onPressed: _transfererAuCRENI,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text("Transférer au CRENI"),
                        ),
                      const SizedBox(height: 20),
                      Text(
                        sortieCRENAS
                            ? "Critères de sortie atteints : Le patient peut quitter le programme CRENAS."
                            : "Critères de sortie non atteints.",
                        style: TextStyle(
                          fontSize: 18,
                          color: sortieCRENAS ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
