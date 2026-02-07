import 'package:flutter/material.dart';
import 'package:safe_space/controller/auth_services.dart';
import 'package:safe_space/model/colors.dart';
import 'package:safe_space/view/screens/signup_page.dart';
import 'package:safe_space/view/widgets/cMaterialButton.dart';
import 'package:safe_space/view/widgets/cTextField.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brown,
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sign In to SafeSpace", style: TextStyle(fontSize: 30)),
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
                    onPressed: () {
                      _authController.signIn(
                        context,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                    },
                    text: "Sign In",
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
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => SignupPage(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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
      ),
    );
  }
}
