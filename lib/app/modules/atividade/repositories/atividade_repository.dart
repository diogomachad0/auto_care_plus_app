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
        tipo_atividade TEXT NOT NULL,
        data TEXT NOT NULL,
        km TEXT,
        total_pago TEXT,
        valor_pago TEXT,
        litros TEXT,
        preco_litro TEXT,
        tipo_combustivel TEXT,
        estabelecimento TEXT,
        numero_parcela TEXT,
        observacoes TEXT
      );
    ''');
  }

  @override
  AtividadeModel fromMap(Map<String, dynamic> e) => AtividadeModel(
        base: baseFromMap(e),
        tipoAtividade: e['tipo_atividade'],
        data: e['data'],
        km: e['km'] ?? '',
        totalPago: e['total_pago'] ?? '',
        valorPago: e['valor_pago'] ?? '',
        litros: e['litros'] ?? '',
        precoLitro: e['preco_litro'] ?? '',
        tipoCombustivel: e['tipo_combustivel'] ?? '',
        estabelecimento: e['estabelecimento'] ?? '',
        numeroParcela: e['numero_parcela'] ?? '',
        observacoes: e['observacoes'] ?? '',
      );

  @override
  Map<String, dynamic> toMap(AtividadeModel model) => {
        getIdColumnName: model.base.id,
        BaseRepository.dataHoraCriado: model.base.dataHoraCriado?.toIso8601String() ?? DateTime.now().toIso8601String(),
        BaseRepository.dataHoraDeletado: model.base.dataHoraDeletado?.toIso8601String(),
        BaseRepository.dataHoraUltimaAlteracao: model.base.dataHoraUltimaAlteracao?.toIso8601String(),
        'tipo_atividade': model.tipoAtividade,
        'data': model.data,
        'km': model.km,
        'total_pago': model.totalPago,
        'valor_pago': model.valorPago,
        'litros': model.litros,
        'preco_litro': model.precoLitro,
        'tipo_combustivel': model.tipoCombustivel,
        'estabelecimento': model.estabelecimento,
        'numero_parcela': model.numeroParcela,
        'observacoes': model.observacoes,
      };

  @override
  void validate(AtividadeModel entity) {}

  @override
  void dispose() {}
}
