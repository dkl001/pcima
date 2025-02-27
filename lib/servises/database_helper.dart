import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/patients.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pcima.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Patients (
        id TEXT PRIMARY KEY,
        nomPrenom TEXT NOT NULL,
        categorie TEXT NOT NULL,
        ageMois INTEGER,
        localite TEXT NOT NULL,
        centreSante TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE Depistage (
        id TEXT PRIMARY KEY,
        patientId TEXT NOT NULL,
        perimetreBraquial REAL NOT NULL,
        poids REAL NOT NULL,
        taille REAL NOT NULL,
        odeme INTEGER NOT NULL,
        FOREIGN KEY (patientId) REFERENCES Patients (id)
      );
    ''');
  }

  Future<void> insertPatient(Map<String, dynamic> patient) async {
    final db = await database;
    await db.insert('Patients', patient);
  }

  Future<void> insertDepistage(Map<String, dynamic> depistage) async {
    final db = await database;
    await db.insert('Depistage', depistage);
  }

  Future<List<Map<String, dynamic>>> fetchUnsyncedPatients() async {
    final db = await database;
    return await db.query(
        'Patients'); // Filtrer les patients non synchronisés si nécessaire.
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

class SyncService {
  final dbHelper = DatabaseHelper.instance;
  final supabaseService = SupabaseService();

  Future<void> syncData() async {
    // Vérifie la connexion internet
    final unsyncedPatients = await dbHelper.fetchUnsyncedPatients();

    for (var patient in unsyncedPatients) {
      try {
        await supabaseService.savePatient(patient);
        // Supprime de SQLite si synchronisé avec succès
        // Exemple : dbHelper.deletePatient(patient['id']);
      } catch (e) {
        print('Erreur de synchronisation : $e');
      }
    }
  }
}

// class SupabaseService {
//   final _client = Supabase.instance.client;

//   Future<void> savePatient(Map<String, dynamic> patient) async {
//     final response = await _client.from('Patients').insert(patient);
//     if (response.error != null) {
//       throw Exception('Erreur Supabase : ${response.error!.message}');
//     }
//   }

//   Future<void> saveDepistage(Map<String, dynamic> depistage) async {
//     final response = await _client.from('Depistage').insert(depistage);
//     if (response.error != null) {
//       throw Exception('Erreur Supabase : ${response.error!.message}');
//     }
//   }

//   Future<void> syncUnsyncedPatients() async {
//     final db = await DatabaseHelper.instance.database;
//     final unsyncedPatients = await db.query('patients',
//         where: 'synchronise = ?', whereArgs: [0]);

//     for (var patient in unsyncedPatients) {
//       final response = await _client.from('patients').upsert(patient);
//       if (response.error == null) {
//         // Marquer comme synchronisé dans SQLite
//         await db.update(
//           'patients',
//           {'synchronise': 1},
//           where: 'id = ?',
//           whereArgs: [patient['id']],
//         );
//       }
//     }
//   }
// }

class SupabaseService {
  final _client = Supabase.instance.client;

  /// Récupérer tous les patients depuis Supabase
  Future<List<Patient>> getAllPatients() async {
    // try {
    //   final response = await _client.from('patients').select();
    //   // print(response);
    //   final data = response as List<dynamic>;
    //   return data.map((item) => Patient.fromMap(item)).toList();
      
    // } catch (e) {
    //   throw Exception('Erreur lors de la récupération des patients : $e');
    // }

    final response = await _client.from('patients').select();
      // print(response);
      final data = response as List<dynamic>;
      print("0");
      print(data);
      print(data.map((item) => Patient.fromMap(item)).toList());
      return data.map((item) => Patient.fromMap(item)).toList();
  }

  //  Future<List<Map<String, dynamic>>> getAllPatients() async {
  //   final response = await _client.from('patients').select();

  //   if (response == null) {
  //     throw Exception('Erreur lors de la récupération des patients : $response');
  //   }

  //   return (response as List).cast<Map<String, dynamic>>();
  // }

  /// Ajouter un patient
  Future<void> addPatient(Patient patient) async {
    final response = await _client.from('patients').insert(patient.toMap());
    print(response);
    // if (response.error != null) {
    //   throw Exception('Erreur lors de l\'ajout du patient : ${response.error!.message}');
    // }
  }

  /// Mettre à jour un patient
  Future<void> updatePatient(Patient patient) async {
    final response = await _client
        .from('patients')
        .update(patient.toMap())
        .eq('id', patient.id);

    if (response.error != null) {
      throw Exception(
          'Erreur lors de la mise à jour du patient : ${response.error!.message}');
    }
  }

  /// Supprimer un patient
  Future<void> deletePatient(String patientId) async {
    final response =
        await _client.from('patients').delete().eq('id', patientId);

    if (response.error != null) {
      throw Exception(
          'Erreur lors de la suppression du patient : ${response.error!.message}');
    }
  }

  Future<void> savePatient(Map<String, dynamic> patient) async {
    final response = await _client.from('Patients').insert(patient);
    print(response);
    if (response != null) {
      throw Exception('Erreur Supabase : ${response.error!.message}');
    }
  }

  Future<void> saveDepistage(Map<String, dynamic> depistage) async {
    final response = await _client.from('Depistage').insert(depistage);
    if (response.error != null) {
      throw Exception('Erreur Supabase : ${response.error!.message}');
    }
  }

  Future<void> syncUnsyncedPatients() async {
    final db = await DatabaseHelper.instance.database;
    final unsyncedPatients =
        await db.query('patients', where: 'synchronise = ?', whereArgs: [0]);

    for (var patient in unsyncedPatients) {
      final response = await _client.from('patients').upsert(patient);
      if (response.error == null) {
        // Marquer comme synchronisé dans SQLite
        await db.update(
          'patients',
          {'synchronise': 1},
          where: 'id = ?',
          whereArgs: [patient['id']],
        );
      }
    }
  }
}
