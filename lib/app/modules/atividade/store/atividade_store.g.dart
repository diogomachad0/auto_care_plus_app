// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atividade_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AtividadeStore on _AtividadeStoreBase, Store {
  late final _$baseAtom =
      Atom(name: '_AtividadeStoreBase.base', context: context);

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

  late final _$tipoAtividadeAtom =
      Atom(name: '_AtividadeStoreBase.tipoAtividade', context: context);

  @override
  String get tipoAtividade {
    _$tipoAtividadeAtom.reportRead();
    return super.tipoAtividade;
  }

  @override
  set tipoAtividade(String value) {
    _$tipoAtividadeAtom.reportWrite(value, super.tipoAtividade, () {
      super.tipoAtividade = value;
    });
  }

  late final _$dataAtom =
      Atom(name: '_AtividadeStoreBase.data', context: context);

  @override
  String get data {
    _$dataAtom.reportRead();
    return super.data;
  }

  @override
  set data(String value) {
    _$dataAtom.reportWrite(value, super.data, () {
      super.data = value;
    });
  }

  late final _$kmAtom = Atom(name: '_AtividadeStoreBase.km', context: context);

  @override
  String get km {
    _$kmAtom.reportRead();
    return super.km;
  }

  @override
  set km(String value) {
    _$kmAtom.reportWrite(value, super.km, () {
      super.km = value;
    });
  }

  late final _$totalPagoAtom =
      Atom(name: '_AtividadeStoreBase.totalPago', context: context);

  @override
  String get totalPago {
    _$totalPagoAtom.reportRead();
    return super.totalPago;
  }

  @override
  set totalPago(String value) {
    _$totalPagoAtom.reportWrite(value, super.totalPago, () {
      super.totalPago = value;
    });
  }

  late final _$litrosAtom =
      Atom(name: '_AtividadeStoreBase.litros', context: context);

  @override
  String get litros {
    _$litrosAtom.reportRead();
    return super.litros;
  }

  @override
  set litros(String value) {
    _$litrosAtom.reportWrite(value, super.litros, () {
      super.litros = value;
    });
  }

  late final _$tipoCombustivelAtom =
      Atom(name: '_AtividadeStoreBase.tipoCombustivel', context: context);

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

  late final _$estabelecimentoAtom =
      Atom(name: '_AtividadeStoreBase.estabelecimento', context: context);

  @override
  String get estabelecimento {
    _$estabelecimentoAtom.reportRead();
    return super.estabelecimento;
  }

  @override
  set estabelecimento(String value) {
    _$estabelecimentoAtom.reportWrite(value, super.estabelecimento, () {
      super.estabelecimento = value;
    });
  }

  late final _$numeroParcelaAtom =
      Atom(name: '_AtividadeStoreBase.numeroParcela', context: context);

  @override
  String get numeroParcela {
    _$numeroParcelaAtom.reportRead();
    return super.numeroParcela;
  }

  @override
  set numeroParcela(String value) {
    _$numeroParcelaAtom.reportWrite(value, super.numeroParcela, () {
      super.numeroParcela = value;
    });
  }

  late final _$observacoesAtom =
      Atom(name: '_AtividadeStoreBase.observacoes', context: context);

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

  late final _$latitudeAtom =
      Atom(name: '_AtividadeStoreBase.latitude', context: context);

  @override
  String get latitude {
    _$latitudeAtom.reportRead();
    return super.latitude;
  }

  @override
  set latitude(String value) {
    _$latitudeAtom.reportWrite(value, super.latitude, () {
      super.latitude = value;
    });
  }

  late final _$longitudeAtom =
      Atom(name: '_AtividadeStoreBase.longitude', context: context);

  @override
  String get longitude {
    _$longitudeAtom.reportRead();
    return super.longitude;
  }

  @override
  set longitude(String value) {
    _$longitudeAtom.reportWrite(value, super.longitude, () {
      super.longitude = value;
    });
  }

  @override
  String toString() {
    return '''
base: ${base},
tipoAtividade: ${tipoAtividade},
data: ${data},
km: ${km},
totalPago: ${totalPago},
litros: ${litros},
tipoCombustivel: ${tipoCombustivel},
estabelecimento: ${estabelecimento},
numeroParcela: ${numeroParcela},
observacoes: ${observacoes},
latitude: ${latitude},
longitude: ${longitude}
    ''';
  }
}
