import 'package:flutter/material.dart';

class PartnerSkillsGuideScreen extends StatelessWidget {
  const PartnerSkillsGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Interactive Guides',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _GuideTile(
          title: 'Support Mindfulness',
          subtitle: 'Simple steps to guide breathing and presence',
          icon: Icons.self_improvement,
        ),
        _GuideTile(
          title: 'Respond to Distressing Emotions',
          subtitle: 'Validate, reflect, and co-regulate using DBT',
          icon: Icons.favorite,
        ),
        _GuideTile(
          title: 'DBT Communication Dos and Don’ts',
          subtitle: 'How to phrase things effectively',
          icon: Icons.record_voice_over,
        ),
        const SizedBox(height: 16),
        const Text(
          'Visual Aids & Examples',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: const Text('😀 😐 😢 😡 😰'),
            title: const Text('Emoji Emotion Chart'),
            subtitle: const Text('Help label emotions visually'),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const ListTile(
            leading: Icon(Icons.chat_bubble_outline),
            title: Text('Example Encouragement Dialogues'),
            subtitle: Text('Ready-to-use supportive phrases'),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Role-play Scenarios',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const ListTile(
            leading: Icon(Icons.play_circle_outline),
            title: Text('Choose a response'),
            subtitle: Text('See DBT-aligned ideal responses after your choice'),
          ),
        ),
      ],
    );
  }
}

class _GuideTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const _GuideTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple.shade100,
          child: Icon(icon, color: Colors.purple),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
