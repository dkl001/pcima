import 'package:flutter/material.dart';

class TraitementMedicalPage extends StatefulWidget {
  final double poidsEnfant;

  const TraitementMedicalPage({super.key, required this.poidsEnfant});

  @override
  _TraitementMedicalPageState createState() => _TraitementMedicalPageState();
}

class _TraitementMedicalPageState extends State<TraitementMedicalPage> {
  // Create a more type-safe data structure
  

  // Improved dosage table with type safety
  final List<DosageEntry> amoxicillineTable = const [
    DosageEntry(
      weightClass: "< 5kg", 
      dosage: "125 mg * 2", 
      tablets: "1/2 comp * 2"
    ),
    DosageEntry(
      weightClass: "5 - 10", 
      dosage: "250 mg * 2", 
      tablets: "1 comp * 2"
    ),
    DosageEntry(
      weightClass: "10 - 20", 
      dosage: "500 mg * 2", 
      tablets: "2 comp * 2"
    ),
    DosageEntry(
      weightClass: "20 - 35", 
      dosage: "750 mg * 2", 
      tablets: "3 comp * 2"
    ),
    DosageEntry(
      weightClass: "> 35", 
      dosage: "1000 mg * 2", 
      tablets: "4 comp * 2"
    )
  ];

  String? _dosageAmoxicilline;
  String? _complement;
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _calculateDosage(widget.poidsEnfant);
  }

  // More robust dosage calculation with improved error handling
  void _calculateDosage(double poids) {
    setState(() {
      _isCalculating = true;
    });

    try {
      final category = amoxicillineTable.firstWhere(
        (entry) => _matchWeightClass(poids, entry.weightClass),
        orElse: () => throw Exception("Poids hors de la plage supportée"),
      );

      setState(() {
        _dosageAmoxicilline = category.dosage;
        _complement = category.tablets;
        _isCalculating = false;
      });
    } catch (e) {
      _showError("Erreur : Impossible de déterminer le dosage pour ce poids");
      setState(() {
        _isCalculating = false;
      });
    }
  }

  // More flexible weight class matching
  bool _matchWeightClass(double weight, String weightClass) {
    switch (weightClass) {
      case "< 5kg":
        return weight < 5;
      case "5 - 10":
        return weight >= 5 && weight <= 10;
      case "10 - 20":
        return weight > 10 && weight <= 20;
      case "20 - 35":
        return weight > 20 && weight <= 35;
      case "> 35":
        return weight > 35;
      default:
        return false;
    }
  }

  // Enhanced error display with more context
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

  // Method to handle treatment administration
  void _administrerTraitement() {
    if (_dosageAmoxicilline == null || _complement == null) {
      _showError("Veuillez d'abord calculer le dosage");
      return;
    }

    // TODO: Implement actual treatment administration logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmation de traitement"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Dosage : $_dosageAmoxicilline"),
            Text("Comprimés : $_complement"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Confirmer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Traitement Médical Systématique"),
        backgroundColor: Colors.teal,
      ),
      body: _isCalculating 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPatientWeightSection(),
                const SizedBox(height: 20),
                _buildDosageSection(),
                const SizedBox(height: 30),
                _buildInstructionsSection(),
                const SizedBox(height: 30),
                _buildAdministrationButton(),
              ],
            ),
          ),
    );
  }

  // Modularized UI components
  Widget _buildPatientWeightSection() {
    return Text(
      "Poids de l'enfant : ${widget.poidsEnfant} kg",
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDosageSection() {
    if (_dosageAmoxicilline == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Dosage d'amoxicilline",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          "Dosage : $_dosageAmoxicilline",
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          "Comprimé : $_complement",
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildInstructionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Instructions pour l'antibiothérapie",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildInstructionItem(
          "Administrer systématiquement des antibiotiques aux patients souffrant de malnutrition sévère, même en l'absence de signes cliniques d'infection.",
        ),
        _buildInstructionItem(
          "Le traitement recommandé est basé sur l'amoxicilline par voie orale.",
        ),
        _buildInstructionItem(
          "Si l'amoxicilline n'est pas disponible, utiliser l'ampicilline.",
        ),
      ],
    );
  }

  Widget _buildInstructionItem(String instruction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              instruction,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdministrationButton() {
    return ElevatedButton(
      onPressed: _administrerTraitement,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: const Text("Administrer le traitement"),
    );
  }
}


class DosageEntry {
    final String weightClass;
    final String dosage;
    final String tablets;

    const DosageEntry({
      required this.weightClass,
      required this.dosage,
      required this.tablets,
    });
  }