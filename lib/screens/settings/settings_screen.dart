import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1A2332),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.displayName ?? "Kigali Resident",
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  user?.email ?? "",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2332),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SwitchListTile(
              title: const Text("Location Notifications", style: TextStyle(color: Colors.white)),
              subtitle: const Text("Enable for nearby place alerts", style: TextStyle(color: Colors.white70)),
              value: _notificationsEnabled,
              onChanged: (bool value) => setState(() => _notificationsEnabled = value),
              activeColor: Colors.orange,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2332),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.orange),
              title: const Text("Logout", style: TextStyle(color: Colors.white)),
              onTap: () => Provider.of<AuthProvider>(context, listen: false).logOut(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D1B2A),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Bookmarks"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}