import 'dart:ui';

import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DialogSucess extends StatefulWidget {
  final String message;

  const DialogSucess({super.key, required this.message});

  @override
  State<DialogSucess> createState() => _DialogSucessState();

  static Future<void> show(BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: DialogSucess(message: message),
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _animation,
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 70,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.message,
            style: textTheme.bodyMedium,
          ),
        ],
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
        )
      ],
    );
  }
}
