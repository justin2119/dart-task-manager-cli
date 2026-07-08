class TaskNotFoundException implements Exception {
  final String id;
  TaskNotFoundException(this.id);
  @override
  String toString() => 'Task with ID $id not found.';
}

class StorageException implements Exception {
  final String message;
  StorageException(this.message);
  @override
  String toString() => 'Storage Error: $message';
}
