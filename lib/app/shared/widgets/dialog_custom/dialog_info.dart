import 'dart:ui';

import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DialogInfo extends StatefulWidget {
  final String message;
  final String title;

  const DialogInfo({super.key, required this.message, required this.title});

  @override
  State<DialogInfo> createState() => _DialogInfoState();

  static Future<void> show(BuildContext context, String title, String message) async {
    await showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: DialogInfo(
          title: title,
          message: message,
        ),
      ),
    );
  }
}

class _DialogInfoState extends State<DialogInfo> with ThemeMixin, SingleTickerProviderStateMixin {
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
            child: Icon(
              Icons.info_rounded,
              color: colorScheme.primary,
              size: 70,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title,
              style: textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
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
