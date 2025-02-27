import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'nutrition_app.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE nutrition_cases (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            patientName TEXT,
            ageMonths INTEGER,
            muac REAL,
            weight REAL,
            height REAL,
            hasEdema INTEGER,
            edemaSeverity TEXT,
            admissionType TEXT,
            status TEXT,
            admissionDate TEXT,
            isVaccinated INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE supplementation_plans (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productName TEXT,
            dailyRation REAL,
            energy REAL,
            protein REAL,
            fat REAL,
            targetGroup TEXT
          )
        ''');

      await db.execute('''
        CREATE TABLE failure_records (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          patientId INTEGER,
          cause TEXT,
          actions TEXT,
          dateRecorded TEXT
        )
      ''');

        await db.execute('''
          CREATE TABLE medical_treatments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            treatmentName TEXT,
            description TEXT,
            targetGroup TEXT,
            dosage TEXT,
            administrationPeriod TEXT,
            category TEXT
          )
        ''');
      },
    );
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> query(String table) async {
    final db = await database;
    return db.query(table);
  }
}
