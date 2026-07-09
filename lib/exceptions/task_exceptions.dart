/// Exception thrown when a task is not found.
class TaskNotFoundException implements Exception {
  /// The ID of the task that was not found.
  final String id;
  /// Creates a [TaskNotFoundException].
  TaskNotFoundException(this.id);
  @override
  String toString() => 'Task with ID $id not found.';
}

/// Exception thrown for storage-related errors.
class StorageException implements Exception {
  /// The error message.
  final String message;
  /// Creates a [StorageException].
  StorageException(this.message);
  @override
  String toString() => 'Storage Error: $message';
}
