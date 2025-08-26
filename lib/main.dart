import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/tracker_screen.dart';
import 'screens/tree_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/community_screen.dart';

void main() {
  runApp(DbyTeApp());
}

class DbyTeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DbyTe',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
        '/home': (context) => MainScaffold(),
        '/lesson': (context) => TrackerScreen(),
        '/tree': (context) => TreeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/community': (context) => CommunityScreen(),
      },
    );
  }
}

/// Wrapper with bottom nav bar
class MainScaffold extends StatefulWidget {
  final int initialIndex;
  const MainScaffold({super.key, this.initialIndex = 0});

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    HomeScreen(),
    TrackerScreen(),
    TreeScreen(),
    CommunityScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = [
    "Home",
    "Track",
    "Tree",
    "Community",
    "Profile",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.energy_savings_leaf),
            label: 'My Tree',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.escalator_warning),
            label: 'Community',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
