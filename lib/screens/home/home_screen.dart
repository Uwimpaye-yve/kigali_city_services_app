import 'package:flutter/material.dart';
import '../directory/directory_screen.dart';
import '../settings/settings_screen.dart';
import '../directory/bookmarks_screen.dart';
import '../directory/map_view_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DirectoryScreen(),
    const BookmarksScreen(),
    const MapViewScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0D1B2A),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white60,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Bookmarks"),
          BottomNavigationBarItem(icon: Icon(Icons.rate_review), label: "Reviews"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
