import 'package:flutter/material.dart';
import 'check_entry.dart'; // enum WorkoutGrade

class Exercise {
  final String name;
  final int sets;
  final int reps;
  WorkoutGrade grade; // pakai enum
  String note;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    this.grade = WorkoutGrade.good,
    this.note = "",
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "sets": sets,
      "reps": reps,
      "grade": grade.name,
      "note": note,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map["name"],
      sets: map["sets"],
      reps: map["reps"],
      grade: WorkoutGrade.values.firstWhere(
        (g) => g.name == map["grade"],
        orElse: () => WorkoutGrade.good,
      ),
      note: map["note"] ?? "",
    );
  }
}
