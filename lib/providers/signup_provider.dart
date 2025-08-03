import 'package:flutter/foundation.dart';
import 'package:habitree/data/services/auth_service.dart';

class SignupProvider extends ChangeNotifier {
  String? name;
  String? email;
  String? password;

  void getName(String name) {
    this.name = name;
    notifyListeners();
  }

  void getEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void getPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  String? validateName() {
    if (name == null || name!.isEmpty) {
      return "Name is required";
    }
    return null;
  }

  String? validateEmail() {
    if (email == null || email!.isEmpty) {
      return "Email is required";
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email!)) {
      return "Enter a valid email address";
    }
    return null;
  }

  String? validatePassword() {
    if (password == null || password!.isEmpty) {
      return "Password is required";
    }
    if (!RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password!)) {
      return "Password must be 8+ chars, 1 uppercase & 1 number";
    }
    return null;
  }

  Future<bool> signUp() async {
    if (validateName() != null ||
        validateEmail() != null ||
        validatePassword() != null) {
      return false; // validation failed
    }
    return await AuthService.signUp(
      name: name!,
      email: email!,
      password: password!,
    );
  }
}
