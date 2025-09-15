import 'package:flutter/material.dart';
import '../widgets/animated_button.dart';

class PartnerDashboardScreen extends StatelessWidget {
  const PartnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today at a glance',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _OverviewCards(),
          const SizedBox(height: 20),
          const Text(
            'Motivation',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: const [
                  Icon(Icons.celebration, color: Colors.purple),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your partner completed 3 skills today! 🎉',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Quick actions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AnimatedButton(
                  text: 'Encourage',
                  icon: Icons.thumb_up,
                  backgroundColor: Colors.purple,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedButton(
                  text: 'Check-in',
                  icon: Icons.favorite,
                  backgroundColor: Colors.indigo,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedButton(
                  text: 'Suggest',
                  icon: Icons.lightbulb,
                  backgroundColor: Colors.teal,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _OverviewCard(
          title: 'Current skills',
          subtitle: 'Mindfulness, Emotion Regulation',
        ),
        _OverviewCard(title: 'Streak', subtitle: '5 days in a row'),
        _OverviewCard(title: 'Recent exercises', subtitle: '3 completed today'),
        _OverviewCard(title: 'Requests', subtitle: '1 help request'),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const _OverviewCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}
