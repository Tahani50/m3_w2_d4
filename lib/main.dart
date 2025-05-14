import 'package:flutter/material.dart';
import 'noti_service.dart';
import 'reminder_input_page.dart';
import 'reminder_detail_page.dart';
import 'package:timezone/data/latest_all.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotiService().initNotification();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => const ReminderInputPage(),
        '/detail': (_) => const ReminderDetailPage(),
      },
    );
  }
}
