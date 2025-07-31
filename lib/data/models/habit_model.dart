class Habit {
  final String id;
  final String title;

  Habit({
    required this.id,
    required this.title,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
      };

  factory Habit.fromMap(Map<String, dynamic> map) => Habit(
        id: map["id"],
        title: map["title"],
      );
}
