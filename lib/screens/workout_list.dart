import 'package:flutter/material.dart';
import 'package:flutter_repkeep/models/excercise_model.dart';
import 'package:flutter_repkeep/widgets/excercise_dialog.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
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
            grade: WorkoutGradeExtension.fromString(grade),
            note: note,
          );
          context.read<WorkoutProvider>().editExercise(updated);
        },
      ),
    );
  }

  void _addExercise(BuildContext context, int dayId) async {
    final provider = context.read<WorkoutProvider>();

    // Select category first
    final selectedCategory = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Pilih Kategori"),
        children: provider.categories.map((cat) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, cat.id),
            child: Text(cat.name),
          );
        }).toList(),
      ),
    );

    if (selectedCategory == null) return;

    // Show dialog to input exercise details
    showDialog(
      context: context,
      builder: (context) => ExerciseDialog(
        onSave: (name, sets, reps, duration, note, grade) {
          provider.addExercise(
            dayId,
            selectedCategory,
            name,
            sets,
            reps,
            duration,
            note,
            WorkoutGradeExtension.fromString(grade),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

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
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: provider.days.map((day) {
              final exercisesForDay =
                  provider.exercises.where((ex) => ex.dayId == day.id).toList();

              // Group exercises by category
              final Map<int, List<Exercise>> categories = {};
              for (var ex in exercisesForDay) {
                categories.putIfAbsent(ex.categoryId, () => []);
                categories[ex.categoryId]!.add(ex);
              }

              return WorkoutDayCard(
                day: day.name,
                child: categories.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton.icon(
                          onPressed: () => _addExercise(context, day.id),
                          icon: const Icon(Icons.add),
                          label: const Text("Tambah Latihan"),
                        ),
                      )
                    : Column(
                        children: categories.entries.map((categoryEntry) {
                          final categoryExercises = categoryEntry.value;
                          final categoryName = provider.categories
                              .firstWhere((c) => c.id == categoryEntry.key)
                              .name;
                          return WorkoutCategorySection(
                            category: categoryName,
                            onAdd: () => _addExercise(context, day.id),
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
          );
        },
      ),
    );
  }
}
