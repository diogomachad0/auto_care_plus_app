import 'dart:ui';

import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DialogError extends StatefulWidget {
  final String message;

  const DialogError(this.message, {super.key});

  @override
  State<DialogError> createState() => _DialogErrorState();

  static Future<void> show(BuildContext context, String message, StackTrace s) async {
    debugPrintStack(label: message, stackTrace: s);

    await showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: DialogError(message),
      ),
    );
  }
}

class _DialogErrorState extends State<DialogError> with ThemeMixin, SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(top: 16),
      contentPadding: const EdgeInsets.all(16),
      actionsPadding: const EdgeInsets.all(12),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _animation,
            child: const Icon(
              Icons.report_rounded,
              color: Colors.red,
              size: 70,
            ),
          ),
          Text(
            'Atenção!',
            style: textTheme.titleLarge,
          )
        ],
      ),
      content: Text(
        widget.message.replaceAll('Exception: ', ''),
        style: textTheme.bodyMedium,
      ),
      actions: [
        FilledButton(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => Modular.to.pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
