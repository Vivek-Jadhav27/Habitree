import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habitree/core/routes.dart';
import 'package:habitree/providers/forest_provider.dart';
import 'package:habitree/providers/habit_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool snackShown = false;
  Future<bool> _showExitDialog() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              "Exit Habitree?",
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2F5233),
              ),
            ),
            content: Text(
              "Are you sure you want to exit the app?",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2F5233),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E7C59),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  "Exit",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // if another route handled pop, do nothing

        final shouldExit = await _showExitDialog();
        if (shouldExit && mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F6EF),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFF9F6EF),
          elevation: 0,
          title: Text(
            "Habitree",
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2F5233),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.park_rounded, color: Color(0xFF2F5233)),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.gardenLibrary);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Consumer<HabitProvider>(
            builder: (context, habitProvider, child) {
              if (habitProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              double progress =
                  habitProvider.completed.where((c) => c).length /
                  habitProvider.habits.length;

              if (progress == 1.0 && !snackShown) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Congrats! You have completed all tasks !",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: const Color(0xFF3E7C59),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                });
                snackShown = true;
              }

              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Title
                            Text(
                              "Habitree ",
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2F5233),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Your digital forest grows as you complete your daily tasks.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Progress bar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Daily Progress",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF2F5233),
                                  ),
                                ),
                                Text(
                                  "${(progress * 100).toInt()}%",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 10,
                                backgroundColor: const Color(0xFFE5DED1),
                                color: const Color(0xFF3E7C59),
                              ),
                            ),
                            const SizedBox(height: 20),

                            Divider(color: Colors.grey[300]),
                            const SizedBox(height: 12),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Today's Grove",
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2F5233),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...List.generate(habitProvider.habits.length, (
                              index,
                            ) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F0E6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: CheckboxListTile(
                                  title: Text(
                                    habitProvider.habits[index],
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: const Color(0xFF2F2F2F),
                                    ),
                                  ),
                                  value: habitProvider.completed[index],
                                  onChanged: habitProvider.completed[index]
                                      ? null
                                      : (val) {
                                          if (val == true) {
                                            habitProvider.toggleHabit(
                                              index,
                                              true,
                                            );
                                          }
                                        },
                                  activeColor: const Color(0xFF3E7C59),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3E7C59),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Provider.of<ForestProvider>(
                            context,
                            listen: false,
                          ).loadForest();
                          Navigator.pushNamed(context, AppRoutes.forest);
                        },
                        child: Text(
                          "Go to Garden",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
