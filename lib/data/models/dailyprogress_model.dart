class DailyProgress {
  final String date; 
  final int completedTasks; 
  final bool rewarded; 
  final List<bool> completedList; 

  DailyProgress({
    required this.date,
    required this.completedTasks,
    required this.rewarded,
    required this.completedList,
  });

  Map<String, dynamic> toMap() => {
        "date": date,
        "completedTasks": completedTasks,
        "rewarded": rewarded,
        "completedList": completedList,
      };

  factory DailyProgress.fromMap(Map<String, dynamic> map) => DailyProgress(
        date: map["date"],
        completedTasks: map["completedTasks"],
        rewarded: map["rewarded"],
        completedList: List<bool>.from(map["completedList"] ?? [false, false, false]),
      );
}
