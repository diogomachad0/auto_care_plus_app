// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'veiculo_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VeiculoStore on _VeiculoStoreBase, Store {
  late final _$baseAtom =
      Atom(name: '_VeiculoStoreBase.base', context: context);

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

  late final _$modeloAtom =
      Atom(name: '_VeiculoStoreBase.modelo', context: context);

  @override
  String get modelo {
    _$modeloAtom.reportRead();
    return super.modelo;
  }

  @override
  set modelo(String value) {
    _$modeloAtom.reportWrite(value, super.modelo, () {
      super.modelo = value;
    });
  }

  late final _$marcaAtom =
      Atom(name: '_VeiculoStoreBase.marca', context: context);

  @override
  String get marca {
    _$marcaAtom.reportRead();
    return super.marca;
  }

  @override
  set marca(String value) {
    _$marcaAtom.reportWrite(value, super.marca, () {
      super.marca = value;
    });
  }

  late final _$placaAtom =
      Atom(name: '_VeiculoStoreBase.placa', context: context);

  @override
  String get placa {
    _$placaAtom.reportRead();
    return super.placa;
  }

  @override
  set placa(String value) {
    _$placaAtom.reportWrite(value, super.placa, () {
      super.placa = value;
    });
  }

  late final _$anoAtom = Atom(name: '_VeiculoStoreBase.ano', context: context);

  @override
  int get ano {
    _$anoAtom.reportRead();
    return super.ano;
  }

  @override
  set ano(int value) {
    _$anoAtom.reportWrite(value, super.ano, () {
      super.ano = value;
    });
  }

  late final _$quilometragemAtom =
      Atom(name: '_VeiculoStoreBase.quilometragem', context: context);

  @override
  int get quilometragem {
    _$quilometragemAtom.reportRead();
    return super.quilometragem;
  }

  @override
  set quilometragem(int value) {
    _$quilometragemAtom.reportWrite(value, super.quilometragem, () {
      super.quilometragem = value;
    });
  }

  late final _$tipoCombustivelAtom =
      Atom(name: '_VeiculoStoreBase.tipoCombustivel', context: context);

  @override
  String get tipoCombustivel {
    _$tipoCombustivelAtom.reportRead();
    return super.tipoCombustivel;
  }

  @override
  set tipoCombustivel(String value) {
    _$tipoCombustivelAtom.reportWrite(value, super.tipoCombustivel, () {
      super.tipoCombustivel = value;
    });
  }

  late final _$observacoesAtom =
      Atom(name: '_VeiculoStoreBase.observacoes', context: context);

  @override
  String get observacoes {
    _$observacoesAtom.reportRead();
    return super.observacoes;
  }

  @override
  set observacoes(String value) {
    _$observacoesAtom.reportWrite(value, super.observacoes, () {
      super.observacoes = value;
    });
  }

  @override
  String toString() {
    return '''
base: ${base},
modelo: ${modelo},
marca: ${marca},
placa: ${placa},
ano: ${ano},
quilometragem: ${quilometragem},
tipoCombustivel: ${tipoCombustivel},
observacoes: ${observacoes}
    ''';
  }
}
