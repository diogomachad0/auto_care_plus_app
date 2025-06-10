// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atividade_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AtividadeController on _AtividadeControllerBase, Store {
  Computed<List<AtividadeStore>>? _$atividadesComCoordenadasComputed;

  @override
  List<AtividadeStore> get atividadesComCoordenadas =>
      (_$atividadesComCoordenadasComputed ??= Computed<List<AtividadeStore>>(
              () => super.atividadesComCoordenadas,
              name: '_AtividadeControllerBase.atividadesComCoordenadas'))
          .value;
  Computed<List<AtividadeStore>>? _$atividadesFiltradasComputed;

  @override
  List<AtividadeStore> get atividadesFiltradas =>
      (_$atividadesFiltradasComputed ??= Computed<List<AtividadeStore>>(
              () => super.atividadesFiltradas,
              name: '_AtividadeControllerBase.atividadesFiltradas'))
          .value;
  Computed<String>? _$nomeVeiculoSelecionadoComputed;

  @override
  String get nomeVeiculoSelecionado => (_$nomeVeiculoSelecionadoComputed ??=
          Computed<String>(() => super.nomeVeiculoSelecionado,
              name: '_AtividadeControllerBase.nomeVeiculoSelecionado'))
      .value;
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_AtividadeControllerBase.isFormValid'))
          .value;
  Computed<String>? _$veiculoSelecionadoNomeComputed;

  @override
  String get veiculoSelecionadoNome => (_$veiculoSelecionadoNomeComputed ??=
          Computed<String>(() => super.veiculoSelecionadoNome,
              name: '_AtividadeControllerBase.veiculoSelecionadoNome'))
      .value;
  Computed<List<AtividadeStore>>? _$abastecimentosComputed;

  @override
  List<AtividadeStore> get abastecimentos => (_$abastecimentosComputed ??=
          Computed<List<AtividadeStore>>(() => super.abastecimentos,
              name: '_AtividadeControllerBase.abastecimentos'))
      .value;
  Computed<List<AtividadeStore>>? _$trocasOleoComputed;

  @override
  List<AtividadeStore> get trocasOleo => (_$trocasOleoComputed ??=
          Computed<List<AtividadeStore>>(() => super.trocasOleo,
              name: '_AtividadeControllerBase.trocasOleo'))
      .value;
  Computed<List<AtividadeStore>>? _$lavagensComputed;

  @override
  List<AtividadeStore> get lavagens => (_$lavagensComputed ??=
          Computed<List<AtividadeStore>>(() => super.lavagens,
              name: '_AtividadeControllerBase.lavagens'))
      .value;
  Computed<List<AtividadeStore>>? _$segurosComputed;

  @override
  List<AtividadeStore> get seguros =>
      (_$segurosComputed ??= Computed<List<AtividadeStore>>(() => super.seguros,
              name: '_AtividadeControllerBase.seguros'))
          .value;
  Computed<List<AtividadeStore>>? _$servicosMecanicosComputed;

  @override
  List<AtividadeStore> get servicosMecanicos => (_$servicosMecanicosComputed ??=
          Computed<List<AtividadeStore>>(() => super.servicosMecanicos,
              name: '_AtividadeControllerBase.servicosMecanicos'))
      .value;
  Computed<List<AtividadeStore>>? _$financiamentosComputed;

  @override
  List<AtividadeStore> get financiamentos => (_$financiamentosComputed ??=
          Computed<List<AtividadeStore>>(() => super.financiamentos,
              name: '_AtividadeControllerBase.financiamentos'))
      .value;
  Computed<List<AtividadeStore>>? _$comprasComputed;

  @override
  List<AtividadeStore> get compras =>
      (_$comprasComputed ??= Computed<List<AtividadeStore>>(() => super.compras,
              name: '_AtividadeControllerBase.compras'))
          .value;
  Computed<List<AtividadeStore>>? _$impostosComputed;

  @override
  List<AtividadeStore> get impostos => (_$impostosComputed ??=
          Computed<List<AtividadeStore>>(() => super.impostos,
              name: '_AtividadeControllerBase.impostos'))
      .value;
  Computed<List<AtividadeStore>>? _$outrosComputed;

  @override
  List<AtividadeStore> get outros =>
      (_$outrosComputed ??= Computed<List<AtividadeStore>>(() => super.outros,
              name: '_AtividadeControllerBase.outros'))
          .value;
  Computed<double>? _$totalGastoGeralComputed;

  @override
  double get totalGastoGeral => (_$totalGastoGeralComputed ??= Computed<double>(
          () => super.totalGastoGeral,
          name: '_AtividadeControllerBase.totalGastoGeral'))
      .value;
  Computed<double>? _$totalGastoAbastecimentoComputed;

  @override
  double get totalGastoAbastecimento => (_$totalGastoAbastecimentoComputed ??=
          Computed<double>(() => super.totalGastoAbastecimento,
              name: '_AtividadeControllerBase.totalGastoAbastecimento'))
      .value;
  Computed<double>? _$totalGastoManutencaoComputed;

  @override
  double get totalGastoManutencao => (_$totalGastoManutencaoComputed ??=
          Computed<double>(() => super.totalGastoManutencao,
              name: '_AtividadeControllerBase.totalGastoManutencao'))
      .value;
  Computed<int>? _$totalAtividadesDoVeiculoComputed;

  @override
  int get totalAtividadesDoVeiculo => (_$totalAtividadesDoVeiculoComputed ??=
          Computed<int>(() => super.totalAtividadesDoVeiculo,
              name: '_AtividadeControllerBase.totalAtividadesDoVeiculo'))
      .value;

  late final _$searchTextAtom =
      Atom(name: '_AtividadeControllerBase.searchText', context: context);

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

  late final _$atividadeAtom =
      Atom(name: '_AtividadeControllerBase.atividade', context: context);

  @override
  AtividadeStore get atividade {
    _$atividadeAtom.reportRead();
    return super.atividade;
  }

  @override
  set atividade(AtividadeStore value) {
    _$atividadeAtom.reportWrite(value, super.atividade, () {
      super.atividade = value;
    });
  }

  late final _$atividadesAtom =
      Atom(name: '_AtividadeControllerBase.atividades', context: context);

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

  late final _$veiculosAtom =
      Atom(name: '_AtividadeControllerBase.veiculos', context: context);

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

  late final _$veiculoSelecionadoIdAtom = Atom(
      name: '_AtividadeControllerBase.veiculoSelecionadoId', context: context);

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

  late final _$loadVeiculosAsyncAction =
      AsyncAction('_AtividadeControllerBase.loadVeiculos', context: context);

  @override
  Future<void> loadVeiculos() {
    return _$loadVeiculosAsyncAction.run(() => super.loadVeiculos());
  }

  late final _$loadByIdAsyncAction =
      AsyncAction('_AtividadeControllerBase.loadById', context: context);

  @override
  Future<void> loadById(String id) {
    return _$loadByIdAsyncAction.run(() => super.loadById(id));
  }

  late final _$saveAsyncAction =
      AsyncAction('_AtividadeControllerBase.save', context: context);

  @override
  Future<void> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$_AtividadeControllerBaseActionController =
      ActionController(name: '_AtividadeControllerBase', context: context);

  @override
  void setEstabelecimentoComCoordenadas(
      String estabelecimento, double lat, double lng) {
    final _$actionInfo = _$_AtividadeControllerBaseActionController.startAction(
        name: '_AtividadeControllerBase.setEstabelecimentoComCoordenadas');
    try {
      return super.setEstabelecimentoComCoordenadas(estabelecimento, lat, lng);
    } finally {
      _$_AtividadeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setVeiculoSelecionado(String? veiculoId) {
    final _$actionInfo = _$_AtividadeControllerBaseActionController.startAction(
        name: '_AtividadeControllerBase.setVeiculoSelecionado');
    try {
      return super.setVeiculoSelecionado(veiculoId);
    } finally {
      _$_AtividadeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetForm() {
    final _$actionInfo = _$_AtividadeControllerBaseActionController.startAction(
        name: '_AtividadeControllerBase.resetForm');
    try {
      return super.resetForm();
    } finally {
      _$_AtividadeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparFiltros() {
    final _$actionInfo = _$_AtividadeControllerBaseActionController.startAction(
        name: '_AtividadeControllerBase.limparFiltros');
    try {
      return super.limparFiltros();
    } finally {
      _$_AtividadeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchText: ${searchText},
atividade: ${atividade},
atividades: ${atividades},
veiculos: ${veiculos},
veiculoSelecionadoId: ${veiculoSelecionadoId},
atividadesComCoordenadas: ${atividadesComCoordenadas},
atividadesFiltradas: ${atividadesFiltradas},
nomeVeiculoSelecionado: ${nomeVeiculoSelecionado},
isFormValid: ${isFormValid},
veiculoSelecionadoNome: ${veiculoSelecionadoNome},
abastecimentos: ${abastecimentos},
trocasOleo: ${trocasOleo},
lavagens: ${lavagens},
seguros: ${seguros},
servicosMecanicos: ${servicosMecanicos},
financiamentos: ${financiamentos},
compras: ${compras},
impostos: ${impostos},
outros: ${outros},
totalGastoGeral: ${totalGastoGeral},
totalGastoAbastecimento: ${totalGastoAbastecimento},
totalGastoManutencao: ${totalGastoManutencao},
totalAtividadesDoVeiculo: ${totalAtividadesDoVeiculo}
    ''';
  }
}
