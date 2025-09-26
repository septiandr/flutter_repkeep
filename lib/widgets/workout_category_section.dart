import 'package:flutter/material.dart';

class WorkoutCategorySection extends StatelessWidget {
  final String category;
  final List<Widget> exercises;
  final VoidCallback onAdd;

  const WorkoutCategorySection({
    super.key,
    required this.category,
    required this.exercises,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(thickness: 1, color: Colors.grey.shade200, height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add_circle, color: Colors.blue),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...exercises,
      ],
    );
  }
}
