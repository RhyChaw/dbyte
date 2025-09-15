import 'package:flutter/material.dart';
import 'package:dbyte/main.dart';
import '../partner/partner_main_scaffold.dart';
import '../widgets/animated_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int _step =
      0; // 0 = welcome, 1 = mascot intro, 2 = DBT description, 3 = role selection

  late AnimationController _welcomeController;
  late AnimationController _mascotController;
  late AnimationController _dbtController;
  late AnimationController _transitionController;
  late AnimationController _roleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _mascotBounceAnimation;
  late Animation<double> _mascotScaleAnimation;
  late Animation<double> _dbtFadeAnimation;
  late Animation<Offset> _dbtSlideAnimation;
  late Animation<double> _roleFadeAnimation;
  late Animation<Offset> _roleSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Welcome animations
    _welcomeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _mascotController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _dbtController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _roleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _welcomeController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _welcomeController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _welcomeController,
        curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
      ),
    );

    _mascotBounceAnimation = Tween<double>(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(parent: _mascotController, curve: Curves.elasticInOut),
    );

    _mascotScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _mascotController, curve: Curves.elasticOut),
    );

    _dbtFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _dbtController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _dbtSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _dbtController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ),
        );

    _roleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _roleController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _roleSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _roleController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ),
        );

    // Start welcome animation (manual navigation controls will advance steps)
    _welcomeController.forward();
  }

  void _goNext() {
    if (_step >= 3) return;
    setState(() {
      _step += 1;
    });
    if (_step == 1) _mascotController.forward();
    if (_step == 2) _dbtController.forward();
    if (_step == 3) _roleController.forward();
  }

  void _goBack() {
    if (_step <= 0) return;
    setState(() {
      _step -= 1;
    });
  }

  @override
  void dispose() {
    _welcomeController.dispose();
    _mascotController.dispose();
    _dbtController.dispose();
    _transitionController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _selectRole(String role) {
    // Add a small delay for visual feedback before navigation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                role == 'Partner'
                ? const PartnerMainScaffold()
                : MainScaffold(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9C27B0), Color(0xFFE1BEE7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(child: Center(child: _getStepContent())),
      ),
    );
  }

  Widget _getStepContent() {
    switch (_step) {
      case 0:
        return _buildWelcomeStep();
      case 1:
        return _buildMascotStep();
      case 2:
        return _buildDBTDescriptionStep();
      case 3:
        return _buildRoleSelectionStep();
      default:
        return _buildWelcomeStep();
    }
  }

  Widget _buildWelcomeStep() {
    return AnimatedBuilder(
      animation: _welcomeController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo/icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.eco, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Welcome to DewBloom!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Your guide to DBT and a better living!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),
                  AnimatedButton(
                    text: "Get Started",
                    icon: Icons.arrow_forward,
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    onPressed: _goNext,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMascotStep() {
    return AnimatedBuilder(
      animation: _mascotController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(0, -_mascotBounceAnimation.value),
                  child: Transform.scale(
                    scale: _mascotScaleAnimation.value,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'images/Happy.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Meet Happy! 🌟",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Your cheerful companion on this journey\nto emotional wellness and growth",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 32),
                _buildNavControls(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDBTDescriptionStep() {
    return AnimatedBuilder(
      animation: _dbtController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _dbtFadeAnimation,
          child: SlideTransition(
            position: _dbtSlideAnimation,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated DBT icon with gradient background
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.4),
                          blurRadius: 25,
                          spreadRadius: 8,
                        ),
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.psychology,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Title with enhanced styling
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: const Text(
                      "What is DBT?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 6,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Enhanced description card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.25),
                          Colors.white.withOpacity(0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Dialectical Behavior Therapy (DBT)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "A powerful cognitive-behavioral therapy that helps you:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Feature list with icons
                        _buildFeatureItem(
                          Icons.favorite,
                          "Manage difficult emotions",
                          "Learn to regulate and understand your feelings",
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureItem(
                          Icons.people,
                          "Improve relationships",
                          "Build healthier connections with others",
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureItem(
                          Icons.shield,
                          "Build distress tolerance",
                          "Handle crisis situations with confidence",
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureItem(
                          Icons.self_improvement,
                          "Practice mindfulness",
                          "Stay present and aware in daily life",
                        ),

                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            "DBT teaches you practical skills to create a life worth living! 🌟",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  _buildNavControls(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelectionStep() {
    return AnimatedBuilder(
      animation: _roleController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _roleFadeAnimation,
          child: SlideTransition(
            position: _roleSlideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    "What's your role?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildRoleCard(
                        icon: Icons.self_improvement,
                        title: "Warrior",
                        subtitle: "Learning for myself",
                        colors: [Colors.purple.shade50, Colors.white],
                        accent: [
                          const Color(0xFF7C4DFF),
                          const Color(0xFF9C27B0),
                        ],
                        onTap: () => _selectRole("Warrior"),
                      ),
                      const SizedBox(height: 16),
                      _buildRoleCard(
                        icon: Icons.handshake,
                        title: "Partner",
                        subtitle: "Supporting someone else",
                        colors: [Colors.purple.shade50, Colors.white],
                        accent: [
                          const Color(0xFF00BCD4),
                          const Color(0xFF2196F3),
                        ],
                        onTap: () => _selectRole("Partner"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Back only on final step
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedButton(
                      text: "Back",
                      icon: Icons.arrow_back,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      onPressed: _goBack,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> colors,
    required List<Color> accent,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.6), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: accent,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.first.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF4A148C),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.purple.shade400,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }

  // Removed progress dots in favor of Next/Back controls

  Widget _buildNavControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedButton(
          text: "Back",
          icon: Icons.arrow_back,
          backgroundColor: Colors.white,
          foregroundColor: Colors.purple,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          borderRadius: BorderRadius.circular(20),
          onPressed: _step == 0 ? null : _goBack,
        ),
        const SizedBox(width: 12),
        AnimatedButton(
          text: "Next",
          icon: Icons.arrow_forward,
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          borderRadius: BorderRadius.circular(20),
          onPressed: _step >= 3 ? null : _goNext,
        ),
      ],
    );
  }
}
