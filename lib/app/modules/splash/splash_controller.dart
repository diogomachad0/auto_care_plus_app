import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:auto_care_plus_app/app/shared/services/autenticacao_service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'splash_controller.g.dart';

class SplashController = _SplashControllerBase with _$SplashController;

abstract class _SplashControllerBase with Store {
  final AuthService _authService = AuthService();

  @observable
  double _opacity = 0.0;

  @observable
  bool _isLoading = true;

  double get opacity => _opacity;

  bool get isLoading => _isLoading;

  Future<void> load(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 300));

    fadeInLogo();

    await Future.delayed(const Duration(milliseconds: 2000));

    await _checkAuthenticationState();
  }

  @action
  void fadeInLogo() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _opacity = 1.0;
    });
  }

  @action
  Future<void> _checkAuthenticationState() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        _authService.user = currentUser;

        await _authService.getUserDatabase();

        _setLoading(false);
        Modular.to.navigate('/$bottomBarRoute/$homeRoute/');
      } else {
        _setLoading(false);
        Modular.to.navigate('/$loginRoute');
      }
    } catch (e) {
      print('Erro ao verificar autenticação: $e');
      _setLoading(false);
      Modular.to.navigate('/$loginRoute/$entrarRoute');
    }
  }

  @action
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void dispose() {
    _authService.dispose();
  }
}
