import 'package:flutter/material.dart';
import 'package:safe_space/model/colors.dart';
import 'package:safe_space/view/widgets/cMaterialButton.dart';
import 'package:safe_space/view/widgets/cTextField.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brown,
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sign Up to SafeSpace", style: TextStyle(fontSize: 30)),
                  SizedBox(height: 55),
                  Text(
                    "Email Address",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const GlowingTextField(
                    hint: "Enter your email",
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 35),
                  Text(
                    "Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const GlowingTextField(
                    hint: "Enter your password",
                    icon: Icons.lock_open_rounded,
                    isPassword: true,
                  ),
                  const SizedBox(height: 35),
                  Text(
                    "Confirm Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const GlowingTextField(
                    hint: "Re-type your password",
                    icon: Icons.lock_open_rounded,
                    isPassword: true,
                  ),

                  const SizedBox(height: 35),

                  cMaterialButton(buttonFunction: () {}, text: "Sign Up Now"),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SignupPage()),
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
