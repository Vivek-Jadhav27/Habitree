import 'package:flutter/foundation.dart';
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

  Future<bool> login() async {
    if((email != null) && (password != null)) {
      return await AuthService.logIn(email: email!, password: password!);
    } else {
      return false;
    }
  }
}
