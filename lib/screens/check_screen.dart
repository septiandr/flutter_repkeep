import 'package:flutter/material.dart';
import '../models/workout_log.dart';
import '../models/check_entry.dart';
import '../widgets/workout_entry_tile.dart';
import '../widgets/edit_entry_dialog.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({super.key});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  final List<WorkoutLog> logs = [
    WorkoutLog(date: DateTime.now(), entries: [
      CheckEntry(name: "Push Up"),
      CheckEntry(name: "Squat"),
      CheckEntry(name: "Plank"),
    ]),
  ];

  void _editEntry(WorkoutLog log, int index) {
    final entry = log.entries[index];

    showDialog(
      context: context,
      builder: (context) => EditEntryDialog(
        entry: entry,
        onSave: (updated) {
          setState(() {
            log.entries[index] = updated;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Log"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: logs.length,
        itemBuilder: (context, i) {
          final log = logs[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ExpansionTile(
              title: Text(
                "${log.date.day}-${log.date.month}-${log.date.year}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: List.generate(log.entries.length, (index) {
                final entry = log.entries[index];
                return WorkoutEntryTile(
                  entry: entry,
                  onEdit: () => _editEntry(log, index),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
