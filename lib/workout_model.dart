// ============================================================
// workout_model.dart – Workout Data Model (updated: + userId)
// ============================================================

class Workout {
  final int?   id;
  final int    userId;       // ← NEW: links workout to a user
  final String workoutName;
  final String targetMuscle;
  final String duration;
  final String notes;

  const Workout({
    this.id,
    required this.userId,
    required this.workoutName,
    required this.targetMuscle,
    required this.duration,
    required this.notes,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'userId':       userId,
        'workoutName':  workoutName,
        'targetMuscle': targetMuscle,
        'duration':     duration,
        'notes':        notes,
      };

  factory Workout.fromMap(Map<String, dynamic> map) => Workout(
        id:           map['id']           as int?,
        userId:       map['userId']       as int? ?? 0,
        workoutName:  map['workoutName']  as String,
        targetMuscle: map['targetMuscle'] as String,
        duration:     map['duration']     as String,
        notes:        map['notes']        as String,
      );

  Workout copyWith({
    int?    id,
    int?    userId,
    String? workoutName,
    String? targetMuscle,
    String? duration,
    String? notes,
  }) =>
      Workout(
        id:           id           ?? this.id,
        userId:       userId       ?? this.userId,
        workoutName:  workoutName  ?? this.workoutName,
        targetMuscle: targetMuscle ?? this.targetMuscle,
        duration:     duration     ?? this.duration,
        notes:        notes        ?? this.notes,
      );
}
