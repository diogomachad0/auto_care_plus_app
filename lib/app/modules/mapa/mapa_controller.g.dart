// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mapa_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MapaController on _MapaControllerBase, Store {
  late final _$myPositionAtom =
      Atom(name: '_MapaControllerBase.myPosition', context: context);

  @override
  LatLng? get myPosition {
    _$myPositionAtom.reportRead();
    return super.myPosition;
  }

  @override
  set myPosition(LatLng? value) {
    _$myPositionAtom.reportWrite(value, super.myPosition, () {
      super.myPosition = value;
    });
  }

  late final _$mapaControllerAsyncAction =
      AsyncAction('_MapaControllerBase.mapaController', context: context);

  @override
  Future<void> mapaController() {
    return _$mapaControllerAsyncAction.run(() => super.mapaController());
  }

  @override
  String toString() {
    return '''
myPosition: ${myPosition}
    ''';
  }
}
