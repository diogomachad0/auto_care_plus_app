// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'veiculo_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VeiculoController on _VeiculoControllerBase, Store {
  Computed<List<VeiculoStore>>? _$veiculosFiltradosComputed;

  @override
  List<VeiculoStore> get veiculosFiltrados => (_$veiculosFiltradosComputed ??=
          Computed<List<VeiculoStore>>(() => super.veiculosFiltrados,
              name: '_VeiculoControllerBase.veiculosFiltrados'))
      .value;

  late final _$veiculoAtom =
      Atom(name: '_VeiculoControllerBase.veiculo', context: context);

  @override
  VeiculoStore get veiculo {
    _$veiculoAtom.reportRead();
    return super.veiculo;
  }

  @override
  set veiculo(VeiculoStore value) {
    _$veiculoAtom.reportWrite(value, super.veiculo, () {
      super.veiculo = value;
    });
  }

  late final _$veiculosAtom =
      Atom(name: '_VeiculoControllerBase.veiculos', context: context);

  @override
  ObservableList<VeiculoStore> get veiculos {
    _$veiculosAtom.reportRead();
    return super.veiculos;
  }

  @override
  set veiculos(ObservableList<VeiculoStore> value) {
    _$veiculosAtom.reportWrite(value, super.veiculos, () {
      super.veiculos = value;
    });
  }

  late final _$searchTextAtom =
      Atom(name: '_VeiculoControllerBase.searchText', context: context);

  @override
  String get searchText {
    _$searchTextAtom.reportRead();
    return super.searchText;
  }

  @override
  set searchText(String value) {
    _$searchTextAtom.reportWrite(value, super.searchText, () {
      super.searchText = value;
    });
  }

  @override
  String toString() {
    return '''
veiculo: ${veiculo},
veiculos: ${veiculos},
searchText: ${searchText},
veiculosFiltrados: ${veiculosFiltrados}
    ''';
  }
}
