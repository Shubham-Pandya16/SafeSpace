import 'package:flutter/material.dart';
import 'package:safe_space/model/colors.dart';
import 'package:safe_space/view/screens/channels_page.dart';
import 'package:safe_space/view/screens/chatbot_page.dart';
import 'package:safe_space/view/screens/home_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    const HomePage(),
    const ChatBotPage(),
    const ChannelsPage(),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onNavTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.mediumBrown,
      selectedItemColor: AppColors.green,

      unselectedItemColor: Colors.white.withOpacity(0.6),
      elevation: 8,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: 24),
          activeIcon: Icon(Icons.home_filled, size: 24),
          label: 'Home',
          tooltip: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mark_chat_unread_outlined, size: 24),
          activeIcon: Icon(Icons.mark_chat_unread, size: 24),
          label: 'Chat',
          tooltip: 'Chat with SafeSpace.AI',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline, size: 24),
          activeIcon: Icon(Icons.people, size: 24),
          label: 'Community',
          tooltip: 'Community',
        ),
      ],
    );
  }
}
