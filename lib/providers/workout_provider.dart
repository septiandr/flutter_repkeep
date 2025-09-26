import 'package:flutter/material.dart';
import 'package:flutter_repkeep/db/database_helper.dart';
import 'package:flutter_repkeep/models/category_model.dart';
import 'package:flutter_repkeep/models/day_model.dart';
import 'package:flutter_repkeep/models/excercise_model.dart';

class WorkoutProvider with ChangeNotifier {
  List<Exercise> _exercises = [];
  List<Day> _days = [];
  List<Category> _categories = [];
  bool _isLoading = true;

  List<Exercise> get exercises => _exercises;
  List<Day> get days => _days;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  WorkoutProvider() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _days = await DatabaseHelper.instance.getAllDays();
    _categories = await DatabaseHelper.instance.getAllCategories();
    _exercises = await DatabaseHelper.instance.getAllExercises();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExercise(int dayId, int categoryId, String name, int sets,
      int reps, int duration, String note, WorkoutGrade grade) async {
    final ex = Exercise(
      name: name,
      sets: sets,
      reps: reps,
      duration: duration,
      note: note,
      grade: grade,
      categoryId: categoryId,
      dayId: dayId,
    );

    await DatabaseHelper.instance.insertExercise(ex);
    await loadData(); // reload data
  }

  Future<void> editExercise(Exercise exercise) async {
    await DatabaseHelper.instance.updateExercise(exercise);
    await loadData();
  }

  Future<void> deleteExercise(int id) async {
    await DatabaseHelper.instance.deleteExercise(id);
    await loadData();
  }
}
