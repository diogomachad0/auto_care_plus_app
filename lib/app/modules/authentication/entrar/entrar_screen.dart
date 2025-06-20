import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:auto_care_plus_app/app/shared/services/autenticacao_service/auth_service.dart';
import 'package:auto_care_plus_app/app/shared/widgets/dialog_custom/dialog_error.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/password_text_field_custom.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EntrarScreen extends StatefulWidget {
  const EntrarScreen({super.key});

  @override
  State<EntrarScreen> createState() => _EntrarScreenState();
}

class _EntrarScreenState extends State<EntrarScreen> with ThemeMixin {
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();

    _authService.emailController.addListener(_updateButtonState);
    _authService.passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _authService.emailController.removeListener(_updateButtonState);
    _authService.passwordController.removeListener(_updateButtonState);
    _authService.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {});
  }

  bool _isFormValid() {
    return _authService.emailController.text.trim().isNotEmpty && _authService.passwordController.text.trim().isNotEmpty;
  }

  Widget _buildErrorWidget() {
    return ValueListenableBuilder<bool>(
      valueListenable: _authService.isErrorCredential,
      builder: (context, hasCredentialError, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: _authService.isErrorGeneric,
          builder: (context, hasGenericError, child) {
            return ValueListenableBuilder<String>(
              valueListenable: _authService.errorMessage,
              builder: (context, errorMessage, child) {
                if ((hasCredentialError || hasGenericError) && errorMessage.isNotEmpty) {
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
      },
    );
  }

  Widget _buildLoginButton() {
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
          onPressed: (isLoading || !isFormValid) ? null : () => _authService.login(),
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
                      'Entrando...',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ],
                )
              : Text(
                  'Entrar',
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
          'Acessar conta',
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
                                const SizedBox(height: 28),
                                _buildErrorWidget(),
                                TextFieldCustom(
                                  label: 'E-mail',
                                  controller: _authService.emailController,
                                  validator: _authService.validateEmail,
                                  inputFormatters: [
                                    TextInputFormatter.withFunction((oldValue, newValue) {
                                      return newValue.copyWith(
                                        text: newValue.text.toLowerCase(),
                                      );
                                    }),
                                  ],
                                ),
                                PasswordTextFieldCustom(
                                  label: 'Senha',
                                  controller: _authService.passwordController,
                                ),
                                const SizedBox(height: 16),
                                _buildLoginButton(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey.shade300,
                                          thickness: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          'ou',
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey.shade300,
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Modular.to.pushNamed('$recuperarSenhaRoute/');
                                  },
                                  child: Text(
                                    'Esqueci minha senha',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.secondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
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
