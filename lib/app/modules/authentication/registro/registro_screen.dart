import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/password_text_field_custom.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> with ThemeMixin {
  bool _aceitoTermos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorScheme.onPrimary,
          ),
          onPressed: () {
            Modular.to.navigate('/');
          },
        ),
        title: Text(
          'Cadastro de usuário',
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary,
              colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    child: IntrinsicHeight(
                      child: Align(
                        alignment: Alignment.center,
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/img/logo_black_app.png',
                                  width: 200,
                                ),
                                const SizedBox(height: 32),
                                const TextFieldCustom(label: 'Nome completo'),
                                const SizedBox(height: 16),
                                const TextFieldCustom(label: 'E-mail'),
                                const SizedBox(height: 16),
                                const TextFieldCustom(label: 'Telefone'),
                                const SizedBox(height: 16),
                                const PasswordTextFieldCustom(label: 'Senha'),
                                const SizedBox(height: 16),
                                const PasswordTextFieldCustom(
                                    label: 'Confirmar senha'),
                                const SizedBox(height: 32),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 46),
                                    backgroundColor: colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Criar conta',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Ler ', style: textTheme.bodySmall),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text('Termos de Uso',
                                          style: textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Text(' e ', style: textTheme.bodySmall),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text('Política de Privacidade',
                                          style: textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Eu aceito os ',
                                        style: textTheme.bodySmall),
                                    Text('Termos',
                                        style: textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const SizedBox(width: 4),
                                    Switch(
                                      value: _aceitoTermos,
                                      onChanged: (value) {
                                        setState(() {
                                          _aceitoTermos = value;
                                        });
                                      },
                                      activeColor: colorScheme.onSecondary,
                                      activeTrackColor: colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
