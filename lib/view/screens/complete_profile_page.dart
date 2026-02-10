import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_space/controller/floating_snackbar_service.dart';
import 'package:safe_space/model/colors.dart';
import 'package:safe_space/view/widgets/cMaterialButton.dart';
import 'package:safe_space/view/widgets/cTextField.dart';
import 'package:safe_space/view/widgets/main_navigation.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final usernameController = TextEditingController();
  final semesterController = TextEditingController();

  String? selectedDepartment;
  bool _isLoading = false;

  final List<String> departments = [
    'Computer Engineering',
    'Information Technology',
    'ICT',
    'Mechanical',
    'Civil',
    'Electrical',
  ];

  @override
  void initState() {
    super.initState();
    _checkProfileCompletion();
  }

  Future<void> _checkProfileCompletion() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        final hasUsername =
            data?['username'] != null &&
            (data?['username'] as String).trim().isNotEmpty;
        final hasSemester = data?['semester'] != null;
        final hasDepartment =
            data?['department'] != null &&
            (data?['department'] as String).trim().isNotEmpty;

        if (hasUsername && hasSemester && hasDepartment) {
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainNavigation()),
              (Route<dynamic> route) => false,
            );
          }
        }
      }
    } catch (e) {
      print('Error checking profile: $e');
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    semesterController.dispose();
    super.dispose();
  }

  void _handleCompleteProfile() async {
    if (_isLoading) return;

    if (usernameController.text.trim().isEmpty) {
      FloatingSnackbarService.showWarning(context, "Username is required");
      return;
    }

    if (semesterController.text.trim().isEmpty) {
      FloatingSnackbarService.showWarning(context, "Semester is required");
      return;
    }

    if (selectedDepartment == null || selectedDepartment!.isEmpty) {
      FloatingSnackbarService.showWarning(context, "Department is required");
      return;
    }

    int? semester;
    try {
      semester = int.parse(semesterController.text.trim());
      if (semester < 1 || semester > 8) {
        FloatingSnackbarService.showWarning(
          context,
          "Semester must be between 1 and 8",
        );
        return;
      }
    } catch (e) {
      FloatingSnackbarService.showWarning(
        context,
        "Semester must be a valid number",
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'username': usernameController.text.trim(),
        'semester': semester,
        'department': selectedDepartment,
      });

      if (mounted) {
        FloatingSnackbarService.showSuccess(
          context,
          "Profile completed successfully!",
          duration: const Duration(seconds: 2),
        );
      }

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainNavigation()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        FloatingSnackbarService.showError(
          context,
          "Failed to save profile. Please try again.",
        );
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
          color: AppColors.brown,
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Complete Your Profile",
                            style: TextStyle(fontSize: 25),
                          ),
                        ],
                      ),
                      const SizedBox(height: 55),
                      Text(
                        "Username",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GlowingTextField(
                        hint: "Enter your username",
                        icon: Icons.person,
                        textController: usernameController,
                      ),
                      const SizedBox(height: 35),
                      Text(
                        "Semester",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GlowingTextField(
                        hint: "Enter your semester (1-8)",
                        icon: Icons.school,
                        textController: semesterController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 35),
                      Text(
                        "Department",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildDepartmentDropdown(),
                      const SizedBox(height: 35),
                      cMaterialButton(
                        text: "Complete Profile",
                        onPressed: _handleCompleteProfile,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 35),
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

  Widget _buildDepartmentDropdown() {
    return DropdownButtonFormField<String>(
      dropdownColor: AppColors.mediumBrown,
      value: selectedDepartment,
      hint: Text(
        'Select your department',
        style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
      ),
      icon: Icon(Icons.arrow_drop_down, color: Colors.white70),
      items: departments.map((dept) {
        return DropdownMenuItem<String>(
          value: dept,
          child: Text(dept, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedDepartment = value;
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.green, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16),
    );
  }
}
