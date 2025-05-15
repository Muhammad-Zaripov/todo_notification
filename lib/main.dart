import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/services/notification_service.dart';
import 'package:todo_app/core/services/provider.dart';
import 'app/my_app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final notificationService = LocalNotificationService();
  await notificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LocalNotificationService>(
          create: (_) => notificationService,
        ),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const MainApp(),
    ),
  );
}
