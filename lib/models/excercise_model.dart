enum WorkoutGrade { perfect, good, bad }

class Exercise {
  final int? id;
  final String name;
  final int sets;
  final int reps;
  final int duration; // detik
  final WorkoutGrade grade;
  final String note;
  final int categoryId;
  final int dayId;

  Exercise({
    this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.duration,
    this.grade = WorkoutGrade.good,
    this.note = '',
    required this.categoryId,
    required this.dayId,
  });

  /// copyWith untuk membuat salinan dengan beberapa field diubah
  Exercise copyWith({
    int? id,
    String? name,
    int? sets,
    int? reps,
    int? duration,
    WorkoutGrade? grade,
    String? note,
    int? categoryId,
    int? dayId,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      duration: duration ?? this.duration,
      grade: grade ?? this.grade,
      note: note ?? this.note,
      categoryId: categoryId ?? this.categoryId,
      dayId: dayId ?? this.dayId,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'sets': sets,
      'reps': reps,
      'duration': duration,
      'grade': grade.name,
      'note': note,
      'category_id': categoryId,
      'day_id': dayId,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as int?,
      name: map['name'] as String,
      sets: (map['sets'] as num).toInt(),
      reps: (map['reps'] as num).toInt(),
      duration: (map['duration'] ?? 0) as int,
      grade: WorkoutGrade.values.firstWhere(
        (g) => g.name == (map['grade'] ?? 'good'),
        orElse: () => WorkoutGrade.good,
      ),
      note: map['note'] as String? ?? '',
      categoryId: (map['category_id'] as num).toInt(),
      dayId: (map['day_id'] as num).toInt(),
    );
  }
}
