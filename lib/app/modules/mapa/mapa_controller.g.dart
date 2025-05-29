// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mapa_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MapaController on _MapaController, Store {
  late final _$latAtom = Atom(name: '_MapaController.lat', context: context);

  @override
  double get lat {
    _$latAtom.reportRead();
    return super.lat;
  }

  @override
  set lat(double value) {
    _$latAtom.reportWrite(value, super.lat, () {
      super.lat = value;
    });
  }

  late final _$longAtom = Atom(name: '_MapaController.long', context: context);

  @override
  double get long {
    _$longAtom.reportRead();
    return super.long;
  }

  @override
  set long(double value) {
    _$longAtom.reportWrite(value, super.long, () {
      super.long = value;
    });
  }

  late final _$erroAtom = Atom(name: '_MapaController.erro', context: context);

  @override
  String get erro {
    _$erroAtom.reportRead();
    return super.erro;
  }

  @override
  set erro(String value) {
    _$erroAtom.reportWrite(value, super.erro, () {
      super.erro = value;
    });
  }

  late final _$getPosicaoAsyncAction =
      AsyncAction('_MapaController.getPosicao', context: context);

  @override
  Future getPosicao() {
    return _$getPosicaoAsyncAction.run(() => super.getPosicao());
  }

  late final _$_posicaoAtualAsyncAction =
      AsyncAction('_MapaController._posicaoAtual', context: context);

  @override
  Future<Position> _posicaoAtual() {
    return _$_posicaoAtualAsyncAction.run(() => super._posicaoAtual());
  }

  @override
  String toString() {
    return '''
lat: ${lat},
long: ${long},
erro: ${erro}
    ''';
  }
}
