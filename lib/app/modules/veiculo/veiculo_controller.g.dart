// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'veiculo_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VeiculoController on _VeiculoControllerBase, Store {
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

  @override
  String toString() {
    return '''
veiculo: ${veiculo}
    ''';
  }
}
