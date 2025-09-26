import 'package:flutter/material.dart';
import 'package:flutter_repkeep/models/excercise_model.dart';
import '../db/database_helper.dart';

class ExcerciseProvider with ChangeNotifier {
  List<Exercise> _exercises = [];
  bool _isLoading = true;

  List<Exercise> get exercises => _exercises;
  bool get isLoading => _isLoading;

  /// 🔹 Ambil semua exercise dari DB
  Future<void> loadExercises() async {
    _isLoading = true;
    notifyListeners();

    _exercises = await DatabaseHelper.instance.getAllExercises();

    _isLoading = false;
    notifyListeners();
  }

  /// 🔹 Tambah exercise ke DB + Provider
  Future<void> addExercise(Exercise exercise) async {
    final id = await DatabaseHelper.instance.insertExercise(exercise);
    _exercises.add(exercise.copyWith(id: id));
    notifyListeners();
  }

  /// 🔹 Update exercise
  Future<void> updateExercise(Exercise exercise) async {
    await DatabaseHelper.instance.updateExercise(exercise);

    final index = _exercises.indexWhere((e) => e.id == exercise.id);
    if (index != -1) {
      _exercises[index] = exercise;
      notifyListeners();
    }
  }

  /// 🔹 Hapus exercise
  Future<void> deleteExercise(int id) async {
    await DatabaseHelper.instance.deleteExercise(id);
    _exercises.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
