
import 'package:flutter/material.dart';
import 'package:pcima/models/depistage.dart';

import '../../models/patients.dart';

class TestAppetitPage extends StatefulWidget {
  final Patient patient;
  final Depistage depistage; // Poids directement fourni par la classe Patient

  const TestAppetitPage({super.key, required this.patient, required this.depistage});

  @override
  State<TestAppetitPage> createState() => _TestAppetitPageState();
}

class _TestAppetitPageState extends State<TestAppetitPage> {
  late final TextEditingController _quantiteController = TextEditingController();

  TestMode _selectedMode = TestMode.withoutScale;
  AtpeType _selectedAtpeType = AtpeType.sachetPaste;

  String? _resultat;
  String? _recommandation;

  @override
  void dispose() {
    _quantiteController.dispose();
    super.dispose();
  }

  /// Validation des données avant traitement
  bool _validateInput() {
    final quantite = _quantiteController.text.trim();

    if (quantite.isEmpty) {
      _showError("Veuillez entrer la quantité consommée.");
      return false;
    }

    try {
      final quantiteValue = double.parse(quantite);
      if (quantiteValue <= 0) {
        _showError("Veuillez entrer une valeur positive.");
        return false;
      }

      return true;
    } on FormatException {
      _showError("Veuillez entrer une quantité valide.");
      return false;
    }
  }

  /// Vérification du résultat du test d'appétit
  void _verifierTestAppetit() {
    if (!_validateInput()) return;

    final poids = widget.depistage.poids;
    final quantite = double.parse(_quantiteController.text.trim());

    final evaluation = _evaluerQuantite(poids, quantite);

    setState(() {
      _resultat = evaluation;
      _recommandation = evaluation.contains("Échec")
          ? "Transférez l'enfant au CRENI pour une évaluation complète."
          : "L'enfant peut continuer en traitement ambulatoire.";
    });
  }

  /// Évaluation de la quantité consommée
  String _evaluerQuantite(double poids, double quantite) {
    final weightRanges = {
      (3.0, 3.9): (15.0, 20.0),
      (4.0, 5.9): (20.0, 25.0),
      (6.0, 6.9): (20.0, 30.0),
      (7.0, 7.9): (25.0, 35.0),
      (8.0, 8.9): (30.0, 40.0),
      (9.0, 9.9): (30.0, 45.0),
      (10.0, 11.9): (35.0, 50.0),
      (12.0, 14.9): (40.0, 60.0),
      (15.0, 24.9): (55.0, 75.0),
      (25.0, 39.0): (65.0, 90.0),
      (40.0, 60.0): (70.0, 100.0),
    };

    if (poids < 3 || poids > 60) {
      return "Poids hors plage supportée.";
    }

    final matchingRange = weightRanges.entries.firstWhere(
      (range) => poids >= range.key.$1 && poids <= range.key.$2,
      orElse: () => throw Exception("Aucune plage de poids correspondante"),
    );

    return _evaluerNiveau(quantite, matchingRange.value.$1, matchingRange.value.$2);
  }

  String _evaluerNiveau(double quantite, double mediocre, double modere) {
    if (quantite < mediocre) {
      return "Échec (Médiocre)";
    } else if (quantite >= mediocre && quantite <= modere) {
      return "Réussi (Modéré)";
    } else {
      return "Réussi (Bon)";
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Réinitialisation du formulaire
  void _resetForm() {
    setState(() {
      _quantiteController.clear();
      _resultat = null;
      _recommandation = null;
      _selectedMode = TestMode.withoutScale;
      _selectedAtpeType = AtpeType.sachetPaste;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test d'Appétit"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Réinitialiser le formulaire',
            onPressed: _resetForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Instructions pour le Test d'Appétit",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "- Effectuez le test dans un endroit calme.\n"
              "- Encouragez l'enfant à consommer l'ATPE.\n"
              "- Offrez de l'eau pendant le test.\n",
              style: TextStyle(fontSize: 16),
            ),
            const Divider(),
            const SizedBox(height: 10),

            // Affichage du poids de l'enfant
            _buildStaticInfoField(
              label: "Poids de l'enfant",
              value: "${widget.depistage.poids.toStringAsFixed(1)} kg",
            ),

            const SizedBox(height: 16),

            // Sélection du mode de test
            _buildDropdownField<TestMode>(
              label: "Mode de Test",
              value: _selectedMode,
              items: TestMode.values,
              getLabel: (mode) => mode.label,
              onChanged: (value) => setState(() => _selectedMode = value!),
            ),

            const SizedBox(height: 16),

            // Sélection du type d'ATPE
            _buildDropdownField<AtpeType>(
              label: "Type d'ATPE",
              value: _selectedAtpeType,
              items: AtpeType.values,
              getLabel: (type) => type.label,
              onChanged: (value) => setState(() => _selectedAtpeType = value!),
            ),

            const SizedBox(height: 16),

            // Champ pour la quantité consommée
            _buildInputField(
              controller: _quantiteController,
              label: "Quantité consommée (grammes)",
              icon: Icons.local_dining,
            ),

            const SizedBox(height: 20),

            // Bouton pour évaluer
            ElevatedButton.icon(
              onPressed: _verifierTestAppetit,
              icon: const Icon(Icons.check_circle),
              label: const Text("Évaluer le Test"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Colors.teal,
              ),
            ),

            const SizedBox(height: 20),

            if (_resultat != null) _buildResultWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticInfoField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) getLabel,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(getLabel(item)));
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.teal.withOpacity(0.1),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.teal.withOpacity(0.1),
      ),
    );
  }

  Widget _buildResultWidget() {
    final isFailure = _resultat!.contains("Échec");
    return Card(
      color: isFailure ? Colors.red.withOpacity(0.2) : Colors.green.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _resultat!,
              style: TextStyle(
                fontSize: 18,
                color: isFailure ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _recommandation ?? "",
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

enum TestMode { withoutScale, withScale }
extension TestModeExtension on TestMode {
  String get label => this == TestMode.withoutScale ? 'Sans Balance' : 'Avec Balance';
}

enum AtpeType { sachetPaste

, potPaste }
extension AtpeTypeExtension on AtpeType {
  String get label => this == AtpeType.sachetPaste ? 'Pâte en sachet' : 'Pâte en pot';
}
