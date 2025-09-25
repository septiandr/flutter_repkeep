import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/day_section.dart';
import '../data/workout_data.dart';

class DashboardScreen extends StatelessWidget {
  final String userName = "Risanggalih";

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    final todayName = switch (today.weekday) {
      1 => "Senin",
      2 => "Selasa",
      3 => "Rabu",
      4 => "Kamis",
      5 => "Jumat",
      6 => "Sabtu",
      7 => "Minggu",
      _ => "",
    };

    String dayName(DateTime date) {
      return DateFormat('EEEE', 'id_ID').format(date);
    }

    String dayWithCategory(DateTime date) {
      final name = DateFormat('EEEE', 'id_ID').format(date);
      final cats = workoutPlan[name] ?? {};
      return cats.keys.isNotEmpty ? "$name - ${cats.keys.first}" : name;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary, // biru
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header Greeting
              Text(
                "Halo, $userName 👋",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // kontras
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                DateFormat("EEEE, dd MMMM yyyy", "id_ID").format(today),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 0.3,
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 Section Cards
              Column(
                spacing: 10,
                children: [
                  DaySection(
                    title: "Kemarin: ${dayWithCategory(yesterday)}",
                    categories: workoutPlan[dayName(yesterday)] ?? {},
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                  ),
                  DaySection(
                    title: dayWithCategory(today),
                    categories: workoutPlan[dayName(today)] ?? {},
                    primaryColor: Colors.blue,
                    secondaryColor: Colors.lightBlue,
                    initiallyExpandedCategories: (dayName(today) == todayName)
                        ? (workoutPlan[dayName(today)]?.keys.toList() ?? [])
                        : [],
                  ),
                  DaySection(
                    title: "Besok: ${dayWithCategory(tomorrow)}",
                    categories: workoutPlan[dayName(tomorrow)] ?? {},
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
