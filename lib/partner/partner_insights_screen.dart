import 'package:flutter/material.dart';

class PartnerInsightsScreen extends StatelessWidget {
  const PartnerInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Progress & Insights',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _InsightCard(
          title: 'Mood over time',
          child: _ChartPlaceholder(label: 'Mood chart'),
        ),
        _InsightCard(
          title: 'Most practiced skills',
          child: _ChartPlaceholder(label: 'Skills bar chart'),
        ),
        _InsightCard(
          title: 'Encouragement',
          child: const Text(
            "Your partner struggled with 'Opposite Action' this week — try practicing it together.",
          ),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _InsightCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _ChartPlaceholder extends StatelessWidget {
  final String label;
  const _ChartPlaceholder({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: Center(
        child: Text(label, style: TextStyle(color: Colors.purple.shade400)),
      ),
    );
  }
}
