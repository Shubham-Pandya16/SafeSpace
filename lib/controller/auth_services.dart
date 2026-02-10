import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'floating_snackbar_service.dart';

class AuthController {
  final FirebaseAuth _authService = FirebaseAuth.instance;

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        FloatingSnackbarService.showWarning(
          context,
          "Please fill in all fields",
        );
        return;
      }

      await _authService.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (context.mounted) {
        FloatingSnackbarService.showSuccess(
          context,
          "Login successful!",
          duration: const Duration(seconds: 2),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        String message = _getErrorMessage(e.code);
        FloatingSnackbarService.showError(context, message);
      }
    } catch (e) {
      if (context.mounted) {
        FloatingSnackbarService.showError(
          context,
          "An unexpected error occurred",
        );
      }
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        FloatingSnackbarService.showWarning(
          context,
          "Please fill in all fields",
        );
        return;
      }

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

      if (context.mounted) {
        FloatingSnackbarService.showSuccess(
          context,
          "Account created successfully!",
          duration: const Duration(seconds: 2),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        String message = _getErrorMessage(e.code);
        FloatingSnackbarService.showError(context, message);
      }
    } catch (e) {
      if (context.mounted) {
        FloatingSnackbarService.showError(context, "Failed to create account");
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        FloatingSnackbarService.showSuccess(
          context,
          "Logged out successfully",
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      if (context.mounted) {
        FloatingSnackbarService.showError(context, "Failed to log out");
      }
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return "Email already registered";
      case 'weak-password':
        return "Password too weak";
      case 'user-not-found':
        return "User not found";
      case 'wrong-password':
        return "Incorrect password";
      case 'invalid-email':
        return "Invalid email address";
      case 'operation-not-allowed':
        return "Operation not allowed";
      case 'too-many-requests':
        return "Too many attempts. Try again later";
      default:
        return "Authentication failed";
    }
  }
}
