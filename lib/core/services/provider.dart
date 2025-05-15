import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../features/todo/data/models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  Stream<List<TaskModel>> get tasks => _firebaseService.getTasks();

  Future<void> addTask(String title) => _firebaseService.addTask(title);

  Future<void> updateStatus(TaskModel task) =>
      _firebaseService.updateTaskStatus(task);
}

class FirebaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('tasks');

  Stream<List<TaskModel>> getTasks() {
    return _db.onValue.map((event) {
      final data = event.snapshot.value as Map?;
      if (data == null) return [];

      return data.entries
          .map(
            (e) => TaskModel.fromMap(e.key, Map<String, dynamic>.from(e.value)),
          )
          .toList();
    });
  }

  Future<void> addTask(String title) async {
    final newRef = _db.push();
    await newRef.set({'title': title, 'status': 0});
  }

  Future<void> updateTaskStatus(TaskModel task) async {
    final newStatus = task.status + 1;
    if (newStatus > 3) {
      await _db.child(task.id).remove();
    } else {
      await _db.child(task.id).update({'status': newStatus});
    }
  }
}
