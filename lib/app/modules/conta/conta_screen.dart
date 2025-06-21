import 'package:auto_care_plus_app/app/modules/conta/conta_controller.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:auto_care_plus_app/app/shared/widgets/bottom_sheet_custom/bottom_sheet_custom.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/password_text_field_custom.dart';
import 'package:auto_care_plus_app/app/shared/widgets/text_field_custom/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ContaScreen extends StatefulWidget {
  const ContaScreen({super.key});

  @override
  State<ContaScreen> createState() => _ContaScreenState();
}

class _ContaScreenState extends State<ContaScreen> with ThemeMixin {
  late final ContaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<ContaController>();

    _controller.loadUserData();

    _controller.telefoneController.addListener(_formatTelefone);
    _controller.nomeController.addListener(_formatNome);
  }

  @override
  void dispose() {
    _controller.telefoneController.removeListener(_formatTelefone);
    _controller.nomeController.removeListener(_formatNome);
    _controller.dispose();
    super.dispose();
  }

  void _formatTelefone() {
    final text = _controller.telefoneController.text;
    final formatted = _controller.formatPhone(text);

    if (formatted != text) {
      _controller.telefoneController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _formatNome() {
    final text = _controller.nomeController.text;
    final formatted = _controller.formatName(text);

    if (formatted != text) {
      _controller.nomeController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
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
              Expanded(
                child: Observer(
                  builder: (_) {
                    if (_controller.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/img/banners/conta.png',
                              height: 200,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Gerencie as informações da sua conta!',
                              style: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildForm(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
                'Minha conta',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            'DADOS PESSOAIS',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextFieldCustom(
          label: 'Nome',
          controller: _controller.nomeController,
        ),
        TextFieldCustom(
          label: 'E-mail',
          controller: _controller.emailController,
        ),
        TextFieldCustom(
          label: 'Telefone',
          controller: _controller.telefoneController,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
        ),
        Observer(
          builder: (_) {
            if (_controller.emailWasChanged) {
              return Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Para alterar o email, você precisa informar sua senha atual abaixo.',
                        style: textTheme.bodySmall?.copyWith(color: Colors.orange.shade700),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            'ALTERAR SENHA',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        PasswordTextFieldCustom(
          label: 'Senha atual',
          controller: _controller.senhaAtualController,
        ),
        const SizedBox(height: 16),
        PasswordTextFieldCustom(
          label: 'Nova senha',
          controller: _controller.novaSenhaController,
        ),
        const SizedBox(height: 16),
        PasswordTextFieldCustom(
          label: 'Confirme a nova senha',
          controller: _controller.confirmarSenhaController,
        ),
        const SizedBox(height: 16),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Observer(
          builder: (_) {
            return FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 46),
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _controller.isLoading
                  ? null
                  : () async {
                      bool profileSuccess = true;
                      if (_controller.isProfileFormValid) {
                        profileSuccess = await _controller.updateProfile();
                      }

                      bool passwordSuccess = true;
                      if (_controller.isPasswordFormValid) {
                        passwordSuccess = await _controller.updatePassword();
                      }

                      if (mounted) {
                        if (profileSuccess && passwordSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Dados salvos com sucesso!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_controller.errorMessage.isNotEmpty ? _controller.errorMessage : 'Erro ao salvar dados'),
                              backgroundColor: Colors.red,
                            ),
                          );
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
                          'Salvando...',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Salvar',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onPrimary,
                      ),
                    ),
            );
          },
        ),
        const SizedBox(height: 16),
        FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 46),
            backgroundColor: colorScheme.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            ConfirmarBottomSheet.show(
              context: context,
              titulo: 'Excluir conta',
              mensagem: 'Deseja mesmo excluir sua conta? Isso apagará todos os seus dados de forma permanente.',
              textoConfirmar: 'Excluir conta',
              onConfirmar: () async {
                final success = await _controller.deleteAccount();
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Conta excluída com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Modular.to.navigate('/');
                }
              },
            );
          },
          child: Text(
            'Excluir minha conta',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
