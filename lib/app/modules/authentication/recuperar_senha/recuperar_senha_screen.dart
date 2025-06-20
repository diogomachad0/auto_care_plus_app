import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/services/autenticacao_service/auth_service.dart';
import 'package:auto_care_plus_app/app/shared/widgets/dialog_custom/dialog_error.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RecuperarSenhaScreen extends StatefulWidget {
  const RecuperarSenhaScreen({super.key});

  @override
  State<RecuperarSenhaScreen> createState() => _RecuperarSenhaScreenState();
}

class _RecuperarSenhaScreenState extends State<RecuperarSenhaScreen> with ThemeMixin {
  final TextEditingController _emailController = TextEditingController();
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();

    _emailController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateButtonState);
    _emailController.dispose();
    _authService.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {});
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

  bool _isFormValid() {
    return _validateEmail(_emailController.text) == null;
  }

  Widget _buildErrorWidget() {
    return ValueListenableBuilder<bool>(
      valueListenable: _authService.isErrorGeneric,
      builder: (context, hasError, child) {
        return ValueListenableBuilder<String>(
          valueListenable: _authService.errorMessage,
          builder: (context, errorMessage, child) {
            if (hasError && errorMessage.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                DialogError.show(context, errorMessage, StackTrace.current);
                _authService.clearError();
              });
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  void _sendResetEmail() async {
    await _authService.resetPassword(_emailController.text.trim());

    if (!_authService.isErrorGeneric.value) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('E-mail de recuperação enviado com sucesso!'),
            backgroundColor: colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Modular.to.pop();
          }
        });
      }
    }
  }

  Widget _buildConfirmButton() {
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
          onPressed: (isLoading || !isFormValid) ? null : _sendResetEmail,
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
                      'Enviando...',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ],
                )
              : Text(
                  'Confirmar',
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
            Modular.to.pop();
          },
        ),
        title: Text(
          'Recuperar senha',
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
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/img/logo_black_app.png',
                                  width: 200,
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    'Por favor, informe o seu e-mail abaixo para que possamos enviar o código de recuperação para você.',
                                    textAlign: TextAlign.center,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildErrorWidget(),
                                TextFieldCustom(
                                  label: 'E-mail',
                                  controller: _emailController,
                                  validator: _validateEmail,
                                  onChanged: (value) {
                                    final formatted = value.toLowerCase();
                                    if (formatted != value) {
                                      _emailController.value = TextEditingValue(
                                        text: formatted,
                                        selection: TextSelection.collapsed(offset: formatted.length),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 8),
                                _buildConfirmButton(),
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
