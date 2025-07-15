import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:auto_care_plus_app/app/shared/services/autenticacao_service/auth_service.dart';
import 'package:auto_care_plus_app/app/shared/widgets/dialog_custom/dialog_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ThemeMixin {
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _authService.errorMessage.addListener(_handleAuthError);
  }

  @override
  void dispose() {
    _authService.errorMessage.removeListener(_handleAuthError);
    _authService.dispose();
    super.dispose();
  }

  void _handleAuthError() {
    if (_authService.errorMessage.value.isNotEmpty) {
      DialogError.show(context, _authService.errorMessage.value, StackTrace.current);
    }
  }

  Widget _buildGoogleButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _authService.isGoogleLoading,
      builder: (context, isLoading, child) {
        return TextButton.icon(
          onPressed: isLoading ? null : () => _authService.signInWithGoogle(),
          icon: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  ),
                )
              : Image.asset(
                  'assets/img/google_icon.png',
                  width: 24,
                  height: 24,
                ),
          label: Text(
            isLoading ? 'Conectando...' : 'Continuar com o Google',
            style: textTheme.bodyMedium?.copyWith(
              color: isLoading ? Colors.grey : Colors.black,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/img/home.png',
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Image.asset(
                      'assets/img/logo_white_app.png',
                      width: 180,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Seu\nveículo,\nna palma\nda sua mão',
                      //todo: arrumar para usar o textTheme
                      style: textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 50,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(250, 46),
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Modular.to.navigate('$entrarRoute/');
                    },
                    child: Text(
                      'Entrar em minha conta',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Modular.to.navigate('$registrarRoute/');
                    },
                    child: Text(
                      'Criar conta',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
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
                  _buildGoogleButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
