import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../widgets/animated_button.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _sidebarCollapsed = false;
  late AnimationController _sidebarController;
  late AnimationController _contentController;
  late AnimationController _cardController;

  late Animation<double> _sidebarWidth;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;

  final List<String> _menuItems = [
    'See Feed',
    'Join a Group',
    'Make a Group',
    'Venting',
    'Chat with AI (Beta)',
  ];

  final List<Map<String, String>> _feedStories = List.generate(
    5,
    (index) => {
      'name': 'Person ${index + 1}',
      'story': 'This is a motivational story by person ${index + 1}.',
      'date': '2025-08-${10 + index}',
    },
  );

  final List<Map<String, dynamic>> _groups = List.generate(
    5,
    (index) => {
      'name': 'Group ${index + 1}',
      'members': Random().nextInt(6),
      'icon': Icons.group,
    },
  );

  final List<Map<String, String>> _ventingNotes = [];

  @override
  void initState() {
    super.initState();
    _sidebarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _sidebarWidth = Tween<double>(begin: 180, end: 60).animate(
      CurvedAnimation(parent: _sidebarController, curve: Curves.easeInOut),
    );

    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );

    _contentSlideAnimation =
        Tween<Offset>(begin: const Offset(0.3, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
        );

    // Start initial animations
    _contentController.forward();
    _cardController.forward();
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    _contentController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    HapticFeedback.lightImpact();
    setState(() {
      _sidebarCollapsed
          ? _sidebarController.reverse()
          : _sidebarController.forward();
      _sidebarCollapsed = !_sidebarCollapsed;
    });
  }

  void _selectMenuItem(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedIndex = index;
    });
    // Restart content animation
    _contentController.reset();
    _contentController.forward();
  }

  void _addVentingNote(String note) {
    setState(() {
      _ventingNotes.add({
        'note': note,
        'date': DateTime.now().toString().split(' ')[0],
      });
    });
  }

  void _showAddStoryDialog() {
    final TextEditingController storyController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Anonymous Story'),
        content: TextField(
          controller: storyController,
          maxLines: 5,
          decoration: const InputDecoration(hintText: 'Your story...'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (storyController.text.isNotEmpty) {
                setState(() {
                  _feedStories.add({
                    'name': 'Anonymous',
                    'story': storyController.text,
                    'date': DateTime.now().toString().split(' ')[0],
                  });
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showAddVentingDialog() {
    final TextEditingController ventController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Vent'),
        content: TextField(
          controller: ventController,
          maxLines: 5,
          decoration: const InputDecoration(hintText: 'Your vent...'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (ventController.text.isNotEmpty) {
                _addVentingNote(ventController.text);
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeed() {
    return Column(
      children: [
        // Header with add button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple.shade50, Colors.purple.shade100],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.feed, color: Colors.purple.shade600, size: 28),
              const SizedBox(width: 12),
              Text(
                'Community Feed',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                ),
              ),
              const Spacer(),
              AnimatedButton(
                text: "Add Story",
                icon: Icons.add,
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                borderRadius: BorderRadius.circular(20),
                onPressed: _showAddStoryDialog,
              ),
            ],
          ),
        ),
        Expanded(
          child: _feedStories.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.feed, size: 80, color: Colors.purple.shade200),
                      const SizedBox(height: 16),
                      Text(
                        "No stories yet",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.purple.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Be the first to share your story!",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.purple.shade300,
                        ),
                      ),
                    ],
                  ),
                )
              : AnimatedList(
                  initialItemCount: _feedStories.length,
                  itemBuilder: (context, index, animation) {
                    final story = _feedStories[index];
                    return SizeTransition(
                      sizeFactor: animation,
                      child: AnimatedCard(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.white,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          // Could add story details
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.purple.shade400,
                                        Colors.purple.shade600,
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        story['name']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        story['date']!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.more_vert,
                                  color: Colors.grey.shade400,
                                  size: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              story['story']!,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  color: Colors.grey.shade400,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.comment_outlined,
                                  color: Colors.grey.shade400,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.share_outlined,
                                  color: Colors.grey.shade400,
                                  size: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildJoinGroup() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple.shade50, Colors.purple.shade100],
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.group_add, color: Colors.purple.shade600, size: 28),
              const SizedBox(width: 12),
              Text(
                'Available Groups',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _groups.length,
            itemBuilder: (_, index) {
              final group = _groups[index];
              final canJoin = group['members'] < 5;
              return AnimatedCard(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.white,
                onTap: () {
                  HapticFeedback.lightImpact();
                  if (canJoin) {
                    // Join group logic
                  }
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
                            Colors.purple.shade400,
                            Colors.purple.shade600,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        group['icon'] as IconData,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Members: ${group['members']}/5',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    canJoin
                        ? AnimatedButton(
                            text: "Join",
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              // Join group logic
                            },
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Full',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMakeGroup() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController mantraController = TextEditingController();
    IconData selectedIcon = Icons.group;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Group Name'),
          ),
          TextField(
            controller: mantraController,
            decoration: const InputDecoration(labelText: 'Group Mantra'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Choose Icon:'),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(selectedIcon, color: Colors.purple.shade700),
                onPressed: () {
                  setState(() {
                    selectedIcon = selectedIcon == Icons.group
                        ? Icons.star
                        : Icons.group;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () {}, child: const Text('Create Group')),
        ],
      ),
    );
  }

  Widget _buildVenting() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _showAddVentingDialog,
            child: const Text('New Vent'),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _ventingNotes.length,
            itemBuilder: (_, index) {
              final note = _ventingNotes[index];
              return Card(
                margin: const EdgeInsets.all(8),
                color: Colors.purple.shade50,
                child: ListTile(
                  title: Text(note['note']!),
                  subtitle: Text(
                    note['date']!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatAI() {
    return const Center(child: Text('Chat with AI (Beta) - Coming soon!'));
  }

  Widget _getSelectedContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildFeed();
      case 1:
        return _buildJoinGroup();
      case 2:
        return _buildMakeGroup();
      case 3:
        return _buildVenting();
      case 4:
        return _buildChatAI();
      default:
        return const Center(child: Text('Not implemented'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Animated Sidebar
          AnimatedBuilder(
            animation: _sidebarController,
            builder: (context, child) {
              return Container(
                width: _sidebarWidth.value,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.purple.shade600, Colors.purple.shade800],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(5, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Toggle button
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: AnimatedButton(
                        text: "",
                        icon: _sidebarCollapsed
                            ? Icons.arrow_right
                            : Icons.arrow_left,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(8),
                        borderRadius: BorderRadius.circular(8),
                        onPressed: _toggleSidebar,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _menuItems.length,
                        itemBuilder: (_, index) {
                          final isSelected = _selectedIndex == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading: _sidebarCollapsed
                                  ? null
                                  : Icon(
                                      _getIconForIndex(index),
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.white70,
                                    ),
                              title: _sidebarCollapsed
                                  ? null
                                  : Text(
                                      _menuItems[index],
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.white70,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                              onTap: () => _selectMenuItem(index),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Animated Content
          Expanded(
            child: AnimatedBuilder(
              animation: _contentController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _contentFadeAnimation,
                  child: SlideTransition(
                    position: _contentSlideAnimation,
                    child: _getSelectedContent(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.feed;
      case 1:
        return Icons.group_add;
      case 2:
        return Icons.add_circle;
      case 3:
        return Icons.psychology;
      case 4:
        return Icons.chat;
      default:
        return Icons.help;
    }
  }
}
