import 'package:auto_care_plus_app/app/modules/lembrete/lembrete_controller.dart';
import 'package:auto_care_plus_app/app/modules/lembrete/submodules/adicionar_lembrete/adicionar_lembrete_widget.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:auto_care_plus_app/app/shared/widgets/dialog_custom/dialog_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';


class LembreteScreen extends StatefulWidget {
  const LembreteScreen({super.key});

  @override
  State<LembreteScreen> createState() => _LembreteScreenState();
}

class _LembreteScreenState extends State<LembreteScreen> with ThemeMixin {
  final controller = Modular.get<LembreteController>();

  @override
  void initState() {
    super.initState();
    controller.load();
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
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
              Expanded(
                child: Observer(
                  builder: (_) {
                    final lembretes = controller.lembretes;

                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              'assets/img/banners/amico.png',
                              width: 300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Todos os seus lembretes em um só lugar!',
                              textAlign: TextAlign.center,
                              style: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                        Visibility(
                          visible: lembretes.isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'MEUS LEMBRETES',
                              style: textTheme.titleSmall?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                        if (lembretes.isNotEmpty)
                          ...lembretes.asMap().entries.map(
                                (entry) {
                              final index = entry.key;
                              final lembreteModel = entry.value;

                              return Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 0, bottom: 8, left: 8, right: 8),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              lembreteModel.titulo,
                                              style: textTheme.titleMedium,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            offset: const Offset(-2, 8),
                                            color: colorScheme.onPrimary,
                                            icon: const Padding(
                                              padding: EdgeInsets.only(left: 16),
                                              child: Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(16)),
                                            ),
                                            onSelected: (value) async {
                                              if (value == 'delete') {
                                                try {
                                                  await controller.delete(controller.lembretes[index]);
                                                } catch (e, s) {
                                                  await DialogError.show(context, 'Erro ao deletar lembrete \nErro: ${e.toString()}', s);
                                                }
                                              }
                                            },
                                            itemBuilder: (BuildContext context) => [
                                              PopupMenuItem<String>(
                                                value: 'delete',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.delete_forever_rounded, color: colorScheme.error),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Excluir',
                                                      style: textTheme.bodyMedium,
                                                    ),
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
                                                  'Data',
                                                  style: textTheme.bodySmall?.copyWith(
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                                Text(
                                                  _formatDate(lembreteModel.data),
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
                                                  'Notificação',
                                                  style: textTheme.bodySmall?.copyWith(
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Icon(
                                                      lembreteModel.notificar
                                                          ? Icons.notifications_active
                                                          : Icons.notifications_off,
                                                      size: 16,
                                                      color: lembreteModel.notificar
                                                          ? colorScheme.primary
                                                          : Colors.grey,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      lembreteModel.notificar ? 'Ativa' : 'Inativa',
                                                      style: textTheme.bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
            'Lembretes',
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
              showAdicionarLembreteDialog(context);
            },
          )
,
        ],
      ),
    );
  }
}
