import 'package:flutter/material.dart';
import 'package:flutter_repkeep/providers/workout_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/add_excercise_dialog.dart';
import '../widgets/edit_exercise_dialog.dart';
import '../widgets/workout_category_section.dart';
import '../widgets/workout_day_card.dart';
import '../widgets/workout_exercise_tile.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({super.key});

  void _editExercise(BuildContext context, String day, String category,
      int index, Map<String, dynamic> exercise) {
    showDialog(
      context: context,
      builder: (context) => EditExerciseDialog(
        initialName: exercise["name"],
        initialSets: exercise["sets"],
        initialReps: exercise["reps"],
        onSave: (name, sets, reps) {
          context
              .read<WorkoutProvider>()
              .editExercise(day, category, index, name, sets, reps);
        },
        onDelete: () {
          context.read<WorkoutProvider>().deleteExercise(day, category, index);
        },
      ),
    );
  }

  void _addExercise(BuildContext context, String day, String category) {
    showDialog(
      context: context,
      builder: (context) => AddExerciseDialog(
        onAdd: (name, sets, reps) {
          context
              .read<WorkoutProvider>()
              .addExercise(day, category, name, sets, reps);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final workoutPlan = context.watch<WorkoutProvider>().workoutPlan;

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
                  onAdd: () =>
                      _addExercise(context, dayEntry.key, categoryEntry.key),
                  exercises: categoryEntry.value.asMap().entries.map((entry) {
                    return WorkoutExerciseTile(
                      name: entry.value["name"],
                      sets: entry.value["sets"],
                      reps: entry.value["reps"],
                      onEdit: () => _editExercise(context, dayEntry.key,
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
