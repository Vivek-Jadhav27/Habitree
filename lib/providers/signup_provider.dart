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

  Future<bool> signUp() async {
    if((email != null) && (password != null) && (name != null)) {
      return await AuthService.signUp(name: name!, email: email!, password: password!);
    } else {
      return false;
    }
  }


}
