import 'dart:ui';

import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DialogSucess extends StatefulWidget {
  final String message;
  final bool autoClose;

  const DialogSucess(this.message, {super.key, this.autoClose = false});

  @override
  State<DialogSucess> createState() => _DialogSucessState();

  static Future<void> show(
    BuildContext context,
    String message, {
    bool autoClose = false,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: DialogSucess(message, autoClose: autoClose),
      ),
    );
  }
}

class _DialogSucessState extends State<DialogSucess> with ThemeMixin, SingleTickerProviderStateMixin {
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

    if (widget.autoClose) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Modular.to.pop();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 70,
            ),
          ),
          Text(
            'Oba!',
            style: textTheme.titleLarge,
          ),
        ],
      ),
      content: Text(
        widget.message,
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
