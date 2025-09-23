import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  final String userName = "Risang";

  // Dummy data
  final Map<String, List<Map<String, dynamic>>> workoutPlan = {
    "Senin": [
      {"name": "Bench Press", "sets": 4, "reps": 12},
      {"name": "Push Up", "sets": 3, "reps": 20},
      {"name": "Dumbbell Fly", "sets": 3, "reps": 15},
    ],
    "Minggu": [
      {"name": "Pull Up", "sets": 4, "reps": 8},
      {"name": "Deadlift", "sets": 4, "reps": 10},
    ],
    "Selasa": [
      {"name": "Squat", "sets": 4, "reps": 12},
      {"name": "Lunges", "sets": 3, "reps": 15},
    ],
  };

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    String dayName(DateTime date) {
      return DateFormat('EEEE', 'id_ID').format(date); // Nama hari lokal
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gym Tracker"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama & tanggal
            Text("Halo, $userName 👋",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(DateFormat("EEEE, dd MMMM yyyy", "id_ID").format(today),
                style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 20),

            // Hari ini
            _buildSection("Hari ini: ${dayName(today)}", workoutPlan[dayName(today)] ?? []),

            const SizedBox(height: 20),

            // Kemarin
            _buildSection("Kemarin: ${dayName(yesterday)}", workoutPlan[dayName(yesterday)] ?? []),

            const SizedBox(height: 20),

            // Besok
            _buildSection("Besok: ${dayName(tomorrow)}", workoutPlan[dayName(tomorrow)] ?? []),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> exercises) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (exercises.isEmpty)
            const Text("Tidak ada jadwal latihan", style: TextStyle(color: Colors.grey))
          else
            ...exercises.map((e) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.fitness_center, color: Colors.blueAccent),
                  title: Text(e["name"]),
                  subtitle: Text("${e["sets"]} set x ${e["reps"]} reps"),
                )),
        ],
      ),
    );
  }
}
