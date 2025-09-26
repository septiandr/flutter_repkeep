import '../models/check_entry.dart';

String gradeText(WorkoutGrade grade) {
  switch (grade) {
    case WorkoutGrade.perfect:
      return "🌟 Sempurna";
    case WorkoutGrade.good:
      return "✅ Selesai";
    case WorkoutGrade.bad:
      return "❌ Tidak";
  }
}
