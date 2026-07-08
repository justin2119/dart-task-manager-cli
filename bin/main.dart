import '../lib/services/task_manager.dart';

Future<void> main(List<String> arguments) async {
  final manager = TaskManager('tasks.json');
  await manager.loadTasks();

  print('--- Dart Task Manager ---');
  // Simple CLI logic would go here
  print('Tasks loaded: ${manager.allTasks.length}');
}
