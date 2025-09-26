import 'package:flutter/material.dart';
import 'package:flutter_repkeep/models/excercise_model.dart';

class DaySection extends StatelessWidget {
  final String title;
  final Map<String, List<Exercise>> categories;
  final Color primaryColor;
  final Color secondaryColor;
  final List<String> initiallyExpandedCategories;

  const DaySection({
    super.key,
    required this.title,
    required this.categories,
    required this.primaryColor,
    required this.secondaryColor,
    this.initiallyExpandedCategories = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Title Hari
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (categories.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  "Tidak ada jadwal latihan",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: Column(
                children: categories.entries.map((entry) {
                  String category = entry.key;
                  List<Exercise> exercises = entry.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: secondaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ExpansionTile(
                      initiallyExpanded:
                          initiallyExpandedCategories.contains(category),
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      childrenPadding: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 12),
                      leading: Icon(
                        Icons.category,
                        color: secondaryColor,
                      ),
                      title: Text(
                        category,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: secondaryColor,
                        ),
                      ),
                      iconColor: secondaryColor,
                      collapsedIconColor: Colors.grey,
                      children: exercises.map((e) {
                        final int duration = e.duration ?? 0;
                        final String subtitle = duration > 0
                            ? "Durasi: ${duration}s"
                            : "${e.sets} set x ${e.reps} reps";

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            leading: CircleAvatar(
                              backgroundColor: secondaryColor.withOpacity(0.2),
                              child: Icon(
                                Icons.fitness_center,
                                color: secondaryColor,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              e.name ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                if ((e.grade ?? "").toString().isNotEmpty)
                                  Text(
                                    "Grade: ${e.grade}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                if ((e.note ?? "").toString().isNotEmpty)
                                  Text(
                                    "Note: ${e.note}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
