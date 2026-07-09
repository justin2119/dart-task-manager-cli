import 'entity.dart';

/// Supported priority levels for tasks.
enum Priority { 
  /// Low importance.
  low, 
  /// Normal importance.
  medium, 
  /// High importance.
  high, 
  /// Immediate attention required.
  urgent 
}

/// Represents a basic task entity.
class Task implements Entity {
  @override
  final String id;
  /// The title or description of the task.
  String title;
  /// The priority level.
  Priority priority;
  /// The due date.
  DateTime dueDate;
  /// Whether the task is finished.
  bool isCompleted;

  /// Creates a new [Task].
  Task({
    required this.id,
    required this.title,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
  });

  /// Converts task to JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'priority': priority.index,
        'dueDate': dueDate.toIso8601String(),
        'isCompleted': isCompleted,
        'type': 'normal',
      };

  /// Creates a task from JSON map.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      priority: Priority.values[json['priority'] as int],
      dueDate: DateTime.parse(json['dueDate'] as String),
      isCompleted: json['isCompleted'] as bool,
    );
  }
}

/// A specialized task that inherits from [Task] for urgent matters.
class UrgentTask extends Task {
  /// Note explaining the urgency.
  String urgencyNote;

  /// Creates an [UrgentTask].
  UrgentTask({
    required super.id,
    required super.title,
    required super.dueDate,
    required this.urgencyNote,
    super.isCompleted,
  }) : super(priority: Priority.urgent);

  @override
  Map<String, dynamic> toJson() => super.toJson()..addAll({
    'type': 'urgent',
    'urgencyNote': urgencyNote,
  });

  /// Factory specifically for UrgentTask json.
  factory UrgentTask.fromUrgentJson(Map<String, dynamic> json) {
    return UrgentTask(
      id: json['id'] as String,
      title: json['title'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      urgencyNote: json['urgencyNote'] as String,
      isCompleted: json['isCompleted'] as bool,
    );
  }
}
