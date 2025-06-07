import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/services/autenticacao_service/auth_service.dart';
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
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
  }

  @override
  void dispose() {
    _authService.dispose();
    super.dispose();
  }

  Widget _buildErrorWidget() {
    return ValueListenableBuilder<bool>(
      valueListenable: _authService.isErrorGeneric,
      builder: (context, hasError, child) {
        return ValueListenableBuilder<String>(
          valueListenable: _authService.errorMessage,
          builder: (context, errorMessage, child) {
            if (hasError) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMessage.isNotEmpty ? errorMessage : 'Erro ao criar conta',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.red.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildRegisterButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _authService.isLoading,
      builder: (context, isLoading, child) {
        return FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 46),
            backgroundColor: _aceitoTermos ? colorScheme.primary : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: (isLoading || !_aceitoTermos)
              ? null
              : () {
                  if (_aceitoTermos) {
                    _authService.register();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Você deve aceitar os termos de uso'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Criando conta...',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ],
                )
              : Text(
                  'Criar conta',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onPrimary,
                  ),
                ),
        );
      },
    );
  }

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
                                const SizedBox(height: 28),
                                _buildErrorWidget(),
                                TextFieldCustom(
                                  label: 'Nome completo',
                                  controller: _authService.nomeController,
                                  validator: (value) {
                                    if (value.isEmpty) return 'Nome é obrigatório';
                                    return null;
                                  },
                                ),
                                TextFieldCustom(
                                  label: 'E-mail',
                                  controller: _authService.emailControllerRegister,
                                  validator: _authService.validateEmail,
                                ),
                                TextFieldCustom(
                                  label: 'Telefone',
                                  controller: _authService.telefoneController,
                                  onlyNumbers: true,
                                ),
                                PasswordTextFieldCustom(
                                  label: 'Senha',
                                  controller: _authService.passwordControllerRegister,
                                ),
                                const SizedBox(height: 16),
                                PasswordTextFieldCustom(
                                  label: 'Confirmar senha',
                                  controller: _authService.confirmarSenhaController,
                                ),
                                const SizedBox(height: 16),
                                _buildRegisterButton(),
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
                                    Text('Eu aceito os ', style: textTheme.bodySmall),
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
