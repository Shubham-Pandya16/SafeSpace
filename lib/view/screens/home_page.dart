import 'package:flutter/material.dart';
import 'package:safe_space/view/widgets/cLogo.dart';
import 'package:safe_space/view/widgets/cMaterialButton.dart';

import '../../controller/auth_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: cLogo(fontSize: 35), centerTitle: true),
      body: Center(
        child: Column(
          children: [
            cMaterialButton(
              text: "SignOut",
              onPressed: () {
                authController.signOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
