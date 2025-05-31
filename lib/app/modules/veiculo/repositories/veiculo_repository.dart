import 'package:auto_care_plus_app/app/modules/veiculo/models/veiculo_model.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/repositories/veiculo_repository_interface.dart';
import 'package:auto_care_plus_app/app/shared/repositories/base_repository.dart';
import 'package:auto_care_plus_app/app/shared/repositories/table_repository_local.dart';
import 'package:sqflite/sqflite.dart';

class VeiculoRepository extends TableRepositoryLocal<VeiculoModel> implements IVeiculoRepository {
  @override
  String get getTableName => 'veiculo';

  @override
  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE $getTableName (
        $getIdColumnName TEXT PRIMARY KEY,
        ${BaseRepository.dataHoraCriado} TEXT NOT NULL,
        ${BaseRepository.dataHoraDeletado} TEXT,
        ${BaseRepository.dataHoraUltimaAlteracao} TEXT,
        modelo TEXT NOT NULL,
        marca TEXT NOT NULL,
        placa TEXT NOT NULL,
        ano TEXT NOT NULL,
        quilometragem TEXT NOT NULL,
        tipo_combustivel TEXT NOT NULL,
        observacoes TEXT
      );
    ''');
  }

  @override
  VeiculoModel fromMap(Map<String, dynamic> e) => VeiculoModel(
        base: baseFromMap(e),
        modelo: e['modelo'],
        marca: e['marca'],
        placa: e['placa'],
        ano: e['ano'],
        quilometragem: e['quilometragem'],
        tipoCombustivel: e['tipo_combustivel'],
        observacoes: e['observacoes'] ?? '',
      );

  @override
  Map<String, dynamic> toMap(VeiculoModel model) => {
        getIdColumnName: model.base.id,
        BaseRepository.dataHoraCriado: model.base.dataHoraCriado?.toIso8601String() ?? DateTime.now().toIso8601String(),
        BaseRepository.dataHoraDeletado: model.base.dataHoraDeletado?.toIso8601String(),
        BaseRepository.dataHoraUltimaAlteracao: model.base.dataHoraUltimaAlteracao?.toIso8601String(),
        'modelo': model.modelo,
        'marca': model.marca,
        'placa': model.placa,
        'ano': model.ano,
        'quilometragem': model.quilometragem,
        'tipo_combustivel': model.tipoCombustivel,
        'observacoes': model.observacoes,
      };

  @override
  void validate(VeiculoModel entity) {}

  @override
  void dispose() {}
}
