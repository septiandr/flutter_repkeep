import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/workout_log.dart';
import '../models/check_entry.dart';
import '../db/database_helper.dart';
import '../widgets/workout_entry_tile.dart';
import '../widgets/edit_entry_dialog.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({super.key});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  List<WorkoutLog> logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final db = await DatabaseHelper.instance.database;

    // ambil 30 hari terakhir
    final now = DateTime.now();
    final fromDate = now.subtract(const Duration(days: 30));

    final result = await db.rawQuery('''
      SELECT e.*, d.name AS day_name, c.name AS category_name
      FROM exercises e
      JOIN days d ON e.day_id = d.id
      JOIN categories c ON e.category_id = c.id
      WHERE date(e.day_id) IS NOT NULL
    ''');

    // 🔹 Mapping: group by tanggal (log)
    final Map<DateTime, List<CheckEntry>> grouped = {};

    for (var row in result) {
      // Samakan hari dari day_id → DateTime
      // weekday Flutter: Senin=1 ... Minggu=7
      final dayId = row["day_id"] as int;
      final today = DateTime.now();
      // ambil tanggal real berdasarkan week relative
      final date = today.subtract(Duration(days: today.weekday - dayId));

      if (date.isBefore(fromDate)) continue; // skip > 30 hari

      final entry = CheckEntry(
        name: row["name"] as String,
        grade: _mapGrade(row["grade"] as String? ?? "good"),
        note: row["note"] as String? ?? "",
      );

      grouped.putIfAbsent(date, () => []);
      grouped[date]!.add(entry);
    }

    setState(() {
      logs = grouped.entries
          .map((e) => WorkoutLog(date: e.key, entries: e.value))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date)); // urut terbaru dulu
      _isLoading = false;
    });
  }

  void _editEntry(WorkoutLog log, int index) {
    final entry = log.entries[index];

    showDialog(
      context: context,
      builder: (context) => EditEntryDialog(
        entry: entry,
        onSave: (updated) {
          setState(() {
            log.entries[index] = updated;
            // TODO: simpan perubahan ke DB juga kalau perlu
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                DateFormat("EEEE, dd MMM yyyy", "id_ID").format(log.date),
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

  WorkoutGrade _mapGrade(String grade) {
    switch (grade) {
      case "perfect":
        return WorkoutGrade.perfect;
      case "bad":
        return WorkoutGrade.bad;
      default:
        return WorkoutGrade.good;
    }
  }
}
