import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthRepository {
  AuthRepository({required this.auth});
  FirebaseAuth auth;

  Future<void> firebaseSignInWithEmailPassword(
      String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (error) {
      print('PlatformException occurred: ${error.message}');
      throw AuthError(
        code: error.code,
        message: getErrorMessage(error.code),
      );
      // rethrow;
    } on FirebaseAuthException catch ( error) {
      print('FirebaseAuthError : ${error.code}');
      
      throw AuthError(
        code: error.code,
        message: getErrorMessage(error.code),
      );
    } catch (error) {
      print('Other exception occurred: ${error}');
      rethrow;
      // throw AuthError(
      //   code: error.code,
      //   message: getErrorMessage(error.code),
      // );
    }
  }

  firebaseSignOut() async {
    await auth.signOut();
  }

  User? getUser() {
    return auth.currentUser;
  }

  StreamSubscription<User?> authStateChanges() {
    return auth.authStateChanges().listen((event) {});
  }
}

class AuthError {
  final String code;
  final String message;

  AuthError({
    required this.code,
    required this.message,
  });
}

String getErrorMessage(String errorCode) {
  switch (errorCode) {
    case "invalid-email":
      return "유효하지 않은 이메일입니다.";
    case "wrong-password":
      return "잘못된 비밀번호";
    case "user-not-found":
      return "존재하지 않는 사용자입니다.";
    case "user-disabled":
      return "사용 정지된 유저입니다.";
    default:
      return "알 수 없는 에러가 발생했습니다.";
  }
}
