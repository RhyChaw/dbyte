import 'package:flutter/material.dart';

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

  Widget _buildTile(
    BuildContext context,
    String text,
    IconData icon,
    Widget targetScreen,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.purpleAccent),
      title: Text(text, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.white70,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => targetScreen),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.purpleAccent,
      ),
      body: ListView(
        children: [
          _buildSectionTitle("Preferences"),
          _buildTile(
            context,
            "Profile",
            Icons.person,
            const ProfileSettingsScreen(),
          ),
          _buildTile(
            context,
            "Notifications",
            Icons.notifications,
            const NotificationsSettingsScreen(),
          ),
          _buildTile(
            context,
            "Courses",
            Icons.book,
            const CoursesSettingsScreen(),
          ),
          _buildTile(
            context,
            "Social accounts",
            Icons.people,
            const SocialAccountsScreen(),
          ),
          _buildTile(
            context,
            "Privacy settings",
            Icons.lock,
            const PrivacySettingsScreen(),
          ),

          _buildSectionTitle("Support"),
          _buildTile(
            context,
            "Help center",
            Icons.help,
            const PlaceholderScreen(title: "Help Center"),
          ),
          _buildTile(
            context,
            "Feedback",
            Icons.feedback,
            const PlaceholderScreen(title: "Feedback"),
          ),

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

// placeHolderScreen
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.purpleAccent,
      ),
      body: Center(
        child: Text(
          "$title\nComing Soon!",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ProfileSettingsScreen
class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _gender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Settings"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.purpleAccent,
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                filled: true,
                fillColor: Colors.black12,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                filled: true,
                fillColor: Colors.black12,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _gender,
              dropdownColor: Colors.black87,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Gender",
                filled: true,
                fillColor: Colors.black12,
              ),
              items: [
                'Male',
                'Female',
                'Other',
              ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (value) => setState(() => _gender = value!),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // TODO: Save changes
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}

// NotificationsSettingsScreen
class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool announcements = true;
  bool treeReminders = true;
  bool generalReminders = true;
  bool motivational = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.purpleAccent,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text(
              "Announcements",
              style: TextStyle(color: Colors.white),
            ),
            value: announcements,
            onChanged: (val) => setState(() => announcements = val),
          ),
          SwitchListTile(
            title: const Text(
              "Tree Reminders",
              style: TextStyle(color: Colors.white),
            ),
            value: treeReminders,
            onChanged: (val) => setState(() => treeReminders = val),
          ),
          SwitchListTile(
            title: const Text(
              "General Reminders",
              style: TextStyle(color: Colors.white),
            ),
            value: generalReminders,
            onChanged: (val) => setState(() => generalReminders = val),
          ),
          SwitchListTile(
            title: const Text(
              "Motivational",
              style: TextStyle(color: Colors.white),
            ),
            value: motivational,
            onChanged: (val) => setState(() => motivational = val),
          ),
        ],
      ),
    );
  }
}

// CoursesSettingsScreen
class CoursesSettingsScreen extends StatelessWidget {
  const CoursesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int totalModules = 9;
    int completedModules = 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Courses"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.purpleAccent,
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(totalModules, (index) {
            bool done = index < completedModules;
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              height: 24,
              decoration: BoxDecoration(
                color: done ? Colors.purpleAccent : Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "Module ${index + 1}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// SocialAccountsScreen
class SocialAccountsScreen extends StatelessWidget {
  const SocialAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Social Accounts"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.purpleAccent,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(
              Icons.account_circle,
              color: Colors.purpleAccent,
            ),
            title: const Text(
              "Link Google",
              style: TextStyle(color: Colors.white),
            ),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text("Link"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.apple, color: Colors.purpleAccent),
            title: const Text(
              "Link Apple",
              style: TextStyle(color: Colors.white),
            ),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text("Link"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.purpleAccent),
            title: const Text(
              "Link Mobile",
              style: TextStyle(color: Colors.white),
            ),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text("Link"),
            ),
          ),
        ],
      ),
    );
  }
}

// PrivacySettingsScreen
class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Privacy"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.purpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Your data is safe with us.",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              "We do not share your personal information.",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              "You can control your preferences in the Notifications section.",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
