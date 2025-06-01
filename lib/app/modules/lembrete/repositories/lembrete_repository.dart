import 'package:auto_care_plus_app/app/modules/lembrete/models/lembrete_model.dart';
import 'package:auto_care_plus_app/app/modules/lembrete/repositories/lembrete_repository_interface.dart';
import 'package:auto_care_plus_app/app/shared/repositories/base_repository.dart';
import 'package:auto_care_plus_app/app/shared/repositories/table_repository_local.dart';
import 'package:sqflite/sqflite.dart';

class LembreteRepository extends TableRepositoryLocal<LembreteModel> implements ILembreteRepository {
  @override
  String get getTableName => 'lembrete';

  @override
  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE $getTableName (
        $getIdColumnName TEXT PRIMARY KEY,
        ${BaseRepository.dataHoraCriado} TEXT NOT NULL,
        ${BaseRepository.dataHoraDeletado} TEXT,
        ${BaseRepository.dataHoraUltimaAlteracao} TEXT,
        titulo TEXT NOT NULL,
        data TEXT NOT NULL,
        notificar INTEGER NOT NULL DEFAULT 0
      );
    ''');
  }

  @override
  LembreteModel fromMap(Map<String, dynamic> e) => LembreteModel(
        base: baseFromMap(e),
        titulo: e['titulo'],
        data: DateTime.parse(e['data']),
        notificar: (e['notificar'] ?? 0) == 1,
      );

  @override
  Map<String, dynamic> toMap(LembreteModel model) => {
        getIdColumnName: model.base.id,
        BaseRepository.dataHoraCriado: model.base.dataHoraCriado?.toIso8601String() ?? DateTime.now().toIso8601String(),
        BaseRepository.dataHoraDeletado: model.base.dataHoraDeletado?.toIso8601String(),
        BaseRepository.dataHoraUltimaAlteracao: model.base.dataHoraUltimaAlteracao?.toIso8601String(),
        'titulo': model.titulo,
        'data': model.data.toIso8601String(),
        'notificar': model.notificar ? 1 : 0,
      };

  @override
  void validate(LembreteModel entity) {}

  @override
  void dispose() {}
}
