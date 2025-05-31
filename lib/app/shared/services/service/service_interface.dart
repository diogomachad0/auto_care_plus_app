abstract class IService<T> {
  Future<List<T>> getAll();

  Future<T?> getFirst();

  Future<T> saveOrUpdate(T entity, {String? uri});

  Future<void> delete(T? entity, {String? uri});

  Future<T?> getById(String id, {bool deleted = false});
}
