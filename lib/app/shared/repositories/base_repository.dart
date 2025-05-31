import 'package:auto_care_plus_app/app/shared/database/local/database_local.dart';
import 'package:auto_care_plus_app/app/shared/models/base_model.dart';
import 'package:auto_care_plus_app/app/shared/models/base_model_interface.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pkg_flutter_utils/utils.dart';

abstract class BaseRepository<T extends IBaseModel> {
  static const dataHoraCriado = 'data_hora_criado';
  static const dataHoraDeletado = 'data_hora_deletado';
  static const dataHoraUltimaAlteracao = 'data_hora_ultima_alteracao';

  String get getTableName;

  String get getIdColumnName => "id_$getTableName";

  void create(Batch batch);

  BaseModel baseFromMap(Map<String, dynamic> e) {
    return BaseModel(
      id: e[getIdColumnName],
      dataHoraCriado: DateTimeUtils.parseIfNotNull(e[dataHoraCriado]),
      dataHoraDeletado: DateTimeUtils.parseIfNotNull(e[dataHoraDeletado]),
      dataHoraUltimaAlteracao: DateTimeUtils.parseIfNotNull(e[dataHoraUltimaAlteracao]),
    );
  }

  void validate(T entity);

  Future delete(T entity) async {
    final db = await DatabaseLocal().getDb();
    return await db.update(
      getTableName,
      {dataHoraDeletado: entity.base.dataHoraDeletado?.toIso8601String()},
      where: "$getIdColumnName = ?",
      whereArgs: [entity.base.id],
    );
  }

  Future deleteInTransaction(T entity, Transaction txn) async {
    return await txn.update(
      getTableName,
      {dataHoraDeletado: entity.base.dataHoraDeletado?.toIso8601String()},
      where: "$getIdColumnName = ?",
      whereArgs: [entity.base.id],
    );
  }
}
