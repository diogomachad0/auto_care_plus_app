import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseLocal {
  final String _nameDb = 'auto_care.db';
  final int _versionDb = 1;
  final _lock = Lock();
  static Database? _db;

  DatabaseLocal();

  Future<void> _onCreate(Database db, int version) async {
    var batch = db.batch();

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

  Future<String> getPath() async {
    String databasesPath;
    if (Platform.isIOS) {
      databasesPath = (await getApplicationSupportDirectory()).path;
    } else {
      databasesPath = await getDatabasesPath();
    }

    final path = join(databasesPath, _nameDb);

    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (ex) {
      print('Erro ao criar diretório $ex');
    }

    return path;
  }

  Future<Database> getDb() async {
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
}
