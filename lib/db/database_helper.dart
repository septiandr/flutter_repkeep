import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    await _seedIfEmpty(_database!); // cek isi, kalau kosong seed
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "workout.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Table Days
    await db.execute('''
      CREATE TABLE days (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    // Table Categories
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    // Table Exercises
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

  /// 🔹 Seeder hanya jalan kalau tabel kosong
  Future<void> _seedIfEmpty(Database db) async {
    // Cek days
    final dayCount = Sqflite.firstIntValue(
      await db.rawQuery("SELECT COUNT(*) FROM days"),
    );

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

    // Cek categories
    final catCount = Sqflite.firstIntValue(
      await db.rawQuery("SELECT COUNT(*) FROM categories"),
    );

    if (catCount == 0) {
      final categories = ['Push', 'Pull', 'Legs', 'Cardio'];
      for (var c in categories) {
        await db.insert("categories", {"name": c});
      }
    }

    // Cek exercises
    final exCount = Sqflite.firstIntValue(
      await db.rawQuery("SELECT COUNT(*) FROM exercises"),
    );

    if (exCount == 0) {
      await db.insert("exercises", {
        "name": "Push Up",
        "sets": 3,
        "reps": 15,
        "duration": 60,
        "grade": "good",
        "note": "Latihan pemanasan",
        "category_id": 1,
        "day_id": 1,
      });

      await db.insert("exercises", {
        "name": "Pull Up",
        "sets": 3,
        "reps": 10,
        "duration": 90,
        "grade": "perfect",
        "note": "Kuat sekali",
        "category_id": 2,
        "day_id": 2,
      });

      await db.insert("exercises", {
        "name": "Squat",
        "sets": 4,
        "reps": 20,
        "duration": 120,
        "grade": "bad",
        "note": "Capek banget",
        "category_id": 3,
        "day_id": 3,
      });

      await db.insert("exercises", {
        "name": "Running",
        "sets": 1,
        "reps": 1,
        "duration": 1800,
        "grade": "good",
        "note": "Lari sore",
        "category_id": 4,
        "day_id": 6,
      });
    }
  }
}
