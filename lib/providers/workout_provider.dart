import 'package:flutter/foundation.dart';

class WorkoutProvider with ChangeNotifier {
  final Map<String, Map<String, List<Map<String, dynamic>>>> _workoutPlan = {
    "Senin": {
      "Dada": [],
      "Punggung": [],
    },
    "Selasa": {
      "Kaki": [],
    },
    // dst...
  };

  Map<String, Map<String, List<Map<String, dynamic>>>> get workoutPlan =>
      _workoutPlan;

  void addExercise(
      String day, String category, String name, int sets, int reps) {
    _workoutPlan[day]![category]!.add({
      "name": name,
      "sets": sets,
      "reps": reps,
    });
    notifyListeners();
  }

  void editExercise(
      String day, String category, int index, String name, int sets, int reps) {
    _workoutPlan[day]![category]![index] = {
      "name": name,
      "sets": sets,
      "reps": reps,
    };
    notifyListeners();
  }

  void deleteExercise(String day, String category, int index) {
    _workoutPlan[day]![category]!.removeAt(index);
    notifyListeners();
  }
}
