import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<String>> getUserHabits() async {
    final userId = auth.currentUser!.uid;

    final doc = await firestore.collection("users").doc(userId).get();

    if (!doc.exists) return ["", "", ""];

    final habits = List<String>.from(doc.data()?['habits'] ?? []);

    while (habits.length < 3) {
      habits.add("");
    }

    return habits.take(3).toList();
  }

  Future<List<bool>> getTodayProgress(int habitCount) async {
    final userId = auth.currentUser!.uid;
    final today = DateTime.now().toIso8601String().split("T")[0]; // YYYY-MM-DD

    final doc = await firestore
        .collection("users")
        .doc(userId)
        .collection("dailyProgress")
        .doc(today)
        .get();

    if (!doc.exists) {
      return List.filled(habitCount, false); // default all unchecked
    }

    // We need to store progress as a list of bools in Firestore
    final data = doc.data()!;
    List completedList = data["completedList"] ?? [];

    return List.generate(
      habitCount,
      (index) => index < completedList.length ? completedList[index] : false,
    );
  }

  Future<void> saveDailyProgress(
    List<bool> completed, {
    DateTime? forDate,
  }) async {
    final userId = auth.currentUser!.uid;

    // Use provided simulated date, else fallback to today
    final date = (forDate ?? DateTime.now()).toIso8601String().split("T")[0];

    await firestore
        .collection("users")
        .doc(userId)
        .collection("dailyProgress")
        .doc(date)
        .set({
          "date": date,
          "completedTasks": completed.where((c) => c).length,
          "rewarded": completed.every((c) => c),
          "completedList": completed,
        });

    if (completed.every((c) => c)) {
      print("Streak updated");
      await updateStreak();
    }
  }

  Future<int> updateStreak() async {
    final userId = auth.currentUser!.uid;
    final userDoc = firestore.collection("users").doc(userId);

    final doc = await userDoc.get();

    if (!doc.exists) {
      await userDoc.set({
        "streak": 1,
        "longestStreak": 1,
        "lastCompletedDate": DateTime.now().toIso8601String(),
      });
      return 1;
    }

    final data = doc.data()!;
    int currentStreak = data["streak"] ?? 0;
    int longestStreak = data["longestStreak"] ?? 0;
    DateTime? lastStreakDate = data["lastCompletedDate"] != null
        ? DateTime.tryParse(data["lastCompletedDate"])
        : null;

    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    if (lastStreakDate != null &&
        lastStreakDate.year == yesterday.year &&
        lastStreakDate.month == yesterday.month &&
        lastStreakDate.day == yesterday.day) {
      //  Continue streak
      currentStreak++;
    } else if (lastStreakDate != null &&
        lastStreakDate.year == today.year &&
        lastStreakDate.month == today.month &&
        lastStreakDate.day == today.day) {
      // Already counted today, no change
    } else {
      // Start new streak
      currentStreak = 1;
    }

    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }

    await userDoc.update({
      "streak": currentStreak,
      "longestStreak": longestStreak,
      "lastCompletedDate": today.toIso8601String(),
    });

    return currentStreak;
  }

  Future<int> getStreak() async {
    final userId = auth.currentUser!.uid;
    final doc = await firestore.collection("users").doc(userId).get();
    final data = doc.data()!;
    return data["streak"] ?? 0;
  }
}
