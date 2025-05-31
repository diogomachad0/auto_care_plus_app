// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'veiculo_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VeiculoController on _VeiculoControllerBase, Store {
  late final _$veiculosAtom =
      Atom(name: '_VeiculoControllerBase.veiculos', context: context);

  @override
  ObservableList<VeiculoModel> get veiculos {
    _$veiculosAtom.reportRead();
    return super.veiculos;
  }

  @override
  set veiculos(ObservableList<VeiculoModel> value) {
    _$veiculosAtom.reportWrite(value, super.veiculos, () {
      super.veiculos = value;
    });
  }

  late final _$loadAsyncAction =
      AsyncAction('_VeiculoControllerBase.load', context: context);

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$saveAsyncAction =
      AsyncAction('_VeiculoControllerBase.save', context: context);

  @override
  Future<void> save(VeiculoModel model) {
    return _$saveAsyncAction.run(() => super.save(model));
  }

  late final _$deleteAsyncAction =
      AsyncAction('_VeiculoControllerBase.delete', context: context);

  @override
  Future<void> delete(VeiculoModel model) {
    return _$deleteAsyncAction.run(() => super.delete(model));
  }

  @override
  String toString() {
    return '''
veiculos: ${veiculos}
    ''';
  }
}
