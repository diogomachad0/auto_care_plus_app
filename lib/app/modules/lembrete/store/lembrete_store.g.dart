// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lembrete_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LembreteStore on _LembreteStoreBase, Store {
  late final _$baseAtom =
      Atom(name: '_LembreteStoreBase.base', context: context);

  @override
  BaseStore get base {
    _$baseAtom.reportRead();
    return super.base;
  }

  @override
  set base(BaseStore value) {
    _$baseAtom.reportWrite(value, super.base, () {
      super.base = value;
    });
  }

  late final _$idAtom = Atom(name: '_LembreteStoreBase.id', context: context);

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

  late final _$tituloAtom =
      Atom(name: '_LembreteStoreBase.titulo', context: context);

  @override
  String get titulo {
    _$tituloAtom.reportRead();
    return super.titulo;
  }

  @override
  set titulo(String value) {
    _$tituloAtom.reportWrite(value, super.titulo, () {
      super.titulo = value;
    });
  }

  late final _$dataAtom =
      Atom(name: '_LembreteStoreBase.data', context: context);

  @override
  DateTime get data {
    _$dataAtom.reportRead();
    return super.data;
  }

  @override
  set data(DateTime value) {
    _$dataAtom.reportWrite(value, super.data, () {
      super.data = value;
    });
  }

  late final _$notificarAtom =
      Atom(name: '_LembreteStoreBase.notificar', context: context);

  @override
  bool get notificar {
    _$notificarAtom.reportRead();
    return super.notificar;
  }

  @override
  set notificar(bool value) {
    _$notificarAtom.reportWrite(value, super.notificar, () {
      super.notificar = value;
    });
  }

  @override
  String toString() {
    return '''
base: ${base},
id: ${id},
titulo: ${titulo},
data: ${data},
notificar: ${notificar}
    ''';
  }
}
