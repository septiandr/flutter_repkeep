import 'package:flutter/material.dart';

enum WorkoutGrade { perfect, good, bad }

class CheckEntry {
  final String name;
  WorkoutGrade grade;
  String note;

  CheckEntry({
    required this.name,
    this.grade = WorkoutGrade.good,
    this.note = "",
  });
}
