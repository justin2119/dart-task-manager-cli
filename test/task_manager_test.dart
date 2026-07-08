import 'package:test/test.dart';
import '../lib/models/task.dart';
import '../lib/services/task_manager.dart';

void main() {
  group('TaskManager Tests', () {
    late TaskManager manager;

    setUp(() {
      manager = TaskManager('test_tasks.json');
    });

    test('Add task should increase task count', () {
      manager.addTask(Task(
          id: '1',
          title: 'Test Task',
          priority: Priority.High,
          dueDate: DateTime.now()));
      expect(manager.allTasks.length, 1);
    });

    test('Marking task as completed', () {
      manager.addTask(Task(
          id: '1',
          title: 'Test Task',
          priority: Priority.Medium,
          dueDate: DateTime.now()));
      manager.completeTask('1');
      expect(manager.allTasks.first.isCompleted, true);
    });

    test('Deleting a task', () {
      manager.addTask(Task(
          id: '1',
          title: 'Test Task',
          priority: Priority.Low,
          dueDate: DateTime.now()));
      manager.deleteTask('1');
      expect(manager.allTasks.isEmpty, true);
    });

    test('Sorting tasks by priority', () {
      manager.addTask(Task(id: '1', title: 'Low', priority: Priority.Low, dueDate: DateTime.now()));
      manager.addTask(Task(id: '2', title: 'High', priority: Priority.High, dueDate: DateTime.now()));
      manager.sortTasks(byPriority: true);
      expect(manager.allTasks.first.priority, Priority.High);
    });

    test('TaskNotFoundException is thrown', () {
      expect(() => manager.completeTask('999'), throwsException);
    });
  });
}
