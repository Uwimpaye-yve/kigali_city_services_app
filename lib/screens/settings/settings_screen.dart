class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false; // Simulation of local preference

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user; // Display user profile

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? "Kigali Resident"),
            accountEmail: Text(user?.email ?? ""),
            currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
          ),
          SwitchListTile(
            title: const Text("Location Notifications"),
            subtitle: const Text("Enable for nearby place alerts"),
            value: _notificationsEnabled,
            onChanged: (bool value) => setState(() => _notificationsEnabled = value), // Toggle requirement
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () => Provider.of<AuthProvider>(context, listen: false).logOut(),
          ),
        ],
      ),
    );
  }
}