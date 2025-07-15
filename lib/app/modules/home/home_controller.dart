import 'package:auto_care_plus_app/app/modules/atividade/services/atividade_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/atividade/store/atividade_store.dart';
import 'package:auto_care_plus_app/app/modules/home/home_screen.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/services/veiculo_service_interface.dart';
import 'package:auto_care_plus_app/app/modules/veiculo/store/veiculo_store.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

class MonthlyExpense {
  final String month;
  final double value;
  final Color color;

  MonthlyExpense(this.month, this.value, this.color);
}

abstract class _HomeControllerBase with Store {
  final IVeiculoService _veiculoService;
  final IAtividadeService _atividadeService;

  @observable
  ObservableList<VeiculoStore> veiculos = ObservableList<VeiculoStore>();

  @observable
  ObservableList<AtividadeStore> atividades = ObservableList<AtividadeStore>();

  @observable
  String? veiculoSelecionadoId;

  @observable
  bool isLoading = false;

  _HomeControllerBase(this._veiculoService, this._atividadeService);

  @computed
  String get nomeVeiculoSelecionado {
    if (veiculoSelecionadoId == null) return 'Todos os veículos';

    final veiculo = veiculos.firstWhere(
          (v) => v.base.id == veiculoSelecionadoId,
      orElse: () => VeiculoStoreFactory.novo(),
    );

    return '${veiculo.modelo} - ${veiculo.placa}';
  }

  @computed
  List<AtividadeStore> get atividadesFiltradas {
    if (veiculoSelecionadoId == null) {
      return atividades;
    }

    return atividades.where((atividade) =>
    atividade.veiculoId == veiculoSelecionadoId
    ).toList();
  }

  @computed
  Map<String, double> get gastosCategorizados {
    final gastos = <String, double>{
      'Reabastecimento': 0.0,
      'Troca de Óleo': 0.0,
      'Lavagem': 0.0,
      'Seguro': 0.0,
      'Serviço Mecânico': 0.0,
      'Financiamento': 0.0,
      'Compras': 0.0,
      'Impostos': 0.0,
      'Outros': 0.0,
    };

    for (var atividade in atividadesFiltradas) {
      final valor = _parseValor(atividade.totalPago);
      final categoria = _mapearCategoria(atividade.tipoAtividade ?? '');

      if (gastos.containsKey(categoria)) {
        gastos[categoria] = gastos[categoria]! + valor;
      } else {
        gastos['Outros'] = gastos['Outros']! + valor;
      }
    }

    return gastos;
  }

  @computed
  double get totalGastos {
    return gastosCategorizados.values.fold(0.0, (sum, valor) => sum + valor);
  }

  @computed
  Map<String, double> get gastosMensais {
    final gastosPorMes = <String, double>{};
    final now = DateTime.now();

    for (int i = 2; i >= 0; i--) {
      final mes = DateTime(now.year, now.month - i, 1);
      final chave = _formatarMesAno(mes);
      gastosPorMes[chave] = 0.0;
    }

    for (var atividade in atividadesFiltradas) {
      if (atividade.data.isNotEmpty) {
        try {
          DateTime? dataAtividade = _parseData(atividade.data);

          if (dataAtividade != null) {
            final chave = _formatarMesAno(dataAtividade);
            final valor = _parseValor(atividade.totalPago);

            if (gastosPorMes.containsKey(chave)) {
              gastosPorMes[chave] = gastosPorMes[chave]! + valor;
            }
          }
        } catch (e) {
        }
      }
    }

    return gastosPorMes;
  }

  @computed
  List<MonthlyExpense> get gastosMensaisLista {
    final gastos = gastosMensais;
    final cores = [
      const Color(0xFF42A5F5),
      const Color(0xFF1E88E5),
      const Color(0xFF1565C0),
    ];

    return gastos.entries.map((entry) {
      final index = gastos.keys.toList().indexOf(entry.key);
      return MonthlyExpense(
        _formatarMesParaExibicao(entry.key),
        entry.value,
        cores[index % cores.length],
      );
    }).toList();
  }

  Future<void> loadVeiculos() async {
    try {
      isLoading = true;
      final list = await _veiculoService.getAll();

      veiculos.clear();
      for (var veiculo in list) {
        veiculos.add(VeiculoStoreFactory.fromModel(veiculo));
      }
    } catch (e) {
    } finally {
      isLoading = false;
    }
  }

  Future<void> loadAtividades() async {
    try {
      isLoading = true;
      final list = await _atividadeService.getAll();

      atividades.clear();
      for (var atividade in list) {
        atividades.add(AtividadeStoreFactory.fromModel(atividade));
      }
    } catch (e) {
    } finally {
      isLoading = false;
    }
  }

  Future<void> load() async {
    await Future.wait([
      loadVeiculos(),
      loadAtividades(),
    ]);
  }

  @action
  void setVeiculoSelecionado(String? veiculoId) {
    veiculoSelecionadoId = veiculoId;
  }

  double _parseValor(String? valor) {
    return CurrencyParser.parseToDouble(valor);
  }

  String _mapearCategoria(String tipoAtividade) {
    switch (tipoAtividade.toLowerCase()) {
      case 'abastecimento':
        return 'Reabastecimento';
      case 'troca de óleo':
        return 'Troca de Óleo';
      case 'lavagem':
        return 'Lavagem';
      case 'seguro':
        return 'Seguro';
      case 'serviço mecânico':
        return 'Serviço Mecânico';
      case 'financiamento':
        return 'Financiamento';
      case 'compras':
        return 'Compras';
      case 'impostos':
        return 'Impostos';
      case 'outros':
        return 'Outros';
      default:
        return 'Outros';
    }
  }

  DateTime? _parseData(String dataString) {
    if (dataString.isEmpty) return null;

    try {
      if (dataString.contains('T')) {
        return DateTime.parse(dataString);
      }

      if (dataString.contains('/')) {
        final partes = dataString.split('/');
        if (partes.length == 3) {
          final dia = int.parse(partes[0]);
          final mes = int.parse(partes[1]);
          final ano = int.parse(partes[2]);
          return DateTime(ano, mes, dia);
        }
      }

      if (dataString.contains('-') && dataString.length == 10) {
        final partes = dataString.split('-');
        if (partes.length == 3) {
          final ano = int.parse(partes[0]);
          final mes = int.parse(partes[1]);
          final dia = int.parse(partes[2]);
          return DateTime(ano, mes, dia);
        }
      }

      return DateTime.parse(dataString);
    } catch (e) {
      return null;
    }
  }

  String _formatarMesAno(DateTime data) {
    return '${data.year}-${data.month.toString().padLeft(2, '0')}';
  }

  String _formatarMesParaExibicao(String chave) {
    final partes = chave.split('-');
    final ano = int.parse(partes[0]);
    final mes = int.parse(partes[1]);

    final nomesMeses = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];

    return nomesMeses[mes - 1];
  }
}
