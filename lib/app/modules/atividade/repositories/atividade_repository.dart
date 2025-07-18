import 'package:auto_care_plus_app/app/modules/atividade/models/atividade_model.dart';
import 'package:auto_care_plus_app/app/modules/atividade/repositories/atividade_repository_interface.dart';
import 'package:auto_care_plus_app/app/shared/repositories/base_repository.dart';
import 'package:auto_care_plus_app/app/shared/repositories/table_repository_local.dart';
import 'package:sqflite/sqflite.dart';

class AtividadeRepository extends TableRepositoryLocal<AtividadeModel> implements IAtividadeRepository {
  @override
  String get getTableName => 'atividade';

  @override
  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE $getTableName (
        $getIdColumnName TEXT PRIMARY KEY,
        ${BaseRepository.dataHoraCriado} TEXT NOT NULL,
        ${BaseRepository.dataHoraDeletado} TEXT,
        ${BaseRepository.dataHoraUltimaAlteracao} TEXT,
        veiculo_id TEXT NOT NULL,
        tipo_atividade TEXT NOT NULL,
        data TEXT NOT NULL,
        km TEXT,
        total_pago TEXT,
        litros TEXT,
        preco_litro TEXT,
        tipo_combustivel TEXT,
        estabelecimento TEXT,
        numero_parcela TEXT,
        observacoes TEXT,
        latitude TEXT,
        longitude TEXT
      );
    ''');

    batch.execute('''
      CREATE INDEX idx_atividade_veiculo_id ON $getTableName(veiculo_id);
    ''');
  }

  @override
  AtividadeModel fromMap(Map<String, dynamic> e) => AtividadeModel(
        base: baseFromMap(e),
        veiculoId: e['veiculo_id'] ?? '',
        tipoAtividade: e['tipo_atividade'] ?? '',
        data: e['data'] ?? '',
        km: e['km'] ?? '',
        totalPago: e['total_pago'] ?? '',
        litros: e['litros'] ?? '',
        precoLitro: e['preco_litro'] ?? '',
        tipoCombustivel: e['tipo_combustivel'] ?? '',
        estabelecimento: e['estabelecimento'] ?? '',
        numeroParcela: e['numero_parcela'] ?? '',
        observacoes: e['observacoes'] ?? '',
        latitude: e['latitude'] != null && e['latitude'].toString().isNotEmpty ? double.tryParse(e['latitude'].toString()) : null,
        longitude: e['longitude'] != null && e['longitude'].toString().isNotEmpty ? double.tryParse(e['longitude'].toString()) : null,
      );

  @override
  Map<String, dynamic> toMap(AtividadeModel model) {
    return {
      getIdColumnName: model.base.id,
      BaseRepository.dataHoraCriado: model.base.dataHoraCriado?.toIso8601String() ?? DateTime.now().toIso8601String(),
      BaseRepository.dataHoraDeletado: model.base.dataHoraDeletado?.toIso8601String(),
      BaseRepository.dataHoraUltimaAlteracao: model.base.dataHoraUltimaAlteracao?.toIso8601String(),
      'veiculo_id': model.veiculoId,
      'tipo_atividade': model.tipoAtividade,
      'data': model.data,
      'km': model.km,
      'total_pago': model.totalPago,
      'litros': model.litros,
      'preco_litro': model.precoLitro,
      'tipo_combustivel': model.tipoCombustivel,
      'estabelecimento': model.estabelecimento,
      'numero_parcela': model.numeroParcela,
      'observacoes': model.observacoes,
      'latitude': model.latitude?.toString(),
      'longitude': model.longitude?.toString(),
    };
  }

  @override
  void validate(AtividadeModel entity) {
    if (entity.veiculoId.isEmpty) {
      throw Exception('Veículo é obrigatório');
    }
  }

  @override
  void dispose() {}
}
