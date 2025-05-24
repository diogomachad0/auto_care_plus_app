import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with ThemeMixin {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildSectionTitle('CONFIGURAÇÕES DO APP'),
                    _buildSectionBlock([
                      _buildMenuListItem(
                        title: 'Meus veículos',
                        subtitle: 'Gerencie seus veículos cadastrados',
                        onTap: () {
                          Modular.to.navigate(veiculoRoute);

                        },
                        isFirst: true,
                      ),
                      _buildMenuListItem(
                        title: 'Lembretes',
                        subtitle: 'Gerencie seus lembretes que você criou',
                        onTap: () {
                          Modular.to.navigate(lembreteRoute);

                        },
                      ),
                      _buildMenuListItemWithSwitch(
                        title: 'Notificações',
                        subtitle: 'Permita que você receba notificações do App',
                        value: notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            notificationsEnabled = value;
                          });
                        },
                      ),
                      _buildMenuListItem(
                        title: 'Contato',
                        subtitle:
                            'Dúvidas? Entre em contato conosco através do nosso suporte!',
                        onTap: () {
                          Modular.to.navigate(contatoRoute);
                        },
                      ),
                      _buildMenuListItem(
                        title: 'Sobre',
                        subtitle: 'Um pouco sobre o ',
                        highlightedText: 'AUTO CARE+',
                        onTap: () {},
                        isLast: true,
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionTitle('DEFINIÇÃO DO TEMA'),
                    _buildSectionBlock([
                      _buildMenuListItem(
                        title: 'Tema',
                        subtitle:
                            'Escolha o tema que deseja aplicar no aplicativo',
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
                        onTap: () {},
                        isFirst: true,
                      ),
                      _buildMenuListItem(
                        title: 'Altere de conta',
                        subtitle: 'Troque entre contas cadastradas',
                        onTap: () {},
                      ),
                      _buildMenuListItemWithIcon(
                        title: 'Sair',
                        subtitle: 'Logout do App',
                        icon: Icons.logout,
                        onTap: () {},
                        isLast: true,
                      ),
                    ]),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.secondary,
            colorScheme.primary,
          ],
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Menu',
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Image.asset(
                'assets/img/logo_white_app.png',
                height: 100,
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  text: 'Olá, ',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: 'Diogo!',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
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
        style: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.grey[500],
        ),
      ),
    );
  }

  Widget _buildSectionBlock(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: children,
      ),
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
          title: Text(
            title,
            style: textTheme.bodyLarge,
          ),
          subtitle: highlightedText != null
              ? RichText(
                  text: TextSpan(
                    text: subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
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
              : Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
          trailing: Icon(
            Icons.chevron_right,
            color: colorScheme.secondary,
            size: 30,
          ),
          onTap: onTap,
        ),
        if (!isLast)
          const Divider(
            height: 1,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
            color: Colors.white,
          ),
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
          title: Text(
            title,
            style: textTheme.bodyLarge,
          ),
          subtitle: Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(
              fontSize: 10,
              color: Colors.grey[500],
            ),
          ),
          trailing: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: colorScheme.primary,
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
            color: Colors.white,
          ),
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
          title: Text(
            title,
            style: textTheme.bodyLarge,
          ),
          subtitle: Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(
              fontSize: 10,
              color: Colors.grey[500],
            ),
          ),
          trailing: Icon(
            icon,
            color: Colors.grey[500],
          ),
          onTap: onTap,
        ),
        if (!isLast)
          const Divider(
            height: 1,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
            color: Colors.white,
          ),
      ],
    );
  }
}
