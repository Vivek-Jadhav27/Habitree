import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitree/data/models/user_model.dart';

class AuthService {
  static bool loginStatus = false;

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {

    if (!RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password)) {
      throw FirebaseAuthException(
        code: 'weak-password',
        message:
            'Password must be at least 8 characters long, contain at least one upper case letter and one number.',
      );
    }

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'uid': user.uid,
          'habits': [],
          'streak': 0,
          'longestStreak': 0,
          'lastCompletedDate': null,
        });

        return true;
      }

      return false;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  static Future<bool> logIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return true;
      }
      return false;
    } on Exception catch (e) {
      throw e;
    }
  }

  static Future isLoggedIn() async {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        UserModel userModel = UserModel(
          uid: user.uid,
          name: user.displayName,
          email: user.email,
          habits: [],
          streak: 0,
          longestStreak: 0,
          lastCompletedDate: null,
        );

        loginStatus = true;
        print(userModel.toJson());
      }
    });
  }
}
