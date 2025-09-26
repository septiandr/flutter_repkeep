import 'package:flutter/material.dart';
import 'package:flutter_repkeep/models/excercise_model.dart';
import 'package:flutter_repkeep/providers/workout_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/excercise_dialog.dart';
import '../widgets/workout_category_section.dart';
import '../widgets/workout_day_card.dart';
import '../widgets/workout_exercise_tile.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({super.key});

  void _editExercise(BuildContext context, Exercise exercise) {
    showDialog(
      context: context,
      builder: (context) => ExerciseDialog(
        initialExercise: exercise,
        onSave: (name, sets, reps, duration, note, grade) {
          final updated = exercise.copyWith(
            name: name,
            sets: sets,
            reps: reps,
            duration: duration,
            note: note,
            grade: grade,
          );
          context.read<WorkoutProvider>().editExercise(updated);
        },
      ),
    );
  }

  void _addExercise(BuildContext context, int dayId, int categoryId) {
    showDialog(
      context: context,
      builder: (context) => ExerciseDialog(
        onSave: (name, sets, reps, duration, note, grade) {
          context.read<WorkoutProvider>().addExercise(
                dayId,
                categoryId,
                name,
                sets,
                reps,
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final provider = context.watch<WorkoutProvider>();
    final exercises = provider.exercises;

    // 🔹 Grouping exercise by day & category
    final grouped = <int, Map<int, List<Exercise>>>{};
    for (var ex in exercises) {
      grouped.putIfAbsent(ex.dayId, () => {});
      grouped[ex.dayId]!.putIfAbsent(ex.categoryId, () => []);
      grouped[ex.dayId]![ex.categoryId]!.add(ex);
    }

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
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: grouped.entries.map((dayEntry) {
                final dayId = dayEntry.key;
                return WorkoutDayCard(
                  day:
                      "Hari $dayId", // 🔹 kalau ada tabel days, bisa ganti nama dari DB
                  child: Column(
                    children: dayEntry.value.entries.map((categoryEntry) {
                      final categoryId = categoryEntry.key;
                      final categoryExercises = categoryEntry.value;

                      return WorkoutCategorySection(
                        category:
                            "Kategori $categoryId", // 🔹 ganti dengan nama kategori kalau ada tabel categories
                        onAdd: () => _addExercise(context, dayId, categoryId),
                        exercises: categoryExercises.map((ex) {
                          return WorkoutExerciseTile(
                            name: ex.name,
                            sets: ex.sets,
                            reps: ex.reps,
                            onEdit: () => _editExercise(context, ex),
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
