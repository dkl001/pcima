import 'package:flutter/material.dart';

class RegisterPatientPage extends StatefulWidget {
  const RegisterPatientPage({super.key});

  @override
  _RegisterPatientPageState createState() => _RegisterPatientPageState();
}

class _RegisterPatientPageState extends State<RegisterPatientPage> {
  final _formKey = GlobalKey<FormState>();
  String nomPrenom = '';
  String categorie = 'Enfant';
  int? ageMois;
  String localite = '';
  String centreSante = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enregistrer un Patient'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nom et Prénom'),
                onSaved: (value) => nomPrenom = value!,
                validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Catégorie'),
                value: categorie,
                items: ['Enfant', 'Femme enceinte', 'Adulte']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => categorie = value as String),
              ),
              if (categorie == 'Enfant')
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Âge en mois'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => ageMois = int.tryParse(value!),
                ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Localité'),
                onSaved: (value) => localite = value!,
                validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Centre de Santé'),
                onSaved: (value) => centreSante = value!,
                validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Sauvegarde dans SQLite ou Supabase
                  }
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
