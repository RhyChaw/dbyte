import 'package:flutter/material.dart';
import 'partner_dashboard_screen.dart';
import 'partner_skills_guide_screen.dart';
import 'partner_support_requests_screen.dart';
import 'partner_insights_screen.dart';
import 'partner_messaging_screen.dart';
import 'partner_learning_screen.dart';

class PartnerMainScaffold extends StatefulWidget {
  final int initialIndex;
  const PartnerMainScaffold({super.key, this.initialIndex = 0});

  @override
  State<PartnerMainScaffold> createState() => _PartnerMainScaffoldState();
}

class _PartnerMainScaffoldState extends State<PartnerMainScaffold> {
  late int _selectedIndex;

  final List<Widget> _screens = const [
    PartnerDashboardScreen(),
    PartnerSkillsGuideScreen(),
    PartnerSupportRequestsScreen(),
    PartnerInsightsScreen(),
    PartnerMessagingScreen(),
    PartnerLearningScreen(),
  ];

  final List<String> _titles = const [
    'Dashboard',
    'Skills Guide',
    'Support & Crisis',
    'Progress & Insights',
    'Messaging',
    'Learning Together',
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

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
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Guide'),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety),
            label: 'Support',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Learning'),
        ],
      ),
    );
  }
}
