import 'package:flutter/material.dart';

class AddExerciseDialog extends StatefulWidget {
  final void Function(String name, int sets, int reps) onAdd;

  const AddExerciseDialog({super.key, required this.onAdd});

  @override
  State<AddExerciseDialog> createState() => _AddExerciseDialogState();
}

class _AddExerciseDialogState extends State<AddExerciseDialog> {
  final nameController = TextEditingController();
  final setsController = TextEditingController();
  final repsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Tambah Latihan"),
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
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onAdd(
              nameController.text,
              int.tryParse(setsController.text) ?? 0,
              int.tryParse(repsController.text) ?? 0,
            );
            Navigator.pop(context);
          },
          child: const Text("Tambah"),
        ),
      ],
    );
  }
}
