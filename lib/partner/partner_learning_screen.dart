import 'package:flutter/material.dart';

class PartnerLearningScreen extends StatelessWidget {
  const PartnerLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Learning Together',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const ListTile(
            leading: Icon(Icons.psychology),
            title: Text('Mini-lesson: Wise Mind'),
            subtitle: Text(
              'Understand Emotion Mind, Reasonable Mind, and Wise Mind',
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const ListTile(
            leading: Icon(Icons.quiz),
            title: Text('Quiz: DBT Basics'),
            subtitle: Text(
              '5 questions • Earn points for your support streaks',
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const ListTile(
            leading: Icon(Icons.spa),
            title: Text('Shared mindfulness session'),
            subtitle: Text('A 3-minute guided breathing to do together'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ),
      ],
    );
  }
}
