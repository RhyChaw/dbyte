// lib/app_router.dart
import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/tracker_screen.dart';
import 'screens/tree_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/community_screen.dart';
import 'partner/partner_main_scaffold.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/partner':
        return MaterialPageRoute(builder: (_) => const PartnerMainScaffold());
      case '/track':
        return MaterialPageRoute(builder: (_) => const TrackerScreen());
      case '/tree':
        return MaterialPageRoute(builder: (_) => const TreeScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/community':
        return MaterialPageRoute(builder: (_) => const CommunityScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
