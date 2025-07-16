import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/services/autenticacao_service/auth_service.dart';
import 'package:auto_care_plus_app/app/shared/widgets/dialog_custom/dialog_error.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/password_text_field_custom.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';

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
    _authService.nomeController.addListener(_updateButtonState);
    _authService.emailControllerRegister.addListener(_updateButtonState);
    _authService.telefoneController.addListener(_updateButtonState);
    _authService.passwordControllerRegister.addListener(_updateButtonState);
    _authService.confirmarSenhaController.addListener(_updateButtonState);
    _authService.isErrorGeneric.addListener(_handleError);
  }

  @override
  void dispose() {
    _authService.nomeController.removeListener(_updateButtonState);
    _authService.emailControllerRegister.removeListener(_updateButtonState);
    _authService.telefoneController.removeListener(_updateButtonState);
    _authService.passwordControllerRegister.removeListener(_updateButtonState);
    _authService.confirmarSenhaController.removeListener(_updateButtonState);
    _authService.isErrorGeneric.removeListener(_handleError);
    _authService.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {});
  }

  void _handleError() {
    if (_authService.isErrorGeneric.value) {
      final errorMessage = _authService.errorMessage.value.isNotEmpty ? _authService.errorMessage.value : 'Erro desconhecido';
      DialogError.show(context, errorMessage, StackTrace.current);
      _authService.clearError();
    }
  }

  String? _validateNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }
    final names = value.trim().split(' ');
    if (names.length < 2) {
      return 'Digite nome e sobrenome';
    }
    for (String name in names) {
      if (name.isEmpty) continue;
      if (name[0] != name[0].toUpperCase()) {
        return 'Cada nome deve começar com letra maiúscula';
      }
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-mail é obrigatório';
    }
    if (value[0] != value[0].toLowerCase()) {
      return 'E-mail não deve começar com letra maiúscula';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Digite um e-mail válido';
    }
    return null;
  }

  String? _validateTelefone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Telefone é obrigatório';
    }
    final numbersOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    if (numbersOnly.length != 11) {
      return 'Telefone deve ter 11 dígitos';
    }
    final areaCode = int.tryParse(numbersOnly.substring(0, 2));
    if (areaCode == null || areaCode < 11 || areaCode > 99) {
      return 'Código de área inválido';
    }
    if (numbersOnly[2] != '9') {
      return 'Número deve ser de celular (9º dígito deve ser 9)';
    }
    return null;
  }

  String? _validateSenha(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Senha é obrigatória';
    }
    if (value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  String? _validateConfirmarSenha(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    if (value != _authService.passwordControllerRegister.text) {
      return 'Senhas não coincidem';
    }
    return null;
  }

  String _formatPhone(String value) {
    final numbersOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    if (numbersOnly.length <= 2) {
      return numbersOnly;
    } else if (numbersOnly.length <= 7) {
      return '(${numbersOnly.substring(0, 2)}) ${numbersOnly.substring(2)}';
    } else if (numbersOnly.length <= 11) {
      return '(${numbersOnly.substring(0, 2)}) ${numbersOnly.substring(2, 7)}-${numbersOnly.substring(7)}';
    } else {
      return '(${numbersOnly.substring(0, 2)}) ${numbersOnly.substring(2, 7)}-${numbersOnly.substring(7, 11)}';
    }
  }

  String _formatName(String value) {
    return value.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  bool _isFormValid() {
    return _validateNome(_authService.nomeController.text) == null && _validateEmail(_authService.emailControllerRegister.text) == null && _validateTelefone(_authService.telefoneController.text) == null && _validateSenha(_authService.passwordControllerRegister.text) == null && _validateConfirmarSenha(_authService.confirmarSenhaController.text) == null && _aceitoTermos;
  }

  Future<void> _abrirPoliticaPrivacidade() async {
    const urlString = 'https://www.freeprivacypolicy.com/live/d7baf1b2-4ff6-406a-a6d4-02fcaa24acb4';

    try {
      await launchUrl(
        Uri.parse(urlString),
        mode: LaunchMode.externalApplication,
      );
      return;
    } catch (e1) {
    }
  }

  Widget _buildRegisterButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _authService.isLoading,
      builder: (context, isLoading, child) {
        final isFormValid = _isFormValid();
        return FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 46),
            backgroundColor: isFormValid ? colorScheme.primary : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: (isLoading || !isFormValid)
              ? null
              : () {
            _authService.register();
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
                  color: colorScheme.primary,
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
              color: isFormValid ? colorScheme.onPrimary : Colors.grey.shade600,
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
                                TextFieldCustom(
                                  label: 'Nome completo',
                                  controller: _authService.nomeController,
                                  validator: _validateNome,
                                  onChanged: (value) {
                                    final formatted = _formatName(value);
                                    if (formatted != value) {
                                      _authService.nomeController.value = TextEditingValue(
                                        text: formatted,
                                        selection: TextSelection.collapsed(offset: formatted.length),
                                      );
                                    }
                                  },
                                ),
                                TextFieldCustom(
                                  label: 'E-mail',
                                  controller: _authService.emailControllerRegister,
                                  validator: _validateEmail,
                                ),
                                TextFieldCustom(
                                  label: 'Telefone',
                                  controller: _authService.telefoneController,
                                  validator: _validateTelefone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                  onChanged: (value) {
                                    final formatted = _formatPhone(value);
                                    if (formatted != value) {
                                      _authService.telefoneController.value = TextEditingValue(
                                        text: formatted,
                                        selection: TextSelection.collapsed(offset: formatted.length),
                                      );
                                    }
                                  },
                                ),
                                PasswordTextFieldCustom(
                                  label: 'Senha',
                                  controller: _authService.passwordControllerRegister,
                                  validator: _validateSenha,
                                ),
                                const SizedBox(height: 16),
                                PasswordTextFieldCustom(
                                  label: 'Confirmar senha',
                                  controller: _authService.confirmarSenhaController,
                                  validator: _validateConfirmarSenha,
                                ),
                                const SizedBox(height: 16),
                                _buildRegisterButton(),
                                TextButton(
                                  onPressed: _abrirPoliticaPrivacidade,
                                  child: Text(
                                    'Ler Termos de Uso e Política de Privacidade',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.secondary,
                                    ),
                                  ),
                                ),
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
