import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/patient_provider.dart';
import 'theme/app_theme.dart';
import 'views/login_screen.dart';
import 'views/intakes_page.dart';
import 'views/home_screen.dart';
import 'views/notifications_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PatientModel(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: const LoginScreen(), // Set LoginScreen as the initial screen
    );
  }
}

class MainBottomNavigation extends StatefulWidget {
  const MainBottomNavigation({super.key});

  @override
  _MainBottomNavigationState createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    IntakesPage(),          // Intakes page
    NotificationsPage(),     // Notifications page
    PatientListPage(),       // Treatments (Home Screen)
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: "Intakes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: "Treatments",
          ),
        ],
      ),
    );
  }
}
