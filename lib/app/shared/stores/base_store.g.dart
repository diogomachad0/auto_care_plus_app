// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BaseStore on _BaseStoreBase, Store {
  late final _$idAtom = Atom(name: '_BaseStoreBase.id', context: context);

  @override
  String get id {
    _$idAtom.reportRead();
    return super.id;
  }

  @override
  set id(String value) {
    _$idAtom.reportWrite(value, super.id, () {
      super.id = value;
    });
  }

  late final _$dataHoraCriadoAtom =
      Atom(name: '_BaseStoreBase.dataHoraCriado', context: context);

  @override
  DateTime? get dataHoraCriado {
    _$dataHoraCriadoAtom.reportRead();
    return super.dataHoraCriado;
  }

  @override
  set dataHoraCriado(DateTime? value) {
    _$dataHoraCriadoAtom.reportWrite(value, super.dataHoraCriado, () {
      super.dataHoraCriado = value;
    });
  }

  late final _$dataHoraUltimaAlteracaoAtom =
      Atom(name: '_BaseStoreBase.dataHoraUltimaAlteracao', context: context);

  @override
  DateTime? get dataHoraUltimaAlteracao {
    _$dataHoraUltimaAlteracaoAtom.reportRead();
    return super.dataHoraUltimaAlteracao;
  }

  @override
  set dataHoraUltimaAlteracao(DateTime? value) {
    _$dataHoraUltimaAlteracaoAtom
        .reportWrite(value, super.dataHoraUltimaAlteracao, () {
      super.dataHoraUltimaAlteracao = value;
    });
  }

  late final _$dataHoraDeletadoAtom =
      Atom(name: '_BaseStoreBase.dataHoraDeletado', context: context);

  @override
  DateTime? get dataHoraDeletado {
    _$dataHoraDeletadoAtom.reportRead();
    return super.dataHoraDeletado;
  }

  @override
  set dataHoraDeletado(DateTime? value) {
    _$dataHoraDeletadoAtom.reportWrite(value, super.dataHoraDeletado, () {
      super.dataHoraDeletado = value;
    });
  }

  @override
  String toString() {
    return '''
id: ${id},
dataHoraCriado: ${dataHoraCriado},
dataHoraUltimaAlteracao: ${dataHoraUltimaAlteracao},
dataHoraDeletado: ${dataHoraDeletado}
    ''';
  }
}
