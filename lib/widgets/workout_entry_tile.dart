import 'package:flutter/material.dart';
import '../models/check_entry.dart';
import 'grade_text.dart';

class WorkoutEntryTile extends StatelessWidget {
  final CheckEntry entry;
  final VoidCallback onEdit;

  const WorkoutEntryTile({
    super.key,
    required this.entry,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(entry.name),
      subtitle: Text(
        "${gradeText(entry.grade)}${entry.note.isNotEmpty ? " • ${entry.note}" : ""}",
      ),
      trailing: const Icon(Icons.edit, size: 18),
      onTap: onEdit,
    );
  }
}
