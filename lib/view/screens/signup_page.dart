import 'package:flutter/material.dart';
import 'package:safe_space/controller/floating_snackbar_service.dart';
import 'package:safe_space/model/colors.dart';
import 'package:safe_space/view/screens/login_page.dart';
import 'package:safe_space/view/widgets/cLogo.dart';
import 'package:safe_space/view/widgets/cMaterialButton.dart';
import 'package:safe_space/view/widgets/cTextField.dart';

import '../../controller/auth_services.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final AuthController authController = AuthController();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (_isLoading) return;

    // Validate passwords match
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      FloatingSnackbarService.showError(context, "Passwords do not match");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await authController.signUp(
        email: emailController.text,
        password: passwordController.text,
        context: context,
      );
      // Clear fields on successful signup
      if (mounted) {
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildChatBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.brown, // base color
          image: DecorationImage(
            image: AssetImage('assets/chat_doodle.png'),
            repeat: ImageRepeat.repeat,
            opacity: 0.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brown,
      body: Stack(
        children: [
          _buildChatBackground(),

          ListView(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Sign Up to ", style: TextStyle(fontSize: 25)),
                          cLogo(fontSize: 35),
                        ],
                      ),
                      SizedBox(height: 55),
                      Text(
                        "Email Address",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 10),
                      GlowingTextField(
                        hint: "Enter your email",
                        icon: Icons.email,
                        textController: emailController,
                      ),
                      SizedBox(height: 35),
                      Text(
                        "Password",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 10),
                      GlowingTextField(
                        hint: "Enter your password",
                        icon: Icons.lock_open_rounded,
                        isPassword: true,
                        textController: passwordController,
                      ),
                      SizedBox(height: 35),
                      Text(
                        "Confirm Password",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 10),
                      GlowingTextField(
                        hint: "Re-type your password",
                        icon: Icons.lock_open_rounded,
                        isPassword: true,
                        textController: confirmPasswordController,
                      ),

                      SizedBox(height: 35),
                      cMaterialButton(
                        text: "Sign Up Now",
                        onPressed: _handleSignUp,
                        isLoading: _isLoading,
                      ),

                      SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Text(
                              " Sign In Now",
                              style: TextStyle(color: AppColors.green),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
