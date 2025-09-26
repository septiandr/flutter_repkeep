import 'package:flutter/material.dart';

class EditExerciseDialog extends StatefulWidget {
  final String initialName;
  final int initialSets;
  final int initialReps;
  final void Function(String name, int sets, int reps) onSave;
  final VoidCallback onDelete;

  const EditExerciseDialog({
    super.key,
    required this.initialName,
    required this.initialSets,
    required this.initialReps,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<EditExerciseDialog> createState() => _EditExerciseDialogState();
}

class _EditExerciseDialogState extends State<EditExerciseDialog> {
  late TextEditingController nameController;
  late TextEditingController setsController;
  late TextEditingController repsController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
    setsController = TextEditingController(text: widget.initialSets.toString());
    repsController = TextEditingController(text: widget.initialReps.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    setsController.dispose();
    repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Latihan"),
      content: Column(
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
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onDelete();
            Navigator.pop(context);
          },
          child: const Text("Hapus", style: TextStyle(color: Colors.red)),
        ),
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
            );
            Navigator.pop(context);
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}
