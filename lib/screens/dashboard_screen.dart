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

    String dayName(DateTime date) {
      return DateFormat('EEEE', 'id_ID').format(date);
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
              DaySection(
                title: "Hari ini: ${dayName(today)}",
                categories: workoutPlan[dayName(today)] ?? {},
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
              ),
              const SizedBox(height: 16),

              DaySection(
                title: "Kemarin: ${dayName(yesterday)}",
                categories: workoutPlan[dayName(yesterday)] ?? {},
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
              ),
              const SizedBox(height: 16),

              DaySection(
                title: "Besok: ${dayName(tomorrow)}",
                categories: workoutPlan[dayName(tomorrow)] ?? {},
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
