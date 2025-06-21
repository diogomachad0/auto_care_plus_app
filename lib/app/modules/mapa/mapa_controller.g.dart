// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mapa_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MapaController on _MapaControllerBase, Store {
  Computed<dynamic>? _$atividadesComLocalizacaoComputed;

  @override
  dynamic get atividadesComLocalizacao =>
      (_$atividadesComLocalizacaoComputed ??= Computed<dynamic>(
              () => super.atividadesComLocalizacao,
              name: '_MapaControllerBase.atividadesComLocalizacao'))
          .value;
  Computed<dynamic>? _$veiculosComputed;

  @override
  dynamic get veiculos =>
      (_$veiculosComputed ??= Computed<dynamic>(() => super.veiculos,
              name: '_MapaControllerBase.veiculos'))
          .value;
  Computed<String?>? _$veiculoSelecionadoIdComputed;

  @override
  String? get veiculoSelecionadoId => (_$veiculoSelecionadoIdComputed ??=
          Computed<String?>(() => super.veiculoSelecionadoId,
              name: '_MapaControllerBase.veiculoSelecionadoId'))
      .value;
  Computed<String>? _$nomeVeiculoSelecionadoComputed;

  @override
  String get nomeVeiculoSelecionado => (_$nomeVeiculoSelecionadoComputed ??=
          Computed<String>(() => super.nomeVeiculoSelecionado,
              name: '_MapaControllerBase.nomeVeiculoSelecionado'))
      .value;

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

  late final _$_MapaControllerBaseActionController =
      ActionController(name: '_MapaControllerBase', context: context);

  @override
  void setVeiculoSelecionado(String? veiculoId) {
    final _$actionInfo = _$_MapaControllerBaseActionController.startAction(
        name: '_MapaControllerBase.setVeiculoSelecionado');
    try {
      return super.setVeiculoSelecionado(veiculoId);
    } finally {
      _$_MapaControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
myPosition: ${myPosition},
atividadesComLocalizacao: ${atividadesComLocalizacao},
veiculos: ${veiculos},
veiculoSelecionadoId: ${veiculoSelecionadoId},
nomeVeiculoSelecionado: ${nomeVeiculoSelecionado}
    ''';
  }
}
