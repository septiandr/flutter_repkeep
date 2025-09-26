import '../models/excercise_model.dart';

class DummyData {
  static List<Exercise> exercises = [
    Exercise(
      id: 1,
      name: 'Push Up',
      sets: 3,
      reps: 15,
      duration: 0,
      grade: WorkoutGrade.good,
      note: 'Pemanasan ringan',
      categoryId: 1,
      dayId: 1, // Senin
    ),
    Exercise(
      id: 2,
      name: 'Pull Up',
      sets: 3,
      reps: 10,
      duration: 0,
      grade: WorkoutGrade.perfect,
      note: 'Fokus punggung',
      categoryId: 2,
      dayId: 2, // Selasa
    ),
    Exercise(
      id: 3,
      name: 'Squat',
      sets: 4,
      reps: 20,
      duration: 0,
      grade: WorkoutGrade.bad,
      note: 'Capek banget',
      categoryId: 3,
      dayId: 3, // Rabu
    ),
    Exercise(
      id: 4,
      name: 'Plank',
      sets: 1,
      reps: 1,
      duration: 120, // 2 menit
      grade: WorkoutGrade.good,
      note: 'Core strength',
      categoryId: 4,
      dayId: 4, // Kamis
    ),
    Exercise(
      id: 5,
      name: 'Running',
      sets: 1,
      reps: 1,
      duration: 1800, // 30 menit
      grade: WorkoutGrade.good,
      note: 'Lari sore',
      categoryId: 4,
      dayId: 6, // Sabtu
    ),
  ];
}
