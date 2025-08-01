import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitree/core/routes.dart';

class HabitWizardScreen extends StatefulWidget {
  const HabitWizardScreen({super.key});

  @override
  State<HabitWizardScreen> createState() => _HabitWizardScreenState();
}

class _HabitWizardScreenState extends State<HabitWizardScreen> {
  final PageController _pageController = PageController();
  final TextEditingController habit1Controller = TextEditingController();
  final TextEditingController habit2Controller = TextEditingController();
  final TextEditingController habit3Controller = TextEditingController();

  int _currentStep = 0;

  void _nextPage() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _saveHabits();
    }
  }

  Future<void> _saveHabits() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final habits = [
      habit1Controller.text.trim(),
      habit2Controller.text.trim(),
      habit3Controller.text.trim(),
    ].where((h) => h.isNotEmpty).toList(); // remove empty

    if (habits.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter at least one habit")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection("users").doc(userId).update({
      "habits": habits,
    });

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  Widget _buildStep({
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required int step,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
              children: [
                Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2F5233),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: "Enter habit",
                    labelStyle: GoogleFonts.poppins(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF4F0E6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E7C59),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      step == 2 ? "Finish" : "Next",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Step indicator
                Text(
                  "Step ${step + 1} of 3",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6EF),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildStep(
            title: "Let’s grow your forest 🌱",
            subtitle: "What’s the first habit you want to track daily?",
            controller: habit1Controller,
            step: 0,
          ),
          _buildStep(
            title: "Awesome! 🎉",
            subtitle: "Now enter your second habit",
            controller: habit2Controller,
            step: 1,
          ),
          _buildStep(
            title: "One more step! 💪",
            subtitle: "Enter your third habit",
            controller: habit3Controller,
            step: 2,
          ),
        ],
      ),
    );
  }
}
