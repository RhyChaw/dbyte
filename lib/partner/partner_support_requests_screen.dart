import 'package:flutter/material.dart';
import '../widgets/animated_button.dart';

class PartnerSupportRequestsScreen extends StatelessWidget {
  const PartnerSupportRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Requests',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(Icons.sos, color: Colors.redAccent),
              title: const Text('I need help coping with a strong emotion'),
              subtitle: const Text('From: Your partner • 5m ago'),
              trailing: AnimatedButton(
                text: 'Respond',
                icon: Icons.reply,
                backgroundColor: Colors.purple,
                onPressed: () {},
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(Icons.timer, color: Colors.orange),
              title: const Text('Can you check in with me for 5 mins?'),
              subtitle: const Text('From: Your partner • 1h ago'),
              trailing: AnimatedButton(
                text: 'Check-in',
                icon: Icons.check,
                backgroundColor: Colors.indigo,
                onPressed: () {},
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Crisis & Emergency',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'If things escalate:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Stay with them if safe • Remove means • Call local emergency',
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Resources: Crisis lines, therapist contacts, safety plan',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Helpful templates',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const ListTile(
              leading: Icon(Icons.message_outlined),
              title: Text(
                "I'm here for you — want to breathe together for a minute?",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
