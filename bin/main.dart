import 'dart:io';
import '../lib/models/task.dart';
import '../lib/services/task_manager.dart';
import '../lib/exceptions/task_exceptions.dart';

void main(List<String> arguments) async {
  final manager = TaskManager('tasks.json');
  await manager.loadTasks();

  print('--- Dart Task Manager ---');
  // Simple CLI logic would go here
  print('Tasks loaded: ${manager.allTasks.length}');
}
