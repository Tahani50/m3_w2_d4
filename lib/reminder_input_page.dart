import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'noti_service.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderInputPage extends StatefulWidget {
  const ReminderInputPage({super.key});

  @override
  State<ReminderInputPage> createState() => _ReminderInputPageState();
}

class _ReminderInputPageState extends State<ReminderInputPage> {
  final titleController = TextEditingController();
  TimeOfDay? selectedTime;

  void scheduleReminder() async {
    if (titleController.text.isEmpty || selectedTime == null) return;

    final now = DateTime.now();
    final scheduledDate = DateTime(now.year, now.month, now.day,
        selectedTime!.hour, selectedTime!.minute);

    await NotiService().notificationsPlugin.zonedSchedule(
      0,
      titleController.text,
      "Scheduled Reminder",
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotiService().notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: titleController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminder Scheduled!')),
    );
  }

  @override
  void initState() {
    super.initState();

    // Listen for taps on notification
    NotiService().notificationsPlugin.initialize(
      NotiService().initSettings,
      onDidReceiveNotificationResponse: (details) {
        Navigator.pushNamed(context, '/detail',
            arguments: details.payload ?? 'No Title');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Reminder",), backgroundColor: Colors.deepPurple,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey,
                focusColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(30),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(30),
                ),
                hintText: 'Add a Title',
                hintStyle: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final time = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (time != null) {
                  setState(() {
                    selectedTime = time;
                  });
                }
              },
              child: Text(selectedTime == null
                  ? "Pick Time"
                  : "Time: ${selectedTime!.format(context)}"),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.black,
              ),
              onPressed: scheduleReminder,
              child: const Text("Schedule"),
            ),
            const SizedBox(height: 400),
          ],
        ),
      ),
    );
  }
}
