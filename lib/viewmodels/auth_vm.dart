import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:com.design.studiovie/models/data/auth_repository.dart';

class AuthViewModel with ChangeNotifier {
  User? _user;
  User? get user => _user;
  bool isLoggedIn = true;

  final AuthRepository _authRepository;
  AuthViewModel(this._authRepository);

  final authKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future signIn() async {
    try {
      String email = emailController.text;
      String password = passwordController.text;
      await _authRepository.firebaseSignInWithEmailPassword(email, password);
      getUser();
    } on AuthError catch (err) {
      print(err.message);
      rethrow;
    }
  }

  signOut() async {
    await _authRepository.firebaseSignOut();
    getUser();
  }

  getUser() {
    _user = _authRepository.getUser();
    notifyListeners();
  }

  void disposeLoginControllers() {
    emailController.text = '';
    passwordController.text = '';
  }
}
