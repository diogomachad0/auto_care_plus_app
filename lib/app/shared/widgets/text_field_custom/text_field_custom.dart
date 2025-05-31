import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:flutter/material.dart';

class TextFieldCustom extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const TextFieldCustom({
    super.key,
    required this.label,
    this.onTap,
    this.controller,
    this.onChanged,
  });

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> with ThemeMixin {
  late final TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _internalController,
      readOnly: widget.onTap != null,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
    );
  }
}
