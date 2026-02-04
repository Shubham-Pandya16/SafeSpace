import 'package:flutter/material.dart';
import 'package:safe_space/view/widgets/cLogo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: cLogo(fontSize: 35), centerTitle: true),
    );
  }
}
