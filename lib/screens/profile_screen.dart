import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'settings_screen.dart';
import '../widgets/animated_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _cardController;
  late AnimationController _buttonController;

  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _headerController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ),
        );

    _cardScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );

    _buttonScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );

    // Start animations with staggered delays
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _cardController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple.shade400, Colors.purple.shade600],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animated top box with image
            AnimatedBuilder(
              animation: _headerController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _headerFadeAnimation,
                  child: SlideTransition(
                    position: _headerSlideAnimation,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.purple.shade400,
                            Colors.purple.shade600,
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // Animated name
            AnimatedBuilder(
              animation: _headerController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _headerFadeAnimation,
                  child: const Text(
                    "Rhythm Chawla",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // Animated 2x2 Flex cards for details
            AnimatedBuilder(
              animation: _cardController,
              builder: (context, child) {
                return ScaleTransition(
                  scale: _cardScaleAnimation,
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildAnimatedInfoCard(
                        Icons.email,
                        'Email',
                        'rhythm@email.com',
                        0,
                      ),
                      _buildAnimatedInfoCard(
                        Icons.phone,
                        'Phone',
                        '+1 437-667-5557',
                        1,
                      ),
                      _buildAnimatedInfoCard(Icons.person, 'Gender', 'Male', 2),
                      _buildAnimatedInfoCard(
                        Icons.shield,
                        'Role',
                        'Warrior',
                        3,
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // Animated Tree Size Section
            AnimatedBuilder(
              animation: _cardController,
              builder: (context, child) {
                return ScaleTransition(
                  scale: _cardScaleAnimation,
                  child: AnimatedCard(
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.purple.shade100,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      // Could add tree details navigation
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.green.shade400,
                                Colors.green.shade600,
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.park,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Tree Size',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Your progress in tree growth',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Animated Leaderboard Section
            AnimatedBuilder(
              animation: _cardController,
              builder: (context, child) {
                return ScaleTransition(
                  scale: _cardScaleAnimation,
                  child: AnimatedCard(
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.purple.shade100,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      // Could add leaderboard navigation
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.orange.shade400,
                                Colors.orange.shade600,
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.leaderboard,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Leaderboard',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'See your rank among others',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // Animated Settings button
            AnimatedBuilder(
              animation: _buttonController,
              builder: (context, child) {
                return ScaleTransition(
                  scale: _buttonScaleAnimation,
                  child: AnimatedButton(
                    text: "Settings",
                    icon: Icons.settings,
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const SettingsScreen(),
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
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedInfoCard(
    IconData icon,
    String title,
    String value,
    int index,
  ) {
    return AnimatedCard(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      onTap: () {
        HapticFeedback.lightImpact();
        // Could add edit functionality
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getColorForIndex(index).shade400,
                  _getColorForIndex(index).shade600,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getColorForIndex(index).withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purple,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  MaterialColor _getColorForIndex(int index) {
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.purple;
    }
  }
}
