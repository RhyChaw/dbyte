import 'package:flutter/material.dart';

class PartnerHistoryScreen extends StatelessWidget {
  const PartnerHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple[50],
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Partner History',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                'A history of sessions, check-ins, and notes to help you support effectively.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
