enum Priority { Low, Medium, High }

abstract class Entity {
  String get id;
}

class Task implements Entity {
  @override
  final String id;
  String title;
  Priority priority;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'priority': priority.index,
        'dueDate': dueDate.toIso8601String(),
        'isCompleted': isCompleted,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        priority: Priority.values[json['priority']],
        dueDate: DateTime.parse(json['dueDate']),
        isCompleted: json['isCompleted'],
      );
}
