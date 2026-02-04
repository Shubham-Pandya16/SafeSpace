import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brown,
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                    onPressed: () {
                      if (passwordController.text.trim() !=
                          confirmPasswordController.text.trim()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Passwords do not match"),
                          ),
                        );
                        return;
                      }

                      authController.signUp(
                        context,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                    },
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
    );
  }
}
