import 'package:flutter/material.dart';
import 'package:flutter_repkeep/models/excercise_model.dart';
import '../db/database_helper.dart';

class WorkoutProvider with ChangeNotifier {
  List<Exercise> _exercises = [];
  bool _isLoading = true;

  List<Exercise> get exercises => _exercises;
  bool get isLoading => _isLoading;

  /// 🔹 Ambil semua exercise dari DB
  Future<void> loadExercises() async {
    _isLoading = true;
    notifyListeners();

    final db = await DatabaseHelper().database;
    final data = await db.query("exercises");

    _exercises = data.map((e) => Exercise.fromMap(e)).toList();

    _isLoading = false;
    notifyListeners();
  }

  /// 🔹 Tambah exercise ke DB + Provider
  Future<void> addExercise(Exercise exercise) async {
    final db = await DatabaseHelper().database;
    final id = await db.insert("exercises", exercise.toMap());

    _exercises.add(exercise.copyWith(id: id));
    notifyListeners();
  }

  /// 🔹 Update exercise
  Future<void> updateExercise(Exercise exercise) async {
    final db = await DatabaseHelper().database;
    await db.update(
      "exercises",
      exercise.toMap(),
      where: "id = ?",
      whereArgs: [exercise.id],
    );

    final index = _exercises.indexWhere((e) => e.id == exercise.id);
    if (index != -1) {
      _exercises[index] = exercise;
      notifyListeners();
    }
  }

  /// 🔹 Hapus exercise
  Future<void> deleteExercise(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete("exercises", where: "id = ?", whereArgs: [id]);

    _exercises.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
