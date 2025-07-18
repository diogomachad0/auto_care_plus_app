import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:flutter/material.dart';

class PasswordTextFieldCustom extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const PasswordTextFieldCustom({
    super.key,
    required this.label,
    this.controller,
    this.validator,
  });

  @override
  State<PasswordTextFieldCustom> createState() => _PasswordTextFieldCustomState();
}

class _PasswordTextFieldCustomState extends State<PasswordTextFieldCustom> with ThemeMixin {
  bool _senhaVisivel = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !_senhaVisivel,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _senhaVisivel ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _senhaVisivel = !_senhaVisivel;
            });
          },
        ),
      ),
    );
  }
}