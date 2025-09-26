import 'package:flutter/material.dart';

class WorkoutExerciseTile extends StatelessWidget {
  final String name;
  final int sets;
  final int reps;
  final VoidCallback onEdit;

  const WorkoutExerciseTile({
    super.key,
    required this.name,
    required this.sets,
    required this.reps,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: secondaryColor.withOpacity(0.2),
          child: Icon(Icons.fitness_center, color: secondaryColor),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text("$sets set x $reps reps",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        trailing: const Icon(Icons.edit, size: 18, color: Colors.grey),
        onTap: onEdit,
      ),
    );
  }
}
