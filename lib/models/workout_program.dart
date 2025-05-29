class WorkoutProgram {
  final int workoutProgramId;
  final String programName;
  final String? description;

  WorkoutProgram({
    required this.workoutProgramId,
    required this.programName,
    this.description,
  });

  factory WorkoutProgram.fromJson(Map<String, dynamic> json) {
    return WorkoutProgram(
      workoutProgramId: json['workout_program_id'],
      programName: json['program_name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workout_program_id': workoutProgramId,
      'program_name': programName,
      'description': description,
    };
  }
}
