import 'package:auto_care_plus_app/app/modules/contato/contato_controller.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:auto_care_plus_app/app/shared/widgets/dialog_custom/dialog_error.dart';
import 'package:auto_care_plus_app/app/shared/widgets/dialog_custom/dialog_sucess.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ContatoScreen extends StatefulWidget {
  const ContatoScreen({super.key});

  @override
  State<ContatoScreen> createState() => _ContatoScreenState();
}

class _ContatoScreenState extends State<ContatoScreen> with ThemeMixin {
  late final ContatoController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<ContatoController>();

    _controller.emailController.addListener(_updateFormValidation);
    _controller.assuntoController.addListener(_updateFormValidation);
    _controller.observacoesController.addListener(_updateFormValidation);
  }

  @override
  void dispose() {
    _controller.emailController.removeListener(_updateFormValidation);
    _controller.assuntoController.removeListener(_updateFormValidation);
    _controller.observacoesController.removeListener(_updateFormValidation);
    _controller.dispose();
    super.dispose();
  }

  void _updateFormValidation() {
    setState(() {});
  }

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
                child: _buildForm(),
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
                'Contato',
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

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/banners/pana.png',
            height: 200,
          ),
          const SizedBox(height: 8),
          Text(
            'Se você tiver alguma dúvida, sugestão ou problema com o aplicativo, entre em contato conosco preenchendo o formulário abaixo.',
            textAlign: TextAlign.start,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'A nossa equipe entrará em contato com você em até 72 horas! :)',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w200,
            ),
          ),
          const SizedBox(height: 16),
          TextFieldCustom(
            label: 'E-mail',
            controller: _controller.emailController,
            validator: _validateEmail,
          ),
          TextFieldCustom(
            label: 'Assunto do contato',
            controller: _controller.assuntoController,
          ),
          _buildObservationsField(),
          const SizedBox(height: 16),
          Observer(
            builder: (_) {
              final isFormValid = _isFormValid();

              return FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 46),
                  backgroundColor: isFormValid ? colorScheme.primary : Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: (!isFormValid || _controller.isLoading)
                    ? null
                    : () async {
                        final success = await _controller.enviarContato();

                        if (mounted) {
                          if (_controller.hasSuccess) {
                            await DialogSucess.show(context, _controller.successMessage);
                            _controller.clearSuccess();
                          } else if (_controller.hasError) {
                            await DialogError.show(context, _controller.errorMessage, StackTrace.current);
                            _controller.clearError();
                          }
                        }
                      },
                child: _controller.isLoading
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
                        'Enviar',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onPrimary,
                        ),
                      ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildObservationsField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _controller.observacoesController,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: 'Observações',
          labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  bool _isFormValid() {
    final email = _controller.emailController.text.trim();
    final assunto = _controller.assuntoController.text.trim();
    final observacoes = _controller.observacoesController.text.trim();

    if (email.isEmpty || assunto.isEmpty || observacoes.isEmpty) {
      return false;
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return false;
    }

    return true;
  }
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
