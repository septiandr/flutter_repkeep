import 'package:flutter/material.dart';
import 'package:flutter_repkeep/widgets/add_excercise_dialog.dart';
import 'package:flutter_repkeep/widgets/edit_exercise_dialog.dart';
import 'package:flutter_repkeep/widgets/workout_category_section.dart';
import 'package:flutter_repkeep/widgets/workout_day_card.dart';
import 'package:flutter_repkeep/widgets/workout_exercise_tile.dart';
import '../data/workout_data.dart';

class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({super.key});

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  void _editExercise(
      String day, String category, int index, Map<String, dynamic> exercise) {
    showDialog(
      context: context,
      builder: (context) => EditExerciseDialog(
        initialName: exercise["name"],
        initialSets: exercise["sets"],
        initialReps: exercise["reps"],
        onSave: (name, sets, reps) {
          setState(() {
            workoutPlan[day]![category]![index] = {
              "name": name,
              "sets": sets,
              "reps": reps,
            };
          });
        },
        onDelete: () {
          setState(() {
            workoutPlan[day]![category]!.removeAt(index);
          });
        },
      ),
    );
  }

  void _addExercise(String day, String category) {
    showDialog(
      context: context,
      builder: (context) => AddExerciseDialog(
        onAdd: (name, sets, reps) {
          setState(() {
            workoutPlan[day]![category]!.add({
              "name": name,
              "sets": sets,
              "reps": reps,
            });
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Jadwal Lengkap",
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: workoutPlan.entries.map((dayEntry) {
          return WorkoutDayCard(
            day: dayEntry.key,
            child: Column(
              children: dayEntry.value.entries.map((categoryEntry) {
                return WorkoutCategorySection(
                  category: categoryEntry.key,
                  onAdd: () => _addExercise(dayEntry.key, categoryEntry.key),
                  exercises: categoryEntry.value.asMap().entries.map((entry) {
                    return WorkoutExerciseTile(
                      name: entry.value["name"],
                      sets: entry.value["sets"],
                      reps: entry.value["reps"],
                      onEdit: () => _editExercise(dayEntry.key,
                          categoryEntry.key, entry.key, entry.value),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
