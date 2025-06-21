import 'package:auto_care_plus_app/app/modules/usuario/models/usuario_model.dart';
import 'package:auto_care_plus_app/app/modules/usuario/repositories/usuario_repository_interface.dart';
import 'package:auto_care_plus_app/app/shared/repositories/base_repository.dart';
import 'package:auto_care_plus_app/app/shared/repositories/table_repository_local.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioRepository extends TableRepositoryLocal<UsuarioModel> implements IUsuarioRepository {
  @override
  String get getTableName => 'usuario';

  @override
  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE $getTableName (
        $getIdColumnName TEXT PRIMARY KEY,
        ${BaseRepository.dataHoraCriado} TEXT NOT NULL,
        ${BaseRepository.dataHoraDeletado} TEXT,
        ${BaseRepository.dataHoraUltimaAlteracao} TEXT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        telefone TEXT NOT NULL,
        senha TEXT NOT NULL
      );
    ''');

    batch.execute('''
      CREATE INDEX idx_usuario_email ON $getTableName(email);
    ''');
  }

  @override
  UsuarioModel fromMap(Map<String, dynamic> e) => UsuarioModel(
    base: baseFromMap(e),
    nome: e['nome'] ?? '',
    email: e['email'] ?? '',
    telefone: e['telefone'] ?? '',
    senha: e['senha'] ?? '',
  );

  @override
  Map<String, dynamic> toMap(UsuarioModel model) {
    return {
      getIdColumnName: model.base.id,
      BaseRepository.dataHoraCriado: model.base.dataHoraCriado?.toIso8601String() ?? DateTime.now().toIso8601String(),
      BaseRepository.dataHoraDeletado: model.base.dataHoraDeletado?.toIso8601String(),
      BaseRepository.dataHoraUltimaAlteracao: model.base.dataHoraUltimaAlteracao?.toIso8601String(),
      'nome': model.nome,
      'email': model.email,
      'telefone': model.telefone,
      'senha': model.senha,
    };
  }

  @override
  void validate(UsuarioModel entity) {
    if (entity.nome.isEmpty) {
      throw Exception('Nome é obrigatório');
    }
    if (entity.email.isEmpty) {
      throw Exception('E-mail é obrigatório');
    }
    if (entity.telefone.isEmpty) {
      throw Exception('Telefone é obrigatório');
    }
    if (entity.senha.isEmpty) {
      throw Exception('Senha é obrigatória');
    }
  }

  @override
  void dispose() {}
}
