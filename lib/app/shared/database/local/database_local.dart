import 'dart:io';

import 'package:auto_care_plus_app/app/modules/atividade/repositories/atividade_repository.dart';
import 'package:auto_care_plus_app/app/modules/lembrete/repositories/lembrete_repository.dart';
import 'package:auto_care_plus_app/app/modules/usuario/repositories/usuario_repository.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/repositories/veiculo_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseLocal {
  final String _baseNameDb = 'auto_care';
  final int _versionDb = 1;
  final _lock = Lock();
  static Database? _db;
  static String? _currentUserId;

  // Banco temporário para quando não há usuário autenticado
  static const String _tempDbName = 'auto_care_temp.db';

  // Flag para indicar se estamos usando o banco temporário
  bool _isUsingTempDb = false;

  DatabaseLocal();

  Future<void> _onCreate(Database db, int version) async {
    var batch = db.batch();
    VeiculoRepository().create(batch);
    LembreteRepository().create(batch);
    AtividadeRepository().create(batch);
    UsuarioRepository().create(batch);

    //todo: implementar a criação das tabelas necessárias
    await batch.commit();
  }

  Future<void> _onOpen(Database db) async {
    print('DB version ${await db.getVersion()}');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<void> _onConfigureBeforeOpenDatabase(Database db) async {
    await db.execute("PRAGMA foreign_keys = OFF");
  }

  Future<void> _onConfigureAfterOpenDatabase(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  /// Obtém o UID do usuário atual autenticado
  String? _getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  /// Gera o nome do banco de dados baseado no UID do usuário
  /// Se não houver usuário autenticado, retorna o nome do banco temporário
  String _getDatabaseName() {
    final userId = _getCurrentUserId();
    if (userId == null) {
      _isUsingTempDb = true;
      return _tempDbName;
    }
    _isUsingTempDb = false;
    return '${_baseNameDb}_$userId.db';
  }

  Future<String> getPath() async {
    String databasesPath;
    if (Platform.isIOS) {
      databasesPath = (await getApplicationSupportDirectory()).path;
    } else {
      databasesPath = await getDatabasesPath();
    }

    final dbName = _getDatabaseName();
    final path = join(databasesPath, dbName);

    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (ex) {}

    return path;
  }

  /// Fecha o banco atual se o usuário mudou
  Future<void> _checkUserChange() async {
    final currentUserId = _getCurrentUserId();

    if (_currentUserId != currentUserId) {
      if (_db != null) {
        await _db!.close();
        _db = null;
      }
      _currentUserId = currentUserId;
    }
  }

  Future<Database> getDb() async {
    // Verifica se o usuário mudou
    await _checkUserChange();

    if (_db == null) {
      await _lock.synchronized(() async {
        if (_db == null) {
          _db = await openDatabase(
            await getPath(),
            version: _versionDb,
            onCreate: _onCreate,
            onUpgrade: _onUpgrade,
            onConfigure: _onConfigureBeforeOpenDatabase,
            onOpen: _onOpen,
          );
          await _onConfigureAfterOpenDatabase(_db!);
        }
      });
    }
    return _db!;
  }

  /// Verifica se o usuário está autenticado antes de realizar operações no banco
  /// Use este método antes de operações que exigem autenticação
  bool isUserAuthenticated() {
    return FirebaseAuth.instance.currentUser != null;
  }

  /// Método para verificar se estamos usando o banco temporário
  bool isUsingTemporaryDatabase() {
    return _isUsingTempDb;
  }

  /// Método para migrar dados do banco temporário para o banco do usuário após login
  Future<void> migrateFromTemporaryDatabase() async {
    if (!isUserAuthenticated() || !_isUsingTempDb) {
      return;
    }

    try {
      // Salva referência ao banco temporário
      final tempDb = _db;
      if (tempDb == null) return;

      // Fecha o banco temporário
      await tempDb.close();
      _db = null;

      // Obtém caminho do banco temporário
      String databasesPath;
      if (Platform.isIOS) {
        databasesPath = (await getApplicationSupportDirectory()).path;
      } else {
        databasesPath = await getDatabasesPath();
      }
      final tempPath = join(databasesPath, _tempDbName);

      if (!await File(tempPath).exists()) {
        return;
      }

      // Abre o banco do usuário
      _isUsingTempDb = false;
      final userDb = await getDb();

      // Aqui você implementaria a lógica para copiar os dados
      // do banco temporário para o banco do usuário
      // Exemplo simplificado:

      // 1. Veículos
      final veiculos = await tempDb.query('veiculos');
      for (var veiculo in veiculos) {
        await userDb.insert('veiculos', veiculo);
      }

      // 2. Lembretes
      final lembretes = await tempDb.query('lembretes');
      for (var lembrete in lembretes) {
        await userDb.insert('lembretes', lembrete);
      }

      // 3. Atividades
      final atividades = await tempDb.query('atividades');
      for (var atividade in atividades) {
        await userDb.insert('atividades', atividade);
      }

      await File(tempPath).delete();
    } catch (e) {}
  }

  /// Método para limpar o banco quando o usuário faz logout
  Future<void> closeDatabase() async {
    await _lock.synchronized(() async {
      if (_db != null) {
        await _db!.close();
        _db = null;
        _currentUserId = null;
      }
    });
  }

  /// Método para deletar o banco de dados do usuário atual (se necessário)
  Future<void> deleteCurrentUserDatabase() async {
    try {
      await closeDatabase();
      final path = await getPath();
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {}
  }

  /// Lista todos os bancos de dados existentes (para debug/admin)
  Future<List<String>> listUserDatabases() async {
    try {
      String databasesPath;
      if (Platform.isIOS) {
        databasesPath = (await getApplicationSupportDirectory()).path;
      } else {
        databasesPath = await getDatabasesPath();
      }

      final directory = Directory(databasesPath);
      final files = await directory.list().toList();

      return files.where((file) => file.path.contains(_baseNameDb) && file.path.endsWith('.db')).map((file) => basename(file.path)).toList();
    } catch (e) {
      return [];
    }
  }
}
