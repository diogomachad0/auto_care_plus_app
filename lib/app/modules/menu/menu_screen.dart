import 'package:auto_care_plus_app/app/modules/usuario/usuario_controller.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:auto_care_plus_app/app/shared/services/autenticacao_service/auth_service.dart';
import 'package:auto_care_plus_app/app/shared/widgets/bottom_sheet_custom/bottom_sheet_conta.dart';
import 'package:auto_care_plus_app/app/shared/widgets/bottom_sheet_custom/bottom_sheet_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with ThemeMixin {
  bool notificationsEnabled = false;

  final AuthService _authService = Modular.get<AuthService>();
  late final UsuarioController _usuarioController;

  @override
  void initState() {
    super.initState();
    _usuarioController = Modular.get<UsuarioController>();
    _usuarioController.loadCurrentUser();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
    });
  }

  Future<void> _updateNotificationPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).padding.bottom + 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildSectionTitle('CONFIGURAÇÕES DO APP'),
                  _buildSectionBlock([
                    _buildMenuListItem(
                      title: 'Meus veículos',
                      subtitle: 'Gerencie seus veículos cadastrados',
                      onTap: () => Modular.to.navigate(veiculoRoute),
                      isFirst: true,
                    ),
                    _buildMenuListItem(
                      title: 'Lembretes',
                      subtitle: 'Gerencie seus lembretes que você criou',
                      onTap: () => Modular.to.navigate(lembreteRoute),
                    ),
                    _buildMenuListItemWithSwitch(
                      title: 'Notificações',
                      subtitle: 'Permita que você receba notificações do App',
                      value: notificationsEnabled,
                      onChanged: (value) async {
                        if (value) {
                          final status = await Permission.notification.request();
                          if (status.isGranted) {
                            setState(() {
                              notificationsEnabled = true;
                            });
                            await _updateNotificationPreference(true);
                          } else {
                            setState(() {
                              notificationsEnabled = false;
                            });
                            await _updateNotificationPreference(false);

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Permissão para notificações negada. Ativação cancelada.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        } else {
                          setState(() {
                            notificationsEnabled = false;
                          });
                          await _updateNotificationPreference(false);
                        }
                      },
                    ),
                    _buildMenuListItem(
                      title: 'Contato',
                      subtitle: 'Dúvidas? Entre em contato conosco através do nosso suporte!',
                      onTap: () => Modular.to.navigate(contatoRoute),
                    ),
                    _buildMenuListItem(
                      title: 'Sobre',
                      subtitle: 'Um pouco sobre o ',
                      highlightedText: 'AUTO CARE+',
                      onTap: () => Modular.to.navigate(sobreRoute),
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _buildSectionTitle('DEFINIÇÃO DO TEMA'),
                  _buildSectionBlock([
                    _buildMenuListItem(
                      title: 'Tema',
                      subtitle: 'Escolha o tema que deseja aplicar no aplicativo',
                      onTap: () {},
                      isFirst: true,
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _buildSectionTitle('CONFIGURAÇÕES DA CONTA'),
                  _buildSectionBlock([
                    _buildMenuListItem(
                      title: 'Minha conta',
                      subtitle: 'Gerencie os dados da conta',
                      onTap: () => Modular.to.navigate(contaRoute),
                      isFirst: true,
                    ),
                    _buildMenuListItem(
                      title: 'Altere de conta',
                      subtitle: 'Troque entre contas cadastradas',
                      onTap: () {
                        final currentUserName = _usuarioController.usuario.nome.isNotEmpty ? _usuarioController.usuario.nome : 'Usuário';
                        final currentUserEmail = _usuarioController.usuario.email.isNotEmpty ? _usuarioController.usuario.email : 'email@exemplo.com';

                        BottomSheetConta.show(
                          context: context,
                          accounts: [
                            UserAccount(id: '1', name: currentUserName, email: currentUserEmail),
                          ],
                          activeAccountId: '1',
                          onAccountSelected: (_) {},
                          onAddAccount: () {},
                        );
                      },
                    ),
                    _buildMenuListItemWithIcon(
                      title: 'Sair',
                      subtitle: 'Logout do App',
                      icon: Icons.logout,
                      onTap: () {
                        ConfirmarBottomSheet.show(
                          context: context,
                          titulo: 'Atenção',
                          mensagem: 'Você realmente quer fazer logout?',
                          textoConfirmar: 'Sair',
                          onConfirmar: () async => await _performLogout(),
                        );
                      },
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      await _authService.logout();

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao fazer logout: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colorScheme.secondary, colorScheme.primary],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Column(
            children: [
              Text('Menu', style: textTheme.titleLarge?.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              Image.asset('assets/img/logo_white_app.png', height: 100),
              const SizedBox(height: 8),
              Observer(
                builder: (_) {
                  final nome = _usuarioController.usuario.nome;
                  final firstName = nome.isNotEmpty ? nome.split(' ').first : 'Usuário';
                  return Text.rich(
                    TextSpan(
                      text: 'Olá, ',
                      style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w300, color: Colors.white),
                      children: [
                        TextSpan(
                          text: '$firstName!',
                          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[500]),
      ),
    );
  }

  Widget _buildSectionBlock(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _buildMenuListItem({
    required String title,
    required String subtitle,
    String? highlightedText,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          dense: true,
          title: Text(title, style: textTheme.bodyLarge),
          subtitle: highlightedText != null
              ? RichText(
                  text: TextSpan(
                    text: subtitle,
                    style: textTheme.bodySmall?.copyWith(fontSize: 12, color: Colors.grey[500]),
                    children: [
                      TextSpan(
                        text: highlightedText,
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : Text(subtitle, style: textTheme.bodySmall?.copyWith(fontSize: 10, color: Colors.grey[500])),
          trailing: Icon(Icons.chevron_right_rounded, color: colorScheme.secondary, size: 30),
          onTap: onTap,
        ),
        if (!isLast) const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16, color: Colors.white),
      ],
    );
  }

  Widget _buildMenuListItemWithSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: textTheme.bodyLarge),
          subtitle: Text(subtitle, style: textTheme.bodySmall?.copyWith(fontSize: 10, color: Colors.grey[500])),
          trailing: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: colorScheme.primary,
          ),
        ),
        if (!isLast) const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16, color: Colors.white),
      ],
    );
  }

  Widget _buildMenuListItemWithIcon({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: textTheme.bodyLarge),
          subtitle: Text(subtitle, style: textTheme.bodySmall?.copyWith(fontSize: 10, color: Colors.grey[500])),
          trailing: Icon(icon, color: colorScheme.secondary),
          onTap: onTap,
        ),
        if (!isLast) const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16, color: Colors.white),
      ],
    );
  }
}
