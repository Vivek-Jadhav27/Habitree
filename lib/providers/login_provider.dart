import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitree/data/services/auth_service.dart';

class LoginProvider extends ChangeNotifier {
  String? email;
  String? password;

  void getEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void getPassword(String password) {
    this.password = password;
    notifyListeners();
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
    if (password!.length < 8) {
      return "Password must be at least 8 characters";
    }
    return null;
  }

  Future<bool> login() async {
    if (validateEmail() != null || validatePassword() != null) {
      return false; // validation failed
    }
    try {
      return await AuthService.logIn(email: email!, password: password!);
    } on Exception catch (e) {
      throw e;
    }
  }
}

final myLoginProvider = ChangeNotifierProvider<LoginProvider>(
  (ref) => LoginProvider(),
);
