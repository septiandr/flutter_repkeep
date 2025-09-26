import 'package:flutter/material.dart';
import 'package:flutter_repkeep/db/database_helper.dart';
import 'package:flutter_repkeep/models/excercise_model.dart';

class WorkoutProvider with ChangeNotifier {
  List<Exercise> _exercises = [];
  bool _isLoading = true;

  List<Exercise> get exercises => _exercises;
  bool get isLoading => _isLoading;

  Future<void> loadExercises() async {
    _isLoading = true;
    notifyListeners();

    _exercises = await DatabaseHelper.instance.getAllExercises();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExercise(
      int dayId, int categoryId, String name, int sets, int reps) async {
    final ex = Exercise(
      id: 0,
      name: name,
      sets: sets,
      reps: reps,
      duration: 0,
      note: "",
      grade: WorkoutGrade.good,
      categoryId: categoryId,
      dayId: dayId,
    );
    await DatabaseHelper.instance.insertExercise(ex);
    await loadExercises();
  }

  Future<void> editExercise(Exercise exercise) async {
    await DatabaseHelper.instance.updateExercise(exercise);
    await loadExercises();
  }

  Future<void> deleteExercise(int id) async {
    await DatabaseHelper.instance.deleteExercise(id);
    await loadExercises();
  }
}
