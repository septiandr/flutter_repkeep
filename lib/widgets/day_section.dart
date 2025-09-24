import 'package:flutter/material.dart';

class DaySection extends StatelessWidget {
  final String title;
  final Map<String, List<Map<String, dynamic>>> categories;
  final Color primaryColor;
  final Color secondaryColor;

  const DaySection({
    super.key,
    required this.title,
    required this.categories,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Title row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: secondaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categories.entries.map((entry) {
                String category = entry.key;
                List<Map<String, dynamic>> exercises = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),

                    ...exercises.map((e) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            leading: CircleAvatar(
                              backgroundColor: secondaryColor.withOpacity(0.2),
                              child: Icon(Icons.fitness_center,
                                  color: secondaryColor, size: 20),
                            ),
                            title: Text(
                              e["name"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            subtitle: Text(
                              "${e["sets"]} set x ${e["reps"]} reps",
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        )),
                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
