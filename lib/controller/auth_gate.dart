import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safe_space/view/screens/complete_profile_page.dart';
import 'package:safe_space/view/screens/login_page.dart';
import 'package:safe_space/view/widgets/main_navigation.dart';

import '../model/colors.dart';
import '../view/screens/signup_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _showSignup = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 1,
                      child: SvgPicture.asset(
                        'assets/wave_background.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }

        if (!authSnapshot.hasData || authSnapshot.data == null) {
          return _showSignup
              ? SignupPage(
                  onBackToLogin: () {
                    setState(() => _showSignup = false);
                  },
                )
              : LoginPage(
                  onCreateAccount: () {
                    setState(() => _showSignup = true);
                  },
                );
        }

        return _buildUserRoute(authSnapshot.data!);
      },
    );
  }

  Widget _buildUserRoute(User user) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.brown,
            body: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 1,
                    child: SvgPicture.asset(
                      'assets/wave_background.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: CircularProgressIndicator(
                      color: AppColors.lightGrey,
                      padding: EdgeInsets.all(25),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return const CompleteProfilePage();
        }

        final data = userSnapshot.data!.data() as Map<String, dynamic>;

        final hasUsername =
            data['username'] is String && data['username'].trim().isNotEmpty;

        final hasSemester = data['semester'] is int;

        final hasDepartment =
            data['department'] is String &&
            data['department'].trim().isNotEmpty;

        if (!hasUsername || !hasSemester || !hasDepartment) {
          return const CompleteProfilePage();
        }

        return const MainNavigation();
      },
    );
  }
}
