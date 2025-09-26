import 'package:flutter/foundation.dart';
import 'package:flutter_repkeep/models/check_entry.dart';
import 'package:flutter_repkeep/models/excercise_model.dart';

class WorkoutProvider with ChangeNotifier {
  final Map<String, Map<String, List<Exercise>>> _workoutPlan = {
    "Senin": {
      "Dada": [
        Exercise(name: "Bench Press", sets: 4, reps: 10),
      ],
    },
    "Selasa": {
      "Kaki": [
        Exercise(name: "Squat", sets: 4, reps: 12),
      ],
    },
  };

  Map<String, Map<String, List<Exercise>>> get workoutPlan => _workoutPlan;

  void addExercise(String day, String category, Exercise exercise) {
    _workoutPlan[day]![category]!.add(exercise);
    notifyListeners();
  }

  void editExercise(String day, String category, int index, Exercise exercise) {
    _workoutPlan[day]![category]![index] = exercise;
    notifyListeners();
  }

  void deleteExercise(String day, String category, int index) {
    _workoutPlan[day]![category]!.removeAt(index);
    notifyListeners();
  }

  void updateExerciseGrade(
      String day, String category, int index, WorkoutGrade grade, String note) {
    _workoutPlan[day]![category]![index].grade = grade;
    _workoutPlan[day]![category]![index].note = note;
    notifyListeners();
  }
}
