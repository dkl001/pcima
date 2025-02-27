import 'package:flutter/material.dart';

class TraitementNutritionnelPage extends StatefulWidget {
  final double poidsEnfant; // Le poids de l'enfant est fourni directement

  const TraitementNutritionnelPage({super.key, required this.poidsEnfant});

  @override
  _TraitementNutritionnelPageState createState() =>
      _TraitementNutritionnelPageState();
}

class _TraitementNutritionnelPageState
    extends State<TraitementNutritionnelPage> {
  late final TextEditingController _quantiteController = TextEditingController();

  String? _resultat;
  String? _recommandation;
  NutritionCategory? _selectedCategory;

  
  @override
  void initState() {
    super.initState();
    // Déterminer automatiquement la catégorie nutritionnelle en fonction du poids de l'enfant
    try {
      _selectedCategory = NutritionCategory.findCategory(widget.poidsEnfant);
    } catch (e) {
      // Gérer le cas de poids hors plage
      _showError("Le poids de l'enfant est hors de la plage supportée.");
    }
  }

  @override
  void dispose() {
    _quantiteController.dispose();
    super.dispose();
  }

  // Validation de la saisie de la quantité
  bool _validateInput() {
    final quantite = _quantiteController.text.trim();

    if (quantite.isEmpty) {
      _showError("La quantité consommée est obligatoire.");
      return false;
    }

    try {
      final quantiteValue = double.parse(quantite);
      if (quantiteValue <= 0) {
        _showError("Veuillez entrer une quantité positive.");
        return false;
      }
      return true;
    } on FormatException {
      _showError("Veuillez entrer une quantité valide.");
      return false;
    }
  }

  // Traitement et évaluation de l'ATPE
  void _evaluerTestAppetit() {
    if (!_validateInput()) return;
    if (_selectedCategory == null) {
      _showError("Impossible de déterminer la catégorie nutritionnelle.");
      return;
    }

    final quantite = double.parse(_quantiteController.text.trim());

    setState(() {
      _resultat = _construireResultat(_selectedCategory!);
      _recommandation = _construireRecommandation(_selectedCategory!, quantite);
    });
  }

  // Détaillé résultat de la catégorie nutritionnelle
  String _construireResultat(NutritionCategory category) {
    return """
Recommandations nutritionnelles :
- ATPE par jour : ${category.aitePerDay} sachets
- ATPE par semaine : ${category.aitePerWeek} sachets
- BP100 par jour : ${category.bp100PerDay} barres
- BP100 par semaine : ${category.bp100PerWeek} barres
""";
  }

  // Recommandation personnalisée basée sur la quantité
  String _construireRecommandation(NutritionCategory category, double quantite) {
    String recommendation = "Suivez attentivement les recommandations nutritionnelles.";

    // Logique de recommandation basée sur la quantité consommée
    if (quantite < category.aitePaste * 0.5) {
      recommendation += "\n\nAttention : Consommation significativement inférieure aux recommandations.";
    } else if (quantite > category.aitePaste * 1.5) {
      recommendation += "\n\nAttention : Consommation significativement supérieure aux recommandations.";
    }

    return recommendation;
  }

  // Affichage des erreurs
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

  // Réinitialisation du formulaire
  void _resetForm() {
    setState(() {
      _quantiteController.clear();
      _resultat = null;
      _recommandation = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Traitement Nutritionnel"),
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
              "Instructions pour le Traitement Nutritionnel",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Avant de commencer le traitement, sensibilisez l'accompagnant à l'importance de l'allaitement et des instructions ci-dessous.",
              style: TextStyle(fontSize: 16),
            ),
            const Divider(),
            const SizedBox(height: 10),
            
            // Détails du poids et de la catégorie
            _buildWeightCategoryDetails(),
            
            const SizedBox(height: 20),
            
            // Champ de saisie de la quantité
            _buildInputField(
              controller: _quantiteController,
              label: "Quantité consommée (grammes)",
              icon: Icons.local_dining,
            ),

            const SizedBox(height: 20),

            // Bouton d'évaluation
            _buildEvaluateButton(),

            const SizedBox(height: 20),

            // Résultat conditionnel
            if (_resultat != null) _buildResultWidget(),
          ],
        ),
      ),
    );
  }

  // Section des instructions
  Widget _buildInstructionsSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Instructions pour le Traitement Nutritionnel",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          "Avant de commencer le traitement, sensibilisez l'accompagnant à l'importance de l'allaitement et des instructions ci-dessous.",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // Détails du poids et de la catégorie
  Widget _buildWeightCategoryDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Poids de l'enfant : ${widget.poidsEnfant} kg",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (_selectedCategory != null)
          Text(
            "Catégorie nutritionnelle : ${_selectedCategory!.weightRange} kg",
            style: const TextStyle(fontSize: 16),
          ),
      ],
    );
  }

  // Champ de saisie
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

  // Bouton d'évaluation
  Widget _buildEvaluateButton() {
    return ElevatedButton.icon(
      onPressed: _evaluerTestAppetit,
      icon: const Icon(Icons.check_circle),
      label: const Text("Évaluer le Test"),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        textStyle: const TextStyle(fontSize: 18),
        backgroundColor: Colors.teal,
      ),
    );
  }

  // Widget de résultat
  Widget _buildResultWidget() {
    return Card(
      color: Colors.green.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _resultat!,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.green,
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


// // Données du tableau ATPE JSON
//   final List<Map<String, dynamic>> atpeTable = [
//     {
//       "class": "3.0 - 3.4",
//       "aite_pate": 105,
//       "aite_sachets": 750,
//       "aite_sachet_par_jour": 1.5,
//       "aite_sachet_par_semaine": 8,
//       "bp100_barres_par_jour": 2,
//       "bp100_barres_par_semaine": 14
//     },
//     {
//       "class": "3.5 - 4.9",
//       "aite_pate": 130,
//       "aite_sachets": 900,
//       "aite_sachet_par_jour": 1.5,
//       "aite_sachet_par_semaine": 10,
//       "bp100_barres_par_jour": 2.5,
//       "bp100_barres_par_semaine": 17
//     },
//     {
//       "class": "5.0 - 6.9",
//       "aite_pate": 200,
//       "aite_sachets": 1400,
//       "aite_sachet_par_jour": 2,
//       "aite_sachet_par_semaine": 15,
//       "bp100_barres_par_jour": 4,
//       "bp100_barres_par_semaine": 28
//     },
//     {
//       "class": "7.0 - 9.9",
//       "aite_pate": 260,
//       "aite_sachets": 1800,
//       "aite_sachet_par_jour": 3,
//       "aite_sachet_par_semaine": 20,
//       "bp100_barres_par_jour": 5,
//       "bp100_barres_par_semaine": 35
//     },
//     {
//       "class": "10.0 - 14.9",
//       "aite_pate": 400,
//       "aite_sachets": 2800,
//       "aite_sachet_par_jour": 4,
//       "aite_sachet_par_semaine": 30,
//       "bp100_barres_par_jour": 7,
//       "bp100_barres_par_semaine": 49
//     },
//     {
//       "class": "15.0 - 19.9",
//       "aite_pate": 450,
//       "aite_sachets": 3200,
//       "aite_sachet_par_jour": 5,
//       "aite_sachet_par_semaine": 35,
//       "bp100_barres_par_jour": 9,
//       "bp100_barres_par_semaine": 63
//     },
//     {
//       "class": "20.0 - 29.9",
//       "aite_pate": 500,
//       "aite_sachets": 3500,
//       "aite_sachet_par_jour": 6,
//       "aite_sachet_par_semaine": 40,
//       "bp100_barres_par_jour": 10,
//       "bp100_barres_par_semaine": 70
//     },
//     {
//       "class": "30.0 - 39.9",
//       "aite_pate": 650,
//       "aite_sachets": 4500,
//       "aite_sachet_par_jour": 7,
//       "aite_sachet_par_semaine": 50,
//       "bp100_barres_par_jour": 12,
//       "bp100_barres_par_semaine": 84
//     },
//     {
//       "class": "40 - 60",
//       "aite_pate": 700,
//       "aite_sachets": 5000,
//       "aite_sachet_par_jour": 8,
//       "aite_sachet_par_semaine": 55,
//       "bp100_barres_par_jour": 14,
//       "bp100_barres_par_semaine": 98
//     }
//   ];



enum NutritionCategory {
    threeToFour('3.0 - 4.9', 130, 900, 1.5, 10, 2.5, 17),
    fiveToSeven('5.0 - 6.9', 200, 1400, 2.0, 15, 4.0, 28),
    eightToTen('7.0 - 9.9', 260, 1800, 3.0, 20, 5.0, 35),
    elevenToFifteen('10.0 - 14.9', 400, 2800, 4.0, 30, 7.0, 49),
    sixteenToTwenty('15.0 - 19.9', 450, 3200, 5.0, 35, 9.0, 63),
    twentyToThirty('20.0 - 29.9', 500, 3500, 6.0, 40, 10.0, 70),
    thirtyToForty('30.0 - 39.9', 650, 4500, 7.0, 50, 12.0, 84),
    fortyToSixty('40 - 60', 700, 5000, 8.0, 55, 14.0, 98);

    final String weightRange;
    final int aitePaste;
    final int aiteSachets;
    final double aitePerDay;
    final int aitePerWeek;
    final double bp100PerDay;
    final int bp100PerWeek;

    const NutritionCategory(
      this.weightRange,
      this.aitePaste,
      this.aiteSachets,
      this.aitePerDay,
      this.aitePerWeek,
      this.bp100PerDay,
      this.bp100PerWeek,
    );

    // Find the appropriate category based on weight
    static NutritionCategory findCategory(double weight) {
      return NutritionCategory.values.firstWhere(
        (category) {
          final range = category.weightRange.split(' - ');
          final minWeight = double.parse(range[0]);
          final maxWeight = range.length > 1 
            ? double.parse(range[1]) 
            : double.parse(range[0].split('-')[1]);
          return weight >= minWeight && weight <= maxWeight;
        },
        orElse: () => throw ArgumentError('Weight out of supported range'),
      );
    }
  }