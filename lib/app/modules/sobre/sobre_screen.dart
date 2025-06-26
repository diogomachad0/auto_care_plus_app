import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:auto_care_plus_app/app/shared/widgets/dialog_custom/dialog_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SobreScreen extends StatefulWidget {
  const SobreScreen({super.key});

  @override
  State<SobreScreen> createState() => _SobreScreenState();
}

class _SobreScreenState extends State<SobreScreen> with ThemeMixin {
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
              const SizedBox(height: 32),
              Expanded(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/img/logo_white_app.png',
                      width: 300,
                    ),
                    const SizedBox(height: 16),
                    _buildTagline(),
                    const SizedBox(height: 64),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildVersionInfo(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildQuemSomosButton(),
                          ),
                          _buildPrivacyText(),
                        ],
                      ),
                    ),
                    const Spacer(),
                    _buildFooter(),
                    const SizedBox(height: 16),
                  ],
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
          Expanded(
            child: Center(
              child: Text(
                'Sobre nós',
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTagline() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        'Cuidar do seu carro nunca foi tão fácil!',
        textAlign: TextAlign.center,
        style: textTheme.bodyLarge?.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Text(
      'Auto Care+ - 1.0.0',
      style: textTheme.bodyLarge?.copyWith(
        color: Colors.white,
      ),
    );
  }

  Widget _buildQuemSomosButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: ElevatedButton.icon(
        onPressed: () {
          DialogInfo.show(context, 'Quem é a AutoCare+?','A AutoCare+ é um aplicativo criado para ajudar você a cuidar melhor do seu veículo. Com ele, é possível registrar e acompanhar manutenções, controlar os gastos com abastecimentos e serviços, criar lembretes para revisões e manter todo o histórico do seu carro em um só lugar.O AutoCare+ foi pensado para trazer mais organização, praticidade e segurança para o seu dia a dia!');
        },
        icon: const Icon(
          Icons.info_outline_rounded,
          color: Colors.white,
        ),
        label: Text(
          'Quem somos',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        'Política de privacidade e termos de uso',
        textAlign: TextAlign.center,
        style: textTheme.bodyLarge?.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '© 2025 AutoCare+. Todos os direitos reservados.',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
