import 'package:flutter_repkeep/models/excercise_model.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class ExerciseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertExercise(Exercise exercise) async {
    final db = await _dbHelper.database;
    return await db.insert("exercises", exercise.toMap());
  }

  Future<List<Exercise>> getExercisesByDay(int dayId) async {
    final db = await _dbHelper.database;
    final result =
        await db.query("exercises", where: "day_id = ?", whereArgs: [dayId]);
    return result.map((e) => Exercise.fromMap(e)).toList();
  }

  Future<int> updateExercise(Exercise exercise) async {
    final db = await _dbHelper.database;
    return await db.update(
      "exercises",
      exercise.toMap(),
      where: "id = ?",
      whereArgs: [exercise.id],
    );
  }

  Future<int> deleteExercise(int id) async {
    final db = await _dbHelper.database;
    return await db.delete("exercises", where: "id = ?", whereArgs: [id]);
  }
}
