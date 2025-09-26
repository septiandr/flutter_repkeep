import 'package:flutter/material.dart';
import 'package:flutter_repkeep/models/excercise_model.dart';
import 'package:flutter_repkeep/providers/exercise_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widgets/day_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String userName = "Risanggalih";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ExcerciseProvider>(context, listen: false);
      provider.loadExercises();
    });
  }

  /// Fungsi ambil nama hari dalam bahasa Indonesia
  String dayName(DateTime date) {
    return DateFormat('EEEE', 'id_ID').format(date);
  }

  /// Filter & group exercises by category untuk 1 hari
  Map<String, List<Exercise>> getCategoriesForDay(
      DateTime date, List<Exercise> exercises) {
    final filtered = exercises.where((e) => e.dayId == date.weekday).toList();
    debugPrint("getCategoriesForDay for ${dayName(date)}: ${filtered.length}");

    final Map<String, List<Exercise>> grouped = {};
    for (var ex in filtered) {
      final catName = "Category ${ex.categoryId}";
      grouped.putIfAbsent(catName, () => []);
      grouped[catName]!.add(ex);
    }
    return grouped;
  }

  /// Untuk title, ambil nama hari + kategori pertama
  String dayWithCategory(DateTime date, List<Exercise> exercises) {
    final cats = getCategoriesForDay(date, exercises);
    final name = dayName(date);
    return cats.keys.isNotEmpty ? "$name - ${cats.keys.first}" : name;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExcerciseProvider>(context);

    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Cache categories per day supaya tidak dipanggil berkali-kali
    final yesterdayCategories =
        getCategoriesForDay(yesterday, provider.exercises);
    final todayCategories = getCategoriesForDay(today, provider.exercises);
    final tomorrowCategories =
        getCategoriesForDay(tomorrow, provider.exercises);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Greeting
              Text(
                "Halo, $userName 👋",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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

              // Section Cards
              Column(
                children: [
                  DaySection(
                    title:
                        "Kemarin: ${dayWithCategory(yesterday, provider.exercises)}",
                    categories: yesterdayCategories,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                  ),
                  DaySection(
                    title: dayWithCategory(today, provider.exercises),
                    categories: todayCategories,
                    primaryColor: Colors.blue,
                    secondaryColor: Colors.lightBlue,
                    initiallyExpandedCategories: todayCategories.keys.toList(),
                  ),
                  DaySection(
                    title:
                        "Besok: ${dayWithCategory(tomorrow, provider.exercises)}",
                    categories: tomorrowCategories,
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
