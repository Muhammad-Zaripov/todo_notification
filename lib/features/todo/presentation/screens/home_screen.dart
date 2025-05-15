import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/core/utils/app_images.dart';

import '../widgets/show_alert_dialog_widget.dart';
import 'notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> tasks = [
    {'title': 'Buy milk', 'status': 0},
    {'title': 'Go to gym', 'status': 1},
    {'title': 'Flutter project', 'status': 2},
    {'title': 'Flutter project', 'status': 3},
  ];

  void _handleTap(int index) {
    setState(() {
      int status = tasks[index]['status'];
      if (status >= 3) {
        tasks.removeAt(index);
      } else {
        tasks[index]['status'] = status + 1;
      }
    });
  }

  Color _getColorByStatus(int status) {
    switch (status) {
      case 2:
        return Colors.yellow.shade100;
      case 3:
        return Colors.green.shade100;
      default:
        return Colors.white;
    }
  }

  Widget _getIconByStatus(int status) {
    switch (status) {
      case 1:
        return SvgPicture.asset(AppImages.tap1);
      case 2:
        return SvgPicture.asset(AppImages.tap2);
      case 3:
        return SvgPicture.asset(AppImages.tap3);
      default:
        return SvgPicture.asset(AppImages.x);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do"),
        backgroundColor: Color(0xFF8687E7),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationDemoScreen(),
                ),
              );
            },
            icon: Icon(Icons.notification_add_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final title = tasks[index]['title'];
            final status = tasks[index]['status'];

            return GestureDetector(
              onTap: () => _handleTap(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getColorByStatus(status),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    _getIconByStatus(status),
                    const SizedBox(width: 12),
                    Text(title, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => ShowAlertDialogWidget(),
          );
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF8687E7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Add Todo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
