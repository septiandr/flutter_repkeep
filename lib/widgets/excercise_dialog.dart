import 'package:flutter/material.dart';
import 'package:flutter_repkeep/models/excercise_model.dart';

extension WorkoutGradeExtension on WorkoutGrade {
  String get name {
    switch (this) {
      case WorkoutGrade.good:
        return 'good';
      case WorkoutGrade.perfect:
        return 'perfect';
      case WorkoutGrade.bad:
        return 'bad';
    }
  }

  static WorkoutGrade fromString(String value) {
    switch (value.toLowerCase()) {
      case 'good':
        return WorkoutGrade.good;
      case 'perfect':
        return WorkoutGrade.perfect;
      case 'bad':
        return WorkoutGrade.bad;
      default:
        return WorkoutGrade.good;
    }
  }
}

class ExerciseDialog extends StatefulWidget {
  final Exercise? initialExercise;
  final void Function(String name, int sets, int reps, int duration,
      String note, String grade) onSave; // grade as string

  const ExerciseDialog({
    super.key,
    this.initialExercise,
    required this.onSave,
  });

  @override
  State<ExerciseDialog> createState() => _ExerciseDialogState();
}

class _ExerciseDialogState extends State<ExerciseDialog> {
  final nameController = TextEditingController();
  final setsController = TextEditingController();
  final repsController = TextEditingController();
  final durationController = TextEditingController();
  final noteController = TextEditingController();
  WorkoutGrade selectedGrade = WorkoutGrade.good;

  @override
  void initState() {
    super.initState();
    if (widget.initialExercise != null) {
      final ex = widget.initialExercise!;
      nameController.text = ex.name;
      setsController.text = ex.sets.toString();
      repsController.text = ex.reps.toString();
      durationController.text = ex.duration.toString();
      noteController.text = ex.note ?? '';
      selectedGrade = WorkoutGradeExtension.fromString(ex.grade.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialExercise != null;

    return AlertDialog(
      title: Text(isEdit ? "Edit Latihan" : "Tambah Latihan"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nama Latihan"),
            ),
            TextField(
              controller: setsController,
              decoration: const InputDecoration(labelText: "Sets"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: repsController,
              decoration: const InputDecoration(labelText: "Reps"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(labelText: "Durasi (detik)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: "Catatan"),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<WorkoutGrade>(
              value: selectedGrade,
              items: WorkoutGrade.values.map((grade) {
                return DropdownMenuItem(
                  value: grade,
                  child: Text(grade.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => selectedGrade = value);
              },
              decoration: const InputDecoration(labelText: "Grade"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(
              nameController.text,
              int.tryParse(setsController.text) ?? 0,
              int.tryParse(repsController.text) ?? 0,
              int.tryParse(durationController.text) ?? 0,
              noteController.text,
              selectedGrade.name, // pass as string for DB
            );
            Navigator.pop(context);
          },
          child: Text(isEdit ? "Simpan" : "Tambah"),
        ),
      ],
    );
  }
}
