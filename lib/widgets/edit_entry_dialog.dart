import 'package:flutter/material.dart';
import '../models/check_entry.dart';

class EditEntryDialog extends StatefulWidget {
  final CheckEntry entry;
  final ValueChanged<CheckEntry> onSave;

  const EditEntryDialog({
    super.key,
    required this.entry,
    required this.onSave,
  });

  @override
  State<EditEntryDialog> createState() => _EditEntryDialogState();
}

class _EditEntryDialogState extends State<EditEntryDialog> {
  late WorkoutGrade grade;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    grade = widget.entry.grade;
    noteController = TextEditingController(text: widget.entry.note);
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.entry.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<WorkoutGrade>(
            value: grade,
            items: const [
              DropdownMenuItem(
                value: WorkoutGrade.perfect,
                child: Text("🌟 Sempurna"),
              ),
              DropdownMenuItem(
                value: WorkoutGrade.good,
                child: Text("✅ Selesai"),
              ),
              DropdownMenuItem(
                value: WorkoutGrade.bad,
                child: Text("❌ Tidak"),
              ),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() => grade = val);
              }
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: noteController,
            decoration: const InputDecoration(
              labelText: "Catatan",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
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
            widget.onSave(
              CheckEntry(
                name: widget.entry.name,
                grade: grade,
                note: noteController.text,
              ),
            );
            Navigator.pop(context);
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}
