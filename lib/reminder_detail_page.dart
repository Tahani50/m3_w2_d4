import 'package:flutter/material.dart';

class ReminderDetailPage extends StatelessWidget {
  const ReminderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reminderTitle = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(title: const Text("Reminder Detail")),
      body: Center(
        child: Text(
          reminderTitle ?? 'No data',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
