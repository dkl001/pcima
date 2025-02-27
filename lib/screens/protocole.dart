import 'package:flutter/material.dart';

class ProtocoleScreen extends StatelessWidget {
  final List<String> sections = [
    "Introduction",
    "Prévention",
    "Détection",
    "Prise en charge",
  ];


ProtocoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Protocole PCIMA"),
      ),
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(sections[index]),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Naviguer vers une sous-section ou afficher des détails
            },
          );
        },
      ),
    );
  }
}
