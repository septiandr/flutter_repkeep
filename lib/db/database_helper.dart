import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/excercise_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("workout.db");
    await _seedIfEmpty(_database!);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE days (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        sets INTEGER NOT NULL,
        reps INTEGER NOT NULL,
        duration INTEGER DEFAULT 0,
        grade TEXT DEFAULT 'good',
        note TEXT,
        category_id INTEGER NOT NULL,
        day_id INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE,
        FOREIGN KEY (day_id) REFERENCES days (id) ON DELETE CASCADE
      )
    ''');
  }

  /// Seeder (hanya jika kosong)
  Future<void> _seedIfEmpty(Database db) async {
    final dayCount =
        Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM days"));
    if (dayCount == 0) {
      final days = [
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu',
        'Minggu'
      ];
      for (var d in days) {
        await db.insert("days", {"name": d});
      }
    }

    final catCount = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM categories"));
    if (catCount == 0) {
      final categories = ['Push', 'Pull', 'Legs', 'Cardio'];
      for (var c in categories) {
        await db.insert("categories", {"name": c});
      }
    }
  }

  // =============================
  // 🔹 CRUD Exercises
  // =============================

  Future<List<Exercise>> getAllExercises() async {
    final db = await instance.database;
    final result = await db.query("exercises");
    return result.map((e) => Exercise.fromMap(e)).toList();
  }

  Future<int> insertExercise(Exercise exercise) async {
    final db = await instance.database;
    return await db.insert("exercises", exercise.toMap());
  }

  Future<int> updateExercise(Exercise exercise) async {
    final db = await instance.database;
    return await db.update(
      "exercises",
      exercise.toMap(),
      where: "id = ?",
      whereArgs: [exercise.id],
    );
  }

  Future<int> deleteExercise(int id) async {
    final db = await instance.database;
    return await db.delete("exercises", where: "id = ?", whereArgs: [id]);
  }
}
