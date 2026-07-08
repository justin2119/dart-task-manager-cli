/// Interface for generic persistence operations.
abstract class Repository<T> {
  /// Adds an item to the repository.
  void add(T item);
  /// Removes an item by ID.
  void delete(String id);
  /// Returns all items.
  List<T> getAll();
  /// Saves current state to persistence.
  Future<void> save();
  /// Loads state from persistence.
  Future<void> load();
}
