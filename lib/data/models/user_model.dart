class UserModel {
  final String uid;
  final String? name;
  final String? email;
  final List<String> habits;
  final int streak; 
  final int longestStreak; 
  final DateTime? lastCompletedDate;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.habits,
    required this.streak,
    required this.longestStreak,
    this.lastCompletedDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String uid) {
    return UserModel(
      uid: uid,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      habits: List<String>.from(json['habits'] ?? []),
      streak: json['streak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastCompletedDate: json['lastCompletedDate'] != null
          ? DateTime.tryParse(json['lastCompletedDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'habits': habits,
      'streak': streak,
      'longestStreak': longestStreak,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
    };
  }
}
