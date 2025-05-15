class TaskModel {
  final String id;
  final String title;
  final int status;

  TaskModel({required this.id, required this.title, required this.status});

  factory TaskModel.fromMap(String id, Map<dynamic, dynamic> data) {
    return TaskModel(
      id: id,
      title: data['title'] ?? '',
      status: data['status'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'status': status};
  }
}
