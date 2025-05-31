import 'package:auto_care_plus_app/app/shared/models/base_model_interface.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sqflite/sqflite.dart';

abstract class IRepository<T extends IBaseModel> implements Disposable {
  Future<List<T>> getAll({bool deleted = false, Transaction? txn});

  Future<T?> getById(String id, {bool deleted = false});

  Future<T?> getFirst({Transaction? txn});

  Future<void> save(T entity);

  Future<void> update(T entity);

  Future delete(T entity);

  Future<void> saveInTransaction(T entity, Transaction txn);

  Future<void> updateInTransaction(T entity, Transaction txn);
}
