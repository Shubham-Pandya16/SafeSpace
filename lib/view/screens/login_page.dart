import 'package:flutter/material.dart';
import 'package:safe_space/controller/auth_services.dart';
import 'package:safe_space/model/colors.dart';
// AuthGate will provide navigation callbacks; avoid creating routes here
import 'package:safe_space/view/widgets/cMaterialButton.dart';
import 'package:safe_space/view/widgets/cTextField.dart';

import '../widgets/cLogo.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onCreateAccount;

  const LoginPage({super.key, required this.onCreateAccount});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final AuthController _authController = AuthController();

  void _handleSignIn() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      await _authController.signIn(
        email: emailController.text,
        password: passwordController.text,
        context: context,
      );
      // Clear fields on successful login
      if (mounted) {
        emailController.clear();
        passwordController.clear();
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
            opacity: 0.7,
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
              Padding(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Sign In to ", style: TextStyle(fontSize: 25)),
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
                    cMaterialButton(
                      onPressed: _handleSignIn,
                      text: "Sign In",
                      isLoading: _isLoading,
                    ),
                    SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: widget.onCreateAccount,
                          child: Text(
                            " Sign Up Now",
                            style: TextStyle(color: AppColors.green),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
