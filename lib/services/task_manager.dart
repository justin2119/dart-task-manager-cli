import 'dart:convert';
import 'dart:io';
import '../models/task.dart';
import '../exceptions/task_exceptions.dart';
import 'repository.dart';

/// Implementation of a [Repository] for managing Tasks.
class TaskManager implements Repository<Task> {
  final String _storagePath;
  List<Task> _tasks = [];

  /// Creates a TaskManager with a specific file path.
  TaskManager(this._storagePath);

  @override
  void add(Task item) {
    _tasks.add(item);
  }

  @override
  void delete(String id) {
    if (!_tasks.any((t) => t.id == id)) {
      throw TaskNotFoundException(id);
    }
    _tasks.removeWhere((t) => t.id == id);
  }

  @override
  List<Task> getAll() {
    return List<Task>.from(_tasks);
  }

  /// Marks a task as finished.
  void completeTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) {
      throw TaskNotFoundException(id);
    }
    _tasks[index].isCompleted = true;
  }

  /// Sorts tasks by priority or date.
  void sortTasks({bool byPriority = true}) {
    if (byPriority) {
      _tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    } else {
      _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    }
  }

  @override
  Future<void> save() async {
    try {
      final file = File(_storagePath);
      final jsonString = jsonEncode(_tasks.map((t) => t.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      throw StorageException('Failed to save tasks: $e');
    }
  }

  @override
  Future<void> load() async {
    try {
      final file = File(_storagePath);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(jsonString) as List<dynamic>;
        _tasks = jsonData.map((item) {
          final map = item as Map<String, dynamic>;
          if (map['type'] == 'urgent') {
            return UrgentTask.fromUrgentJson(map);
          }
          return Task.fromJson(map);
        }).toList();
      }
    } catch (e) {
      throw StorageException('Failed to load tasks: $e');
    }
  }
}
