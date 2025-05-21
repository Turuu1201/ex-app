import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/ocr_screen.dart';
import 'screens/add_medicine_screen.dart';
import 'screens/gpt_medicine_chatbot_screen.dart';
import 'screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    OcrScreen(),
    AddMedicineScreen(),
    GptMedicineChatbotScreen(),
    ProfileScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Нүүр'),
    BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'OCR'),
    BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Нэмэх'),
    BottomNavigationBarItem(
        icon: Icon(Icons.chat), label: 'Чатбот'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профайл'),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeef4ff),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        items: _navItems,
        backgroundColor: const Color(0xFFeef4ff),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF1D3557),
        unselectedItemColor: Colors.indigo.shade200,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          color: Colors.indigo.shade200,
        ),
        selectedIconTheme: const IconThemeData(size: 26),
        unselectedIconTheme: const IconThemeData(size: 24),
      ),
    );
  }
}
