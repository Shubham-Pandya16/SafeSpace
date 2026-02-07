import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController {
  final FirebaseAuth _authService = FirebaseAuth.instance;

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _authService.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _authService
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      final uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "uid": uid,
        "email": email.trim(),
        "createdAt": FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Logged out")));
  }

  void _showError(BuildContext context, String code) {
    String message;

    switch (code) {
      case 'email-already-in-use':
        message = "Email already registered";
        break;
      case 'weak-password':
        message = "Password too weak";
        break;
      case 'user-not-found':
        message = "User not found";
        break;
      case 'wrong-password':
        message = "Incorrect password";
        break;
      default:
        message = "Authentication failed";
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
