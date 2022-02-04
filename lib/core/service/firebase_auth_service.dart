import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseAuthService {
  static final _firebaseAuth = FirebaseAuth.instance;
  Future<UserCredential> registerUser(
    String email,
    String password,
    String username,
  ) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      final errorText = getMessageFromErrorCode(e.code);
      Get.defaultDialog(title: "Error", middleText: errorText);

      return Future.error(e.code);
    } on FirebaseException catch (e) {
      return Future.error(e.code);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> logUserIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      final errorText = getMessageFromErrorCode(e.code);
      Get.defaultDialog(
          title: "Error",
          middleText: errorText,
          titleStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          middleTextStyle: TextStyle());

      print(e.code);
    } on FirebaseException catch (e) {
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  Future<void> logUserOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e.code);
    } on FirebaseException catch (e) {
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  String getCurrentUserUid() {
    try {
      return _firebaseAuth.currentUser!.uid;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      rethrow;

      // return Future.error(e.code);
    } on FirebaseException catch (e) {
      print(e.code);
      rethrow;
      // return Future.error(e.code);
    } catch (e) {
      print(e);
      rethrow;

      // return Future.error(e);
    }
  }

  String getMessageFromErrorCode(String code) {
    final errorText = () {
      switch (code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          return "Email already used. Go to login page.";
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          return "Wrong email/password combination.";
        // case "ERROR_USER_NOT_FOUND":
        // case "user-not-found":
        //   return "No user found with this email.";
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          return "User disabled.";
        case "ERROR_TOO_MANY_REQUESTS":
        case "too-many-requests":
          return "Too many requests to log into this account.";
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          return "Server error, please try again later.";
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          return "Email address is invalid.";
        default:
          return "Login failed. Please try again.";
      }
    }.call();
    return errorText;
  }
}
