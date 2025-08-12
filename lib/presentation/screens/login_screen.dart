import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitree/core/routes.dart';
import 'package:habitree/presentation/widgets/error_snackbar.dart';
import 'package:habitree/providers/login_provider.dart';
import 'package:habitree/presentation/widgets/auth_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void togglePassword() => setState(() => isVisible = !isVisible);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> checkUserFlow() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get();

    final data = doc.data()?["habits"] as List;    

    if (!mounted) return;
    if (data.isNotEmpty) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.habitWizard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF9F6EF),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "Habitree 🌱",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2F5233),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Grow your forest by building habits",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Reusable AuthCard
                  AuthCard(
                    title: "Sign In",
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: emailController,
                          label: "Email",
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (v) => ref.read(myLoginProvider).email = v,
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: passwordController,
                          label: "Password",
                          obscureText: !isVisible,
                          onChanged: (v) => ref.read(myLoginProvider).password = v,
                          suffixIcon: GestureDetector(
                            onTap: togglePassword,
                            child: Icon(
                              isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        AuthButton(
                          text: "Sign In",
                          onPressed: () async {
                            final emailError = ref.read(myLoginProvider).validateEmail();
                            final passwordError = ref.read(myLoginProvider).validatePassword();

                            if (emailError != null || passwordError != null) {
                              showCustomSnackBar(
                                context,
                                emailError ?? passwordError!,
                              );

                              return;
                            }

                            try {
                              final success = await ref.read(myLoginProvider).login();
                              if (success) {
                                checkUserFlow();
                              } else {
                                showCustomSnackBar(
                                  context,
                                  "Login failed. Please try again.",
                                );
                              }
                            } catch (e) {
                              showCustomSnackBar(
                                context,
                                e.toString().replaceFirst("Exception: ", ""),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Signup navigation
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      children: [
                        const TextSpan(text: "Need an account? "),
                        TextSpan(
                          text: "Create here",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF3E7C59),
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, AppRoutes.signup);
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
