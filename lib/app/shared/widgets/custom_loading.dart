import 'package:auto_care_plus_app/app/shared/theme/theme_light.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final ValueListenable listenable;
  final String textButton;
  final VoidCallback action;

  const CustomLoading({
    super.key,
    required this.listenable,
    required this.textButton,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: listenable,
      builder: (context, isLoading, _) {
        return FilledButton(
          onPressed: isLoading ? null : action,
          style: FilledButton.styleFrom(
            backgroundColor: ThemeLight.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: !isLoading
              ? Text(
                  textButton,
                )
              : CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ThemeLight.colorScheme.primary,
                ),
        );
      },
    );
  }
}
