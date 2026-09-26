import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database>  _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "car_care.db");
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE fuel_entries(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          station TEXT NOT NULL,
          organization TEXT NOT NULL,
          date TEXT NOT NULL,
          fuelType TEXT NOT NULL,
          amount REAL NOT NULL,
          price REAL NOT NULL,
          totalCost REAL NOT NULL,
          mileage INTEGER
        )
      ''');
    
    });
  }
}