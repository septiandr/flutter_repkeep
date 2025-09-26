import 'package:flutter_repkeep/models/excercise_model.dart';
import 'database_helper.dart';

class ExerciseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance; // pakai singleton

  /// 🔹 Tambah exercise
  Future<int> insertExercise(Exercise exercise) async {
    final db = await _dbHelper.database;
    return await db.insert("exercises", exercise.toMap());
  }

  /// 🔹 Ambil semua exercise
  Future<List<Exercise>> getAllExercises() async {
    final db = await _dbHelper.database;
    final result = await db.query("exercises");
    return result.map((e) => Exercise.fromMap(e)).toList();
  }

  /// 🔹 Ambil exercise berdasarkan hari
  Future<List<Exercise>> getExercisesByDay(int dayId) async {
    final db = await _dbHelper.database;
    final result =
        await db.query("exercises", where: "day_id = ?", whereArgs: [dayId]);
    return result.map((e) => Exercise.fromMap(e)).toList();
  }

  /// 🔹 Update exercise
  Future<int> updateExercise(Exercise exercise) async {
    final db = await _dbHelper.database;
    return await db.update(
      "exercises",
      exercise.toMap(),
      where: "id = ?",
      whereArgs: [exercise.id],
    );
  }

  /// 🔹 Hapus exercise
  Future<int> deleteExercise(int id) async {
    final db = await _dbHelper.database;
    return await db.delete("exercises", where: "id = ?", whereArgs: [id]);
  }
}
