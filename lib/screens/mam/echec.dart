import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EchecMAMPage extends StatefulWidget {
  final String idDepistage; // ID du dépistage en cours

  const EchecMAMPage({super.key, required this.idDepistage});

  @override
  State<EchecMAMPage> createState() => _EchecMAMPageState();
}

class _EchecMAMPageState extends State<EchecMAMPage> {
  final supabase = Supabase.instance.client;

  bool isLoading = true;
  bool echecMAM = false;
  String errorMessage = "";
  List<Map<String, dynamic>> poidsHistory = [];

  @override
  void initState() {
    super.initState();
    _verifierEchecMAM();
  }

  /// Vérifie si l'échec au traitement MAM est atteint
  Future<void> _verifierEchecMAM() async {
    try {
      // Vérifie si le traitement MAM est actif pour ce dépistage
      final mamResponse = await supabase
          .from('mam')
          .select('active')
          .eq('idDepistage', widget.idDepistage)
          .maybeSingle();

      if (mamResponse == null || mamResponse['active'] != true) {
        setState(() {
          errorMessage = "Le traitement MAM est inactif ou introuvable.";
          isLoading = false;
        });
        return;
      }

      // Récupère l'historique des dépistages de type suivi pour ce patient
      final depistageResponse = await supabase
          .from('depistage')
          .select('created_at, poids,taille,perimetreBraquial')
          .eq('mode', 'suivi') // Filtrer les suivis
          .eq('id', widget.idDepistage) // Associer au dépistage courant
          .order('created_at', ascending: true);

      if (depistageResponse.isEmpty) {
        throw Exception(
            "Erreur lors de la récupération des données de dépistage.");
      }

      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(depistageResponse);

      // Vérifie si deux poids consécutifs sont stationnaires ou en baisse
      bool echec = false;
      for (int i = 0; i < data.length - 1; i++) {
        double poids1 = data[i]['poids'] as double;
        double poids2 = data[i + 1]['poids'] as double;
        double pb1 = data[i]['perimetreBraquial'] as double;
        double pb2 = data[i + 1]['perimetreBraquial'] as double;
        double zScore1 = data[i]['zScore'] as double;
        double zScore2 = data[i + 1]['zScore'] as double;

        if (poids2 <= poids1) {
          echec = true;
          break;
        } else if (pb1 >= 125 && pb2 >= 125 && zScore1 >= -2 && zScore2 >= -3) {
          final response = await supabase
              .from('mas')
              .update({'typeSortie': "Normale"}).eq('id', widget.idDepistage);
          if (response.error == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text("Patient reussi le programme MAM avec succès.")),
            );
          }
        }
      }

      setState(() {
        echecMAM = echec;
        poidsHistory = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Erreur : ${e.toString()}";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vérification Échec MAM"),
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
                        "Historique des Poids (Dépistages Suivis)",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: poidsHistory.length,
                        itemBuilder: (context, index) {
                          final suivi = poidsHistory[index];
                          return ListTile(
                            title: Text(
                              "Date : ${DateTime.parse(suivi['created_at']).toLocal()}",
                            ),
                            subtitle: Text("Poids : ${suivi['poids']} kg"),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        echecMAM
                            ? "Échec du traitement MAM : Poids stationnaire ou en baisse sur 2 suivis consécutifs."
                            : "Pas d'échec détecté.",
                        style: TextStyle(
                          fontSize: 18,
                          color: echecMAM ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
