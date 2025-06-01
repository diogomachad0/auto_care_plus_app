import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldCustom extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final bool onlyNumbers;
  final bool toUpperCase;
  final String? Function(String value)? validator;
  final Icon? icon;

  const TextFieldCustom({
    super.key,
    required this.label,
    this.onTap,
    this.controller,
    this.onChanged,
    this.initialValue,
    this.onlyNumbers = false,
    this.toUpperCase = false,
    this.validator,
    this.icon,
  });

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> with ThemeMixin {
  late final TextEditingController _internalController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();

    if (widget.initialValue != null && widget.controller == null) {
      _internalController.text = widget.initialValue!;
    }
  }

  void _handleChange(String value) {
    if (widget.validator != null) {
      final validationResult = widget.validator!(value);
      setState(() => _errorText = validationResult);
    }

    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter> formatters = [];

    if (widget.onlyNumbers) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    }

    if (widget.toUpperCase) {
      formatters.add(UpperCaseTextFormatter());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _internalController,
          readOnly: widget.onTap != null,
          onTap: widget.onTap,
          onChanged: _handleChange,
          keyboardType: widget.onlyNumbers ? TextInputType.number : TextInputType.text,
          inputFormatters: formatters.isNotEmpty ? formatters : null,
          textCapitalization: widget.toUpperCase ? TextCapitalization.characters : TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: textTheme.bodyMedium?.copyWith(
              color: _errorText != null ? Colors.red : Colors.grey.shade500,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: textTheme.bodyMedium?.copyWith(
              color: _errorText != null ? Colors.red : colorScheme.primary,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.all(8),
            prefixIcon: widget.icon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 8, right: 4),
                    child: widget.icon,
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary, width: 1),
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 16,
          child: _errorText != null
              ? Text(
                  _errorText!,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 9,
                    color: colorScheme.error,
                  ),
                )
              : null,
        ),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
