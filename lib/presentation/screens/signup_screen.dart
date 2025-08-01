import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitree/core/routes.dart';
import 'package:habitree/providers/signup_provider.dart';
import 'package:habitree/presentation/widgets/auth_widgets.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isVisible = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void togglePassword() => setState(() => isVisible = !isVisible);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (context, provider, _) => Scaffold(
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
                    "Create your account and grow habits",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Reusable AuthCard
                  AuthCard(
                    title: "Sign Up",
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: nameController,
                          label: "Name",
                          keyboardType: TextInputType.name,
                          onChanged: provider.getName,
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: emailController,
                          label: "Email",
                          keyboardType: TextInputType.emailAddress,
                          onChanged: provider.getEmail,
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: passwordController,
                          label: "Password",
                          obscureText: !isVisible,
                          onChanged: provider.getPassword,
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
                          text: "Sign Up",
                          onPressed: () {
                            if (nameController.text.isEmpty ||
                                emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please fill all fields"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            provider.signUp().then((value) {
                              if (value) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.login,
                                );
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Login navigation
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      children: [
                        const TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: "Login here",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF3E7C59),
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, AppRoutes.login);
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
      ),
    );
  }
}
