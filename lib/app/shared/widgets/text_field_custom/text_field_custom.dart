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
  final TextInputType? keyboardType;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;

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
    this.keyboardType,
    this.enabled = true,
    this.inputFormatters,
  });

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> with ThemeMixin {
  late final TextEditingController _internalController;
  String? _errorText;
  bool _hasBeenTouched = false;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();

    if (widget.initialValue != null && widget.controller == null) {
      _internalController.text = widget.initialValue!;
    }

    _internalController.addListener(_validateField);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    } else {
      _internalController.removeListener(_validateField);
    }
    super.dispose();
  }

  void _validateField() {
    if (!_hasBeenTouched) return;

    if (widget.validator != null) {
      final validationResult = widget.validator!(_internalController.text);
      if (mounted) {
        setState(() => _errorText = validationResult);
      }
    }
  }

  void _handleChange(String value) {
    if (!_hasBeenTouched) {
      setState(() => _hasBeenTouched = true);
    }

    if (widget.validator != null) {
      final validationResult = widget.validator!(value);
      setState(() => _errorText = validationResult);
    }

    widget.onChanged?.call(value);
  }

  void _handleFocusLost() {
    setState(() => _hasBeenTouched = true);
    _validateField();
  }

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter> formatters = [];

    if (widget.inputFormatters != null) {
      formatters.addAll(widget.inputFormatters!);
    }

    if (widget.onlyNumbers) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    }

    if (widget.toUpperCase) {
      formatters.add(UpperCaseTextFormatter());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) _handleFocusLost();
          },
          child: TextField(
            controller: _internalController,
            enabled: widget.enabled,
            readOnly: widget.onTap != null,
            onTap: widget.onTap,
            onChanged: _handleChange,
            keyboardType: widget.keyboardType ?? (widget.onlyNumbers ? TextInputType.number : TextInputType.text),
            inputFormatters: formatters.isNotEmpty ? formatters : null,
            textCapitalization: widget.toUpperCase ? TextCapitalization.characters : TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: textTheme.bodyMedium?.copyWith(
                color: _errorText != null ? colorScheme.error : Colors.grey.shade500,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              floatingLabelStyle: textTheme.bodyMedium?.copyWith(
                color: _errorText != null ? colorScheme.error : colorScheme.primary,
              ),
              filled: true,
              fillColor: widget.enabled ? Colors.grey[200] : Colors.grey[100],
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
                borderSide: BorderSide(color: _errorText != null ? colorScheme.error : colorScheme.primary, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.error, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.error, width: 1),
              ),
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
