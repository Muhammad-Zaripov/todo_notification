import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/services/notification_service.dart';

class NotificationDemoScreen extends StatefulWidget {
  const NotificationDemoScreen({super.key});

  @override
  State<NotificationDemoScreen> createState() => _NotificationDemoScreenState();
}

class _NotificationDemoScreenState extends State<NotificationDemoScreen> {
  late LocalNotificationService _notificationService;
  List<PendingNotificationRequest> _pendingNotifications = [];

  @override
  void initState() {
    super.initState();
    _notificationService = Provider.of<LocalNotificationService>(
      context,
      listen: false,
    );
    _loadPendingNotifications();
  }

  Future<void> _loadPendingNotifications() async {
    final pendingNotifications =
        await _notificationService.getPendingNotifications();
    setState(() {
      _pendingNotifications = pendingNotifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Notifications Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPendingNotifications,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSection(
                title: 'Basic Notifications',
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _notificationService.showBasicNotification(
                        title: 'Basic Notification',
                        body: 'This is a basic notification',
                        payload: 'basic_notification',
                      );
                    },
                    child: const Text('Show Basic Notification'),
                  ),
                ],
              ),
              _buildSection(
                title: 'Scheduled Notifications',
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final DateTime scheduledDate = DateTime.now().add(
                        const Duration(seconds: 5),
                      );
                      _notificationService.zonedScheduleNotification(
                        title: 'Scheduled Notification',
                        body:
                            'This notification was scheduled for ${scheduledDate.toString()}',
                        scheduledDate: scheduledDate,
                        payload: 'scheduled_notification',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Notification scheduled for 5 seconds from now',
                          ),
                        ),
                      );
                    },
                    child: const Text('Schedule Notification (5 seconds)'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      final DateTime scheduledDate = DateTime.now().add(
                        const Duration(days: 1),
                      );
                      _notificationService.zonedScheduleNotification(
                        title: 'Daily Notification',
                        body:
                            'This notification will repeat daily at the same time',
                        scheduledDate: scheduledDate,
                        payload: 'daily_notification',
                        repeatDaily: true,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Daily notification scheduled for ${scheduledDate.hour}:${scheduledDate.minute}',
                          ),
                        ),
                      );
                    },
                    child: const Text('Schedule Daily Notification'),
                  ),
                ],
              ),
              _buildSection(
                title: 'Periodic Notifications',
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _notificationService.periodicallyShowNotification(
                        title: 'Periodic Notification',
                        body: 'This notification repeats every minute',
                        repeatInterval: RepeatInterval.everyMinute,
                        payload: 'periodic_notification',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Periodic notification scheduled (every minute)',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Show Periodic Notification (Every Minute)',
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      _notificationService.periodicallyShowNotification(
                        title: 'Hourly Notification',
                        body: 'This notification repeats every hour',
                        repeatInterval: RepeatInterval.hourly,
                        payload: 'hourly_notification',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Periodic notification scheduled (hourly)',
                          ),
                        ),
                      );
                    },
                    child: const Text('Show Periodic Notification (Hourly)'),
                  ),
                ],
              ),
              _buildSection(
                title: 'Special Notification Types',
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _notificationService.showBigTextNotification(
                        title: 'Big Text Notification',
                        body: 'Expanded in notification drawer',
                        bigText:
                            'This is a very long text that will be displayed when the notification is expanded. '
                            'It supports multiple lines and formatting. '
                            'You can include a lot of information here.',
                        payload: 'big_text_notification',
                      );
                    },
                    child: const Text('Show Big Text Notification'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      _showProgressNotificationDemo();
                    },
                    child: const Text('Show Progress Notification'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      _notificationService.showMediaStyleNotification(
                        title: 'Media Style Notification',
                        body:
                            'This notification uses media style (Android only)',
                        payload: 'media_notification',
                      );
                    },
                    child: const Text('Show Media Style Notification'),
                  ),
                ],
              ),
              _buildSection(
                title: 'Notification Management',
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _notificationService.cancelAllNotifications();
                      await _loadPendingNotifications();
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('All notifications cancelled'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Cancel All Notifications'),
                  ),
                ],
              ),
              if (_pendingNotifications.isNotEmpty)
                _buildSection(
                  title: 'Pending Notifications',
                  children: [
                    for (final notification in _pendingNotifications)
                      ListTile(
                        title: Text('ID: ${notification.id}'),
                        subtitle: Text(
                          '${notification.title} - ${notification.body}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await _notificationService.cancelNotification(
                              notification.id,
                            );
                            await _loadPendingNotifications();
                          },
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Future<void> _showProgressNotificationDemo() async {
    const int maxProgress = 100;
    for (int progress = 0; progress <= maxProgress; progress += 10) {
      await _notificationService.showProgressNotification(
        title: 'Download Progress',
        body: 'Downloading: $progress%',
        progress: progress,
        maxProgress: maxProgress,
        payload: 'progress_notification',
      );

      // Simulation of progress
      if (progress < maxProgress) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    ScaffoldMessenger.of(
      // ignore: use_build_context_synchronously
      context,
    ).showSnackBar(const SnackBar(content: Text('Download completed!')));
  }
}
