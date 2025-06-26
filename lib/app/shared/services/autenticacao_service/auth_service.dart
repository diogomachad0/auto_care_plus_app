import 'package:auto_care_plus_app/app/modules/usuario/usuario_controller.dart';
import 'package:auto_care_plus_app/app/shared/database/local/database_local.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sqflite/sqflite.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DatabaseLocal _databaseLocal = DatabaseLocal();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailControllerRegister = TextEditingController();
  final passwordControllerRegister = TextEditingController();
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> isErrorCredential = ValueNotifier(false);
  final ValueNotifier<bool> isErrorGeneric = ValueNotifier(false);
  final ValueNotifier<String> errorMessage = ValueNotifier('');
  final ValueNotifier<bool> isGoogleLoading = ValueNotifier(false);

  User? user;

  _resetControllers() {
    passwordControllerRegister.clear();
    emailControllerRegister.clear();
    passwordController.clear();
    emailController.clear();
    nomeController.clear();
    telefoneController.clear();
    confirmarSenhaController.clear();
  }

  _setErrorGeneric(bool error, [String message = '']) {
    isLoading.value = false;
    isGoogleLoading.value = false;
    isErrorGeneric.value = error;
    errorMessage.value = message;
  }

  _setErrorCredential(bool error, [String message = '']) {
    isLoading.value = false;
    isGoogleLoading.value = false;
    isErrorCredential.value = error;
    errorMessage.value = message;
  }

  _setLoading(bool loading) {
    isLoading.value = loading;
  }

  _setGoogleLoading(bool loading) {
    isGoogleLoading.value = loading;
  }

  _cleanStates() {
    _setLoading(false);
    _setGoogleLoading(false);
    _setErrorCredential(false);
    _setErrorGeneric(false);
    errorMessage.value = '';
  }

  void clearError() {
    isErrorGeneric.value = false;
    errorMessage.value = '';
  }

  String? validateEmail(String email) {
    if (email.isEmpty) return 'E-mail é obrigatório';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'E-mail inválido';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) return 'Senha é obrigatória';
    return null;
  }

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) return 'Confirmação de senha é obrigatória';
    if (password != confirmPassword) return 'Senhas não coincidem';
    return null;
  }

  Future<void> login() async {
    _cleanStates();

    final emailError = validateEmail(emailController.text);
    final passwordError = validatePassword(passwordController.text);

    if (emailError != null || passwordError != null) {
      _setErrorGeneric(true, emailError ?? passwordError!);
      return;
    }

    _setLoading(true);

    try {
      UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      user = credential.user;

      // Após login bem-sucedido, inicializa o banco do usuário
      await _initializeUserDatabase();

      _resetControllers();
      Modular.to.navigate('$bottomBarRoute/$homeRoute');
    } on FirebaseAuthException catch (e) {
      String message = 'Erro de autenticação';
      switch (e.code) {
        case 'user-not-found':
          message = 'Usuário não encontrado';
          break;
        case 'wrong-password':
          message = 'Senha incorreta';
          break;
        case 'invalid-email':
          message = 'E-mail inválido';
          break;
        case 'user-disabled':
          message = 'Usuário desabilitado';
          break;
        case 'too-many-requests':
          message = 'Muitas tentativas. Tente novamente mais tarde';
          break;
        case 'invalid-credential':
          message = 'Usuário ou senha inválidos!\nPor favor, verifique suas credenciais e tente novamente.';
          break;
      }
      _setErrorCredential(true, message);
    } on Exception catch (e) {
      _setErrorGeneric(true, 'Erro inesperado. Tente novamente');
    }
  }

  Future<void> signInWithGoogle() async {
    _cleanStates();
    _setGoogleLoading(true);

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        _setGoogleLoading(false);
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      user = userCredential.user;

      print('Google Sign-In successful: ${user?.displayName} (${user?.email})');

      // Após login bem-sucedido, inicializa o banco do usuário
      await _initializeUserDatabase();

      // Salva os dados do Google no banco local
      await _saveGoogleUserData();

      _resetControllers();
      Modular.to.navigate('$bottomBarRoute/$homeRoute');
    } on FirebaseAuthException catch (e) {
      String message = 'Erro ao fazer login com Google';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          message = 'Conta já existe com credenciais diferentes';
          break;
        case 'invalid-credential':
          message = 'Credenciais do Google inválidas';
          break;
        case 'operation-not-allowed':
          message = 'Login com Google não está habilitado';
          break;
        case 'user-disabled':
          message = 'Usuário desabilitado';
          break;
        case 'user-not-found':
          message = 'Usuário não encontrado';
          break;
        case 'wrong-password':
          message = 'Senha incorreta';
          break;
      }
      _setErrorGeneric(true, message);
    } catch (e) {
      print('Google Sign-In error: $e');
      _setErrorGeneric(true, 'Erro inesperado ao fazer login com Google');
    }
  }

  Future<void> register() async {
    _cleanStates();

    final emailError = validateEmail(emailControllerRegister.text);
    final passwordError = validatePassword(passwordControllerRegister.text);
    final confirmPasswordError = validateConfirmPassword(passwordControllerRegister.text, confirmarSenhaController.text);

    if (emailError != null || passwordError != null || confirmPasswordError != null) {
      _setErrorGeneric(true, emailError ?? passwordError ?? confirmPasswordError!);
      return;
    }

    if (nomeController.text.trim().isEmpty) {
      _setErrorGeneric(true, 'Nome é obrigatório');
      return;
    }

    _setLoading(true);

    try {
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailControllerRegister.text.trim(),
        password: passwordControllerRegister.text,
      );

      await credential.user?.updateDisplayName(nomeController.text.trim());
      user = credential.user;

      // Após registro bem-sucedido, inicializa o banco do usuário
      await _initializeUserDatabase();

      // AQUI É A PARTE NOVA - Salva os dados na tabela usuario
      await _saveUserDataToLocal();

      _resetControllers();
      Modular.to.navigate('/');
    } on FirebaseAuthException catch (e) {
      String message = 'Erro ao criar conta';
      switch (e.code) {
        case 'weak-password':
          message = 'Senha muito fraca';
          break;
        case 'email-already-in-use':
          message = 'E-mail já está em uso';
          break;
        case 'invalid-email':
          message = 'E-mail inválido';
          break;
      }
      _setErrorGeneric(true, message);
    } on Exception catch (e) {
      _setErrorGeneric(true, 'Erro inesperado. Tente novamente');
    }
  }

  /// NOVO MÉTODO - Salva os dados do usuário na tabela local
  Future<void> _saveUserDataToLocal() async {
    try {
      final usuarioController = Modular.get<UsuarioController>();

      await usuarioController.saveUserFromRegistration(
        nomeController.text.trim(),
        emailControllerRegister.text.trim(),
        telefoneController.text.replaceAll(RegExp(r'[^\d]'), ''), // Remove formatação
        passwordControllerRegister.text,
      );

      print('Dados do usuário salvos na tabela local');
    } catch (e) {
      print('Erro ao salvar dados do usuário na tabela local: $e');
      // Não vamos falhar o registro por causa disso
    }
  }

  /// NOVO MÉTODO - Salva os dados do Google na tabela local
  Future<void> _saveGoogleUserData() async {
    try {
      if (user != null) {
        final usuarioController = Modular.get<UsuarioController>();

        // Verifica se já existe um usuário salvo
        await usuarioController.loadCurrentUser();

        // Se não existe, salva os dados do Google
        if (usuarioController.usuario.nome.isEmpty) {
          await usuarioController.saveUserFromRegistration(
            user!.displayName ?? 'Usuário Google',
            user!.email ?? '',
            '', // Google não fornece telefone
            'google_auth', // Senha placeholder para login com Google
          );
        }

        print('Dados do Google salvos na tabela local');
      }
    } catch (e) {
      print('Erro ao salvar dados do Google na tabela local: $e');
    }
  }

  Future<void> logout() async {
    _cleanStates();

    try {
      // Fecha o banco de dados antes do logout
      await _databaseLocal.closeDatabase();

      // Sign out from Google
      await _googleSignIn.signOut();
      // Sign out from Firebase
      await _firebaseAuth.signOut();
      user = null;
      _resetControllers();
      Modular.to.navigate('/');
    } on Exception catch (e) {
      _setErrorGeneric(true, 'Erro ao fazer logout');
    }
  }

  /// Inicializa o banco de dados do usuário após login/registro
  Future<void> _initializeUserDatabase() async {
    try {
      final databaseLocal = DatabaseLocal();

      // Se estávamos usando banco temporário, migra os dados
      if (databaseLocal.isUsingTemporaryDatabase()) {
        await databaseLocal.migrateFromTemporaryDatabase();
      } else {
        // Apenas força a abertura do banco do usuário
        await databaseLocal.getDb();
      }

      print('Banco de dados do usuário inicializado: ${user?.uid}');
    } catch (e) {
      print('Erro ao inicializar banco do usuário: $e');
    }
  }

  /// Obtém a instância do banco de dados do usuário atual
  Future<Database> getUserDatabase() async {
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }
    return await _databaseLocal.getDb();
  }

  Future<void> resetPassword(String email) async {
    _cleanStates();

    final emailError = validateEmail(email);
    if (emailError != null) {
      _setErrorGeneric(true, emailError);
      return;
    }

    _setLoading(true);

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      _setLoading(false);
    } on FirebaseAuthException catch (e) {
      String message = 'Erro ao enviar e-mail';
      switch (e.code) {
        case 'user-not-found':
          message = 'Usuário não encontrado';
          break;
        case 'invalid-email':
          message = 'E-mail inválido';
          break;
      }
      _setErrorGeneric(true, message);
    } on Exception catch (e) {
      _setErrorGeneric(true, 'Erro inesperado. Tente novamente');
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailControllerRegister.dispose();
    passwordControllerRegister.dispose();
    nomeController.dispose();
    telefoneController.dispose();
    confirmarSenhaController.dispose();
    isLoading.dispose();
    isErrorCredential.dispose();
    isErrorGeneric.dispose();
    errorMessage.dispose();
    isGoogleLoading.dispose();
  }
}
