import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitree/core/routes.dart';
import 'package:provider/provider.dart';
import 'package:habitree/providers/forest_provider.dart';
import 'package:habitree/providers/habit_provider.dart';

class ForestTestScreen extends StatefulWidget {
  const ForestTestScreen({super.key});

  @override
  State<ForestTestScreen> createState() => _ForestTestScreenState();
}

class _ForestTestScreenState extends State<ForestTestScreen> {
  late DateTime _simulatedDate;

  @override
  void initState() {
    super.initState();
    _simulatedDate = DateTime.now().subtract(const Duration(days: 7));

    // Load habits at test start
    Future.microtask(
      () => Provider.of<HabitProvider>(context, listen: false).loadHabits(),
    );
  }

  Future<void> _nextDay() async {
    final forestProvider = context.read<ForestProvider>();
    final habitProvider = context.read<HabitProvider>();

    // Save progress for simulated date
    await habitProvider.firestoreService.saveDailyProgress(
      habitProvider.completed,
      forDate: _simulatedDate,
    );

    // Grow only if all tasks done
    if (habitProvider.completed.isNotEmpty &&
        habitProvider.completed.every((c) => c)) {
      await forestProvider.loadForest().then(
        (_) => forestProvider.growTreeWithDate(_simulatedDate),
      );
    }

    // Move forward
    setState(() {
      _simulatedDate = _simulatedDate.add(const Duration(days: 1));
    });

    habitProvider.resetDailyProgress();

    if (mounted) {
      Navigator.pushNamed(context, AppRoutes.forest);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6EF),
      appBar: AppBar(
        title: const Text("Forest Tester 🌱"),
        backgroundColor: const Color(0xFF3E7C59),
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          if (habitProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Simulated Date",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${_simulatedDate.toLocal()}".split(" ")[0],
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2F5233),
                  ),
                ),
                const SizedBox(height: 20),

                // ✅ Real habits list
                Expanded(
                  child: ListView.builder(
                    itemCount: habitProvider.habits.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(
                          habitProvider.habits[index],
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                        value: habitProvider.completed[index],
                        onChanged: habitProvider.completed[index]
                            ? null
                            : (val) {
                                if (val == true) {
                                  habitProvider.toggleHabit(
                                    index,
                                    true,
                                    forDate: _simulatedDate,
                                  );
                                }
                              },
                      );
                    },
                  ),
                ),

                // Next Day button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextDay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E7C59),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Go to Next Day",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}
