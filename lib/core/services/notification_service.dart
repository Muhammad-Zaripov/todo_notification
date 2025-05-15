import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Notification kanallar va ID'lar uchun konstantalar
  static const String _defaultChannelId = 'default_channel';
  static const String _defaultChannelName = 'Default Channel';
  static const String _defaultChannelDescription =
      'Default notification channel';

  static const String _highImportanceChannelId = 'high_importance_channel';
  static const String _highImportanceChannelName = 'High Importance Channel';
  static const String _highImportanceChannelDescription =
      'High importance notification channel';

  // Notification turlari
  static const int basicNotificationId = 0;
  static const int scheduledNotificationId = 1;
  static const int periodicNotificationId = 2;
  static const int silentNotificationId = 3;
  static const int bigPictureNotificationId = 4;
  static const int mediaStyleNotificationId = 5;
  static const int bigTextNotificationId = 6;
  static const int inboxStyleNotificationId = 7;
  static const int groupedNotificationId = 8;
  static const int progressNotificationId = 9;

  // Singleton pattern
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();

  factory LocalNotificationService() {
    return _instance;
  }

  LocalNotificationService._internal();

  // Initialization method
  Future<void> init() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Android configuration
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS configuration
    final DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // Initialize plugin
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Request permissions (iOS only)
    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  // iOS uchun eski versiyalarda notification qabul qilish
  // void _onDidReceiveLocalNotification(
  //   int id,
  //   String? title,
  //   String? body,
  //   String? payload,
  // ) {
  //   debugPrint('Notification received: $id, $title, $body, $payload');
  // }

  // Notification bosilganda ishlatiladigan handler
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    debugPrint('Notification clicked: ${response.id}, ${response.payload}');
    // Bu yerda notification bosilganda qilinadigan ishlarni bajarish mumkin
    // Masalan, ma'lum bir ekranga o'tish
    notifyListeners(); // Provider orqali boshqa widgetlarni xabardor qilish
  }

  // Basic notification ko'rsatish
  Future<void> showBasicNotification({
    int id = basicNotificationId,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _defaultChannelId,
          _defaultChannelName,
          channelDescription: _defaultChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Ma'lum vaqtga notification rejalashtirish
  Future<void> zonedScheduleNotification({
    int id = scheduledNotificationId,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    bool repeatDaily = false,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _highImportanceChannelId,
          _highImportanceChannelName,
          channelDescription: _highImportanceChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final tz.TZDateTime scheduledDateTime = tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDateTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
      matchDateTimeComponents: repeatDaily ? DateTimeComponents.time : null,
    );
  }

  // Davriy ravishda notification ko'rsatish
  Future<void> periodicallyShowNotification({
    int id = periodicNotificationId,
    required String title,
    required String body,
    required RepeatInterval repeatInterval,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _defaultChannelId,
          _defaultChannelName,
          channelDescription: _defaultChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      repeatInterval,
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Big Text Style notification (Android)
  Future<void> showBigTextNotification({
    int id = bigTextNotificationId,
    required String title,
    required String body,
    required String bigText,
    String? payload,
  }) async {
    final BigTextStyleInformation bigTextStyleInformation =
        BigTextStyleInformation(
          bigText,
          contentTitle: title,
          htmlFormatBigText: true,
          htmlFormatContentTitle: true,
        );

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _defaultChannelId,
          _defaultChannelName,
          channelDescription: _defaultChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigTextStyleInformation,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Media Style notification (Android)
  Future<void> showMediaStyleNotification({
    int id = mediaStyleNotificationId,
    required String title,
    required String body,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _defaultChannelId,
          _defaultChannelName,
          channelDescription: _defaultChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          color: const Color(0xFF2196F3),
          enableLights: true,
          enableVibration: true,
          styleInformation: const MediaStyleInformation(),
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Progress notification (Android)
  Future<void> showProgressNotification({
    int id = progressNotificationId,
    required String title,
    required String body,
    required int progress,
    required int maxProgress,
    bool indeterminate = false,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _defaultChannelId,
          _defaultChannelName,
          channelDescription: _defaultChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          showProgress: true,
          maxProgress: maxProgress,
          progress: progress,
          indeterminate: indeterminate,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Barcha notificationlarni o'chirish
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // Ma'lum ID'li notificationni o'chirish
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // Pending notificationlarni olish
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotifications =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications;
  }
}
