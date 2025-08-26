import 'package:flutter/material.dart';
import 'dart:math';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _sidebarCollapsed = false;
  late AnimationController _sidebarController;
  late Animation<double> _sidebarWidth;

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
    _sidebarWidth = Tween<double>(
      begin: 180,
      end: 60,
    ).animate(_sidebarController);
  }

  void _toggleSidebar() {
    setState(() {
      _sidebarCollapsed
          ? _sidebarController.reverse()
          : _sidebarController.forward();
      _sidebarCollapsed = !_sidebarCollapsed;
    });
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _showAddStoryDialog,
            child: const Text('Add Story'),
          ),
        ),
        Expanded(
          child: AnimatedList(
            initialItemCount: _feedStories.length,
            itemBuilder: (context, index, animation) {
              final story = _feedStories[index];
              return SizeTransition(
                sizeFactor: animation,
                child: Card(
                  margin: const EdgeInsets.all(8),
                  color: Colors.purple.shade50,
                  child: ListTile(
                    title: Text(
                      story['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(story['story']!),
                        const SizedBox(height: 4),
                        Text(
                          story['date']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
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
    return ListView.builder(
      itemCount: _groups.length,
      itemBuilder: (_, index) {
        final group = _groups[index];
        return Card(
          margin: const EdgeInsets.all(8),
          color: Colors.purple.shade50,
          child: ListTile(
            leading: Icon(group['icon'], color: Colors.purple.shade700),
            title: Text(
              group['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Members: ${group['members']}/5'),
            trailing: group['members'] < 5
                ? ElevatedButton(onPressed: () {}, child: const Text('Join'))
                : const Text('Full', style: TextStyle(color: Colors.grey)),
          ),
        );
      },
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
          AnimatedBuilder(
            animation: _sidebarController,
            builder: (context, child) {
              return Container(
                width: _sidebarWidth.value,
                color: Colors.purple.shade700,
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        _sidebarCollapsed
                            ? Icons.arrow_right
                            : Icons.arrow_left,
                        color: Colors.white,
                      ),
                      onPressed: _toggleSidebar,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _menuItems.length,
                        itemBuilder: (_, index) {
                          return ListTile(
                            leading: _sidebarCollapsed ? null : null,
                            title: _sidebarCollapsed
                                ? null
                                : Text(
                                    _menuItems[index],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                            selected: _selectedIndex == index,
                            selectedTileColor: Colors.purple.shade900,
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(child: _getSelectedContent()),
        ],
      ),
    );
  }
}
