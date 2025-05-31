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
                        // Imagem e texto sempre no topo
                        Column(
                          children: [
                            Image.asset(
                              'assets/img/banners/rafiki.png',
                              height: 200,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Seus veículos cadastrados estão aqui!',
                              textAlign: TextAlign.center,
                              style: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),

                        // Lista de veículos em cards
                        if (veiculos.isNotEmpty)
                          ...veiculos.map(
                                (veiculoModel) => Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                title: Text(
                                  veiculoModel.modelo,
                                  style: textTheme.bodyLarge,
                                ),
                                subtitle:
                                Text('${veiculoModel.marca} - ${veiculoModel.placa}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_forever_rounded),
                                  color: Colors.redAccent,
                                  onPressed: () => controller.delete(veiculoModel),
                                ),
                                onTap: () {
                                  Modular.to.pushNamed(
                                    editarVeiculoRoute,
                                    arguments: veiculoModel,
                                  );
                                },
                              ),
                            ),
                          )
                        else
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: Text(
                                'Nenhum veículo cadastrado.',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            ),
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

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/banners/rafiki.png',
            height: 200,
          ),
          const SizedBox(height: 16),
          Text(
            'Seus veículos cadastrados estão aqui!'
            ,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onPrimary,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
