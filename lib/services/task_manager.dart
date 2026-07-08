import 'dart:convert';
import 'dart:io';
import '../models/task.dart';
import '../exceptions/task_exceptions.dart';

abstract class Repository<T> {
  Future<void> save(List<T> items);
  Future<List<T>> load();
}

class TaskManager {
  final String storagePath;
  List<Task> _tasks = [];

  TaskManager(this.storagePath);

  List<Task> get allTasks => List.unmodifiable(_tasks);

  void addTask(Task task) {
    _tasks.add(task);
  }

  void completeTask(String id) {
    final task = _tasks.firstWhere((t) => t.id == id, orElse: () => throw TaskNotFoundException(id));
    task.isCompleted = true;
  }

  void deleteTask(String id) {
    if (!_tasks.any((t) => t.id == id)) throw TaskNotFoundException(id);
    _tasks.removeWhere((t) => t.id == id);
  }

  void sortTasks({bool byPriority = true}) {
    if (byPriority) {
      _tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    } else {
      _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    }
  }

  Future<void> saveTasks() async {
    final file = File(storagePath);
    final jsonString = jsonEncode(_tasks.map((t) => t.toJson()).toList());
    await file.writeAsString(jsonString);
  }

  Future<void> loadTasks() async {
    final file = File(storagePath);
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      _tasks = jsonData.map((item) => Task.fromJson(item)).toList();
    }
  }
}
