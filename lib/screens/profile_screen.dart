import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(backgroundColor: Colors.purple),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top box with image
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 60, color: Colors.purple),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Name
            const Text(
              "Rhythm Chawla",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),

            const SizedBox(height: 10),

            // Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ListTile(
                  leading: Icon(Icons.email, color: Colors.purple),
                  title: Text("rhythm@email.com"),
                ),
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.purple),
                  title: Text("+1 437-667-5557"),
                ),
                ListTile(
                  leading: Icon(Icons.person, color: Colors.purple),
                  title: Text("Gender: Male"),
                ),
                ListTile(
                  leading: Icon(Icons.shield, color: Colors.purple),
                  title: Text("Role: Warrior"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Settings button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.settings),
              label: const Text("Settings"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// SETTINGS SCREEN
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.purpleAccent,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTile(String text, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.purpleAccent),
      title: Text(text, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.white70,
      ),
      onTap: () {}, // TODO: implement actions
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.purpleAccent,
      ),
      body: ListView(
        children: [
          _buildSectionTitle("Preferences"),
          _buildTile("Profile", Icons.person),
          _buildTile("Notifications", Icons.notifications),
          _buildTile("Courses", Icons.book),
          _buildTile("Social accounts", Icons.people),
          _buildTile("Privacy settings", Icons.lock),

          _buildSectionTitle("Support"),
          _buildTile("Help center", Icons.help),
          _buildTile("Feedback", Icons.feedback),

          const Divider(color: Colors.purpleAccent),

          // Sign out
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              child: const Text("Sign Out", style: TextStyle(fontSize: 16)),
            ),
          ),

          const Divider(color: Colors.purpleAccent),

          // Footer
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: const [
                Text(
                  "Terms of Service",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 6),
                Text(
                  "Privacy Policy",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
