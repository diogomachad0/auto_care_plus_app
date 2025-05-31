import 'package:auto_care_plus_app/app/modules/veiculo/veiculo_controller.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class VeiculoScreen extends StatefulWidget {
  const VeiculoScreen({super.key});

  @override
  State<VeiculoScreen> createState() => _VeiculoScreenState();
}

class _VeiculoScreenState extends State<VeiculoScreen> with ThemeMixin {
  final controller = Modular.get<VeiculoController>();

  @override
  void initState() {
    super.initState();
    controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.secondary,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildSearchBar(),
              Expanded(
                child: Observer(
                  builder: (_) {
                    final veiculos = controller.veiculos;
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              'assets/img/banners/rafiki.png',
                              width: 330,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Seus veículos cadastrados estão aqui!',
                              textAlign: TextAlign.center,
                              style: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                        Visibility(
                          visible: veiculos.isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              'MEUS VEÍCULOS',
                              style: textTheme.titleSmall?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                        if (veiculos.isNotEmpty)
                          ...veiculos.asMap().entries.map(
                            (entry) {
                              final index = entry.key;
                              final veiculoModel = entry.value;

                              return Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    Modular.to.pushNamed(
                                      editarVeiculoRoute,
                                      arguments: veiculoModel,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 0, bottom: 8, left: 8, right: 8),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${veiculoModel.modelo} (${veiculoModel.ano})',
                                              style: textTheme.titleMedium,
                                            ),
                                            PopupMenuButton<String>(
                                              icon: const Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                color: Colors.grey,
                                              ),
                                              onSelected: (value) async {
                                                if (value == 'delete') {
                                                  try {
                                                    await controller.delete(controller.veiculos[index]);
                                                  } catch (e, s) {
                                                    // await ErrorDialog.show(context, 'Erro ao deletar veiculo \nErro: ${e.toString()}', s);
                                                  }
                                                }
                                              },
                                              itemBuilder: (BuildContext context) => [
                                                const PopupMenuItem<String>(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
                                                      Text('Excluir'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Marca',
                                                    style: textTheme.bodySmall?.copyWith(
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                  Text(
                                                    veiculoModel.marca,
                                                    style: textTheme.bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Placa',
                                                    style: textTheme.bodySmall?.copyWith(
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                  Text(
                                                    veiculoModel.placa,
                                                    style: textTheme.bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: colorScheme.onPrimary,
            ),
            onPressed: () {
              Modular.to.navigate(menuRoute);
            },
          ),
          Text(
            'Meus veículos',
            style: textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add_rounded,
              color: colorScheme.onPrimary,
              size: 36,
            ),
            onPressed: () {
              Modular.to.navigate(adicionarVeiculoRoute);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFieldCustom(
        label: 'Pesquisar',
      ),
    );
  }
}
