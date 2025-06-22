import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';

part 'contato_controller.g.dart';

class ContatoController = _ContatoControllerBase with _$ContatoController;

abstract class _ContatoControllerBase with Store {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController assuntoController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();

  @observable
  bool isLoading = false;

  @observable
  String errorMessage = '';

  @observable
  String successMessage = '';

  @action
  Future<bool> enviarContato() async {
    try {
      isLoading = true;
      errorMessage = '';
      successMessage = '';

      if (emailController.text.trim().isEmpty) {
        errorMessage = 'E-mail é obrigatório';
        return false;
      }

      if (!_isValidEmail(emailController.text.trim())) {
        errorMessage = 'Digite um e-mail válido';
        return false;
      }

      if (assuntoController.text.trim().isEmpty) {
        errorMessage = 'Assunto é obrigatório';
        return false;
      }

      if (observacoesController.text.trim().isEmpty) {
        errorMessage = 'Observações são obrigatórias';
        return false;
      }

      print('=== ENVIANDO EMAIL VIA FORMSPREE ===');
      print('Email: ${emailController.text.trim()}');
      print('Assunto: ${assuntoController.text.trim()}');
      print('Observações: ${observacoesController.text.trim()}');

      final success = await _enviarViaFormspree();

      if (success) {
        successMessage = 'Mensagem enviada com sucesso! Nossa equipe entrará em contato em até 72 horas.';

        emailController.clear();
        assuntoController.clear();
        observacoesController.clear();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      errorMessage = 'Erro ao enviar mensagem: ${e.toString()}';
      print('❌ Erro ao enviar contato: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> _enviarViaFormspree() async {
    try {
      const formspreeUrl = 'https://formspree.io/f/mgvynoyk';

      print('🔧 Enviando para Formspree: $formspreeUrl');

      final formData = {
        'email': emailController.text.trim(),
        'subject': '[AutoCare+] ${assuntoController.text.trim()}',
        'message': '''
📱 CONTATO VIA APP AUTOCARE+

👤 Email do usuário: ${emailController.text.trim()}
📋 Assunto: ${assuntoController.text.trim()}

💬 Mensagem:
${observacoesController.text.trim()}

---
📅 Enviado em: ${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year} às ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}
🔗 Origem: App AutoCare+
        ''',
        '_replyto': emailController.text.trim(),
        '_subject': '[AutoCare+] ${assuntoController.text.trim()}',
        'name': 'AutoCare+ App',
      };

      print('📤 Dados enviados: ${json.encode(formData)}');

      final response = await http.post(
        Uri.parse(formspreeUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(formData),
      );

      print('📥 Formspree Response status: ${response.statusCode}');
      print('📥 Formspree Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Email enviado com sucesso via Formspree!');
        return true;
      } else if (response.statusCode == 422) {
        try {
          final responseData = json.decode(response.body);
          if (responseData['errors'] != null) {
            final errors = responseData['errors'] as List;
            errorMessage = 'Erro de validação: ${errors.join(', ')}';
          } else {
            errorMessage = 'Dados do formulário inválidos.';
          }
        } catch (e) {
          errorMessage = 'Erro de validação nos dados enviados.';
        }
        return false;
      } else {
        errorMessage = 'Erro no servidor. Tente novamente em alguns minutos.';
        return false;
      }
    } catch (e) {
      print('❌ Erro na requisição Formspree: $e');

      if (e.toString().contains('SocketException') || e.toString().contains('TimeoutException')) {
        errorMessage = 'Erro de conexão. Verifique sua internet e tente novamente.';
      } else {
        errorMessage = 'Erro inesperado. Tente novamente.';
      }
      return false;
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  @action
  void clearError() {
    errorMessage = '';
  }

  @action
  void clearSuccess() {
    successMessage = '';
  }

  @computed
  bool get hasError => errorMessage.isNotEmpty;

  @computed
  bool get hasSuccess => successMessage.isNotEmpty;

  @computed
  bool get isFormValid {
    return emailController.text.trim().isNotEmpty && assuntoController.text.trim().isNotEmpty && observacoesController.text.trim().isNotEmpty && _isValidEmail(emailController.text.trim());
  }

  void dispose() {
    emailController.dispose();
    assuntoController.dispose();
    observacoesController.dispose();
  }
}
