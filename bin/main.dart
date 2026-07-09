import 'dart:io';
import 'package:args/args.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/services/task_manager.dart';
import 'package:dart_task_manager/exceptions/task_exceptions.dart';

void main(List<String> arguments) async {
  final manager = TaskManager('tasks.json');
  final parser = ArgParser()
    ..addCommand('add')
    ..addCommand('list')
    ..addCommand('complete')
    ..addCommand('delete');

  // Add sub-arguments
  parser.commands['add']!
    ..addOption('title', abbr: 't', help: 'Task title')
    ..addOption('priority', abbr: 'p', allowed: ['low', 'medium', 'high', 'urgent'], defaultsTo: 'medium')
    ..addOption('date', abbr: 'd', help: 'Due date (YYYY-MM-DD)')
    ..addOption('note', help: 'Urgency note (only for urgent tasks)');

  parser.commands['complete']!..addOption('id', help: 'Task ID to complete');
  parser.commands['delete']!..addOption('id', help: 'Task ID to delete');
  parser.commands['list']!..addFlag('sort', abbr: 's', help: 'Sort by priority', defaultsTo: false);

  try {
    await manager.load();
    final results = parser.parse(arguments);

    if (results.command == null) {
      print('Usage: dart bin/main.dart <command> [options]');
      print('Commands: add, list, complete, delete');
      return;
    }

    switch (results.command!.name) {
      case 'add':
        final cmd = results.command!;
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        final title = cmd['title'] as String? ?? 'New Task';
        final priorityStr = cmd['priority'] as String;
        final dateStr = cmd['date'] as String? ?? DateTime.now().toIso8601String().split('T')[0];
        final dueDate = DateTime.parse(dateStr);

        if (priorityStr == 'urgent') {
          manager.add(UrgentTask(
            id: id,
            title: title,
            dueDate: dueDate,
            urgencyNote: cmd['note'] as String? ?? 'No note provided',
          ));
        } else {
          manager.add(Task(
            id: id,
            title: title,
            priority: Priority.values.byName(priorityStr),
            dueDate: dueDate,
          ));
        }
        await manager.save();
        print('Task added successfully.');
        break;

      case 'list':
        final sort = results.command!['sort'] as bool;
        manager.sortTasks(byPriority: sort);
        final tasks = manager.getAll();
        if (tasks.isEmpty) {
          print('No tasks found.');
        } else {
          for (final t in tasks) {
            final status = t.isCompleted ? '[X]' : '[ ]';
            final type = t is UrgentTask ? '(URGENT)' : '';
            print('$status ID: ${t.id} | $type ${t.title} | Priority: ${t.priority.name} | Due: ${t.dueDate}');
            if (t is UrgentTask) print('   Note: ${t.urgencyNote}');
          }
        }
        break;

      case 'complete':
        final id = results.command!['id'] as String?;
        if (id == null) throw ArgumentError('ID is required');
        manager.completeTask(id);
        await manager.save();
        print('Task $id marked as completed.');
        break;

      case 'delete':
        final id = results.command!['id'] as String?;
        if (id == null) throw ArgumentError('ID is required');
        manager.delete(id);
        await manager.save();
        print('Task $id deleted.');
        break;
    }
  } on TaskNotFoundException catch (e) {
    print('Error: $e');
  } on StorageException catch (e) {
    print('Critical Error: $e');
    exit(1);
  } catch (e) {
    print('Unexpected error: $e');
  }
}
