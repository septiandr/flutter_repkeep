import 'check_entry.dart';

class WorkoutLog {
  final DateTime date;
  final List<CheckEntry> entries;

  WorkoutLog({required this.date, this.entries = const []});
}
