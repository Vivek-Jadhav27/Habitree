import 'package:flutter/material.dart';
import 'package:habitree/data/services/firestore_service.dart';
import 'package:habitree/providers/forest_provider.dart';

class HabitProvider extends ChangeNotifier {
  final FirestoreService firestoreService = FirestoreService();

  List<String> _habits = [];
  List<bool> _completed = [];
  bool _isLoading = true;

  int _streak = 0;

  List<String> get habits => _habits;
  List<bool> get completed => _completed;
  bool get isLoading => _isLoading;
  int get streak => _streak;

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();

    _habits = await firestoreService.getUserHabits();
    _completed = await firestoreService.getTodayProgress(_habits.length);
    _streak = await firestoreService.getStreak();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleHabit(int index, bool value, {DateTime? forDate}) async {
    _completed[index] = value;
    notifyListeners();

    await firestoreService.saveDailyProgress(_completed, forDate: forDate);

    if (_completed.every((c) => c)) {
      ForestProvider().loadForest().then(
        (_) => ForestProvider().growTreeWithDate(forDate ?? DateTime.now()),
      );
    }
    notifyListeners();
  }

  void resetDailyProgress() {
    _completed = List.filled(_habits.length, false);
    notifyListeners();
  }
}
