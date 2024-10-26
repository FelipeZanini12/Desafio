class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime dueDate;
  String userId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.dueDate,
    required this.userId,
  });


  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      dueDate: DateTime.parse(map['dueDate'] ?? DateTime.now().toIso8601String()),
      userId: map['userId'] ?? '',
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate.toIso8601String(),
      'userId': userId,
    };
  }
}
