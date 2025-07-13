// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeController on _HomeControllerBase, Store {
  Computed<String>? _$nomeVeiculoSelecionadoComputed;

  @override
  String get nomeVeiculoSelecionado => (_$nomeVeiculoSelecionadoComputed ??=
          Computed<String>(() => super.nomeVeiculoSelecionado,
              name: '_HomeControllerBase.nomeVeiculoSelecionado'))
      .value;
  Computed<List<AtividadeStore>>? _$atividadesFiltradasComputed;

  @override
  List<AtividadeStore> get atividadesFiltradas =>
      (_$atividadesFiltradasComputed ??= Computed<List<AtividadeStore>>(
              () => super.atividadesFiltradas,
              name: '_HomeControllerBase.atividadesFiltradas'))
          .value;
  Computed<Map<String, double>>? _$gastosCategorizadosComputed;

  @override
  Map<String, double> get gastosCategorizados =>
      (_$gastosCategorizadosComputed ??= Computed<Map<String, double>>(
              () => super.gastosCategorizados,
              name: '_HomeControllerBase.gastosCategorizados'))
          .value;
  Computed<double>? _$totalGastosComputed;

  @override
  double get totalGastos =>
      (_$totalGastosComputed ??= Computed<double>(() => super.totalGastos,
              name: '_HomeControllerBase.totalGastos'))
          .value;
  Computed<Map<String, double>>? _$gastosMensaisComputed;

  @override
  Map<String, double> get gastosMensais => (_$gastosMensaisComputed ??=
          Computed<Map<String, double>>(() => super.gastosMensais,
              name: '_HomeControllerBase.gastosMensais'))
      .value;
  Computed<List<MonthlyExpense>>? _$gastosMensaisListaComputed;

  @override
  List<MonthlyExpense> get gastosMensaisLista =>
      (_$gastosMensaisListaComputed ??= Computed<List<MonthlyExpense>>(
              () => super.gastosMensaisLista,
              name: '_HomeControllerBase.gastosMensaisLista'))
          .value;

  late final _$veiculosAtom =
      Atom(name: '_HomeControllerBase.veiculos', context: context);

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

  late final _$atividadesAtom =
      Atom(name: '_HomeControllerBase.atividades', context: context);

  @override
  ObservableList<AtividadeStore> get atividades {
    _$atividadesAtom.reportRead();
    return super.atividades;
  }

  @override
  set atividades(ObservableList<AtividadeStore> value) {
    _$atividadesAtom.reportWrite(value, super.atividades, () {
      super.atividades = value;
    });
  }

  late final _$veiculoSelecionadoIdAtom =
      Atom(name: '_HomeControllerBase.veiculoSelecionadoId', context: context);

  @override
  String? get veiculoSelecionadoId {
    _$veiculoSelecionadoIdAtom.reportRead();
    return super.veiculoSelecionadoId;
  }

  @override
  set veiculoSelecionadoId(String? value) {
    _$veiculoSelecionadoIdAtom.reportWrite(value, super.veiculoSelecionadoId,
        () {
      super.veiculoSelecionadoId = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_HomeControllerBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$_HomeControllerBaseActionController =
      ActionController(name: '_HomeControllerBase', context: context);

  @override
  void setVeiculoSelecionado(String? veiculoId) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.setVeiculoSelecionado');
    try {
      return super.setVeiculoSelecionado(veiculoId);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
veiculos: ${veiculos},
atividades: ${atividades},
veiculoSelecionadoId: ${veiculoSelecionadoId},
isLoading: ${isLoading},
nomeVeiculoSelecionado: ${nomeVeiculoSelecionado},
atividadesFiltradas: ${atividadesFiltradas},
gastosCategorizados: ${gastosCategorizados},
totalGastos: ${totalGastos},
gastosMensais: ${gastosMensais},
gastosMensaisLista: ${gastosMensaisLista}
    ''';
  }
}
