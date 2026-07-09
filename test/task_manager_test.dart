import 'package:test/test.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/services/task_manager.dart';
import 'package:dart_task_manager/exceptions/task_exceptions.dart';

void main() {
  group('TaskManager Comprehensive Tests', () {
    late TaskManager manager;
    const testPath = 'test_tasks_comprehensive.json';

    setUp(() {
      manager = TaskManager(testPath);
    });

    test('Add Task: Normal Task', () {
      final task = Task(id: '1', title: 'Normal', priority: Priority.medium, dueDate: DateTime.now());
      manager.add(task);
      expect(manager.getAll().length, 1);
      expect(manager.getAll().first.priority, Priority.medium);
    });

    test('Add Task: UrgentTask Inheritance', () {
      final urgent = UrgentTask(id: '2', title: 'Urgent', dueDate: DateTime.now(), urgencyNote: 'ASAP');
      manager.add(urgent);
      final tasks = manager.getAll();
      expect(tasks.last, isA<UrgentTask>());
      expect(tasks.last.priority, Priority.urgent);
    });

    test('Complete Task: Success and Exception', () {
      manager.add(Task(id: '3', title: 'T3', priority: Priority.low, dueDate: DateTime.now()));
      manager.completeTask('3');
      expect(manager.getAll().first.isCompleted, true);
      expect(() => manager.completeTask('invalid'), throwsA(isA<TaskNotFoundException>()));
    });

    test('Delete Task: Success and Exception', () {
      manager.add(Task(id: '4', title: 'T4', priority: Priority.low, dueDate: DateTime.now()));
      manager.delete('4');
      expect(manager.getAll(), isEmpty);
      expect(() => manager.delete('nonexistent'), throwsA(isA<TaskNotFoundException>()));
    });

    test('Sorting: Priority order including Urgent', () {
      manager.add(Task(id: 'low', title: 'L', priority: Priority.low, dueDate: DateTime.now()));
      manager.add(UrgentTask(id: 'urgent', title: 'U', dueDate: DateTime.now(), urgencyNote: 'N'));
      manager.add(Task(id: 'high', title: 'H', priority: Priority.high, dueDate: DateTime.now()));
      
      manager.sortTasks(byPriority: true);
      final sorted = manager.getAll();
      expect(sorted[0].priority, Priority.urgent);
      expect(sorted[1].priority, Priority.high);
      expect(sorted[2].priority, Priority.low);
    });

    test('Sorting: Date order', () {
      final now = DateTime.now();
      manager.add(Task(id: 'late', title: 'Late', priority: Priority.high, dueDate: now.add(Duration(days: 1))));
      manager.add(Task(id: 'early', title: 'Early', priority: Priority.low, dueDate: now.subtract(Duration(days: 1))));
      
      manager.sortTasks(byPriority: false);
      expect(manager.getAll().first.id, 'early');
    });
  });
}
