import 'dart:async';

import 'package:auto_care_plus_app/app/shared/database/local/database_local.dart';
import 'package:auto_care_plus_app/app/shared/models/base_model_interface.dart';
import 'package:auto_care_plus_app/app/shared/repositories/base_repository.dart';
import 'package:auto_care_plus_app/app/shared/repositories/repository_interface.dart';
import 'package:pkg_flutter_utils/extensions.dart';
import 'package:sqflite/sqflite.dart';

abstract class TableRepositoryLocal<T extends IBaseModel>
    extends BaseRepository<T>
    implements IRepository<T> {
  Map<String, dynamic> toMap(T entity);
  T fromMap(Map<String, dynamic> map);

  @override
  Future<int?> save(T entity) async {
    validate(entity);

    final values = toMap(entity);
    values.putIfAbsent(BaseRepository.dataHoraCriado, () => DateTime.now().toIso8601String());

    final db = await DatabaseLocal().getDb();
    return await db.insert(getTableName, values);
  }

  @override
  Future update(T entity) async {
    if (entity.base.isDeleted) return delete(entity);

    validate(entity);

    final values = toMap(entity);
    values.putIfAbsent(BaseRepository.dataHoraUltimaAlteracao, () => DateTime.now().toIso8601String());
    if (entity.base.dataHoraCriado != null) {
      values.putIfAbsent(BaseRepository.dataHoraCriado, () => entity.base.dataHoraCriado!.toIso8601String());
    }

    final db = await DatabaseLocal().getDb();
    final result = await db.update(
      getTableName,
      values,
      where: "$getIdColumnName = ?",
      whereArgs: [entity.base.id],
    );

    if (result == 0) throw Exception("Nenhum registro atualizado");
    return result;
  }

  @override
  Future delete(T entity) => super.delete(entity);

  @override
  Future<int> saveInTransaction(T entity, Transaction txn) async {
    validate(entity);

    final values = toMap(entity);
    values.putIfAbsent(BaseRepository.dataHoraCriado, () => DateTime.now().toIso8601String());

    return await txn.insert(getTableName, values);
  }

  @override
  Future<void> updateInTransaction(T entity, Transaction txn) async {
    if (entity.base.isDeleted) return deleteInTransaction(entity, txn);

    validate(entity);

    final values = toMap(entity);
    values.putIfAbsent(BaseRepository.dataHoraUltimaAlteracao, () => DateTime.now().toIso8601String());

    final result = await txn.update(
      getTableName,
      values,
      where: "$getIdColumnName = ?",
      whereArgs: [entity.base.id],
    );

    if (result == 0) throw Exception("Nenhum registro atualizado");
  }

  @override
  Future<T?> getById(String id, {bool deleted = false}) async {
    final list = await getFull(id: id, deleted: deleted);
    return list.firstOrNull;
  }

  @override
  Future<T?> getFirst({Transaction? txn}) async =>
      (await getAll(txn: txn)).firstOrNull;

  @override
  Future<List<T>> getAll({bool deleted = false, Transaction? txn}) async =>
      getFull(deleted: deleted, txn: txn);

  Future<List<T>> getFull({String? id, String where = '', List<dynamic>? whereArgs, String? orderBy, bool deleted = false, Transaction? txn}) async {
    var db = txn ?? await DatabaseLocal().getDb();

    List<String> whereListed = [];
    whereArgs ??= [];

    if (notIsNullOrWhiteSpace(where)) {
      whereListed.add(where);
    }

    if (!deleted) {
      whereListed.add('${BaseRepository.dataHoraDeletado} IS NULL');
    }

    if (id != null) {
      whereListed.add('$getIdColumnName = ?');
      whereArgs.add(id);
    }

    var results = await db.query(getTableName, where: whereListed.join(' AND '), whereArgs: whereArgs, orderBy: orderBy);

    var list = results.map((e) => fromMap(e)).toList();

    return list;
  }
}
