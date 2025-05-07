import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/theme/theme_light.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oktoast/oktoast.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> with ThemeMixin {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Auto Care Plus',
        theme: ThemeData(
          colorScheme: ThemeLight.colorScheme,
          fontFamily: 'Cabin',
          bottomSheetTheme: const BottomSheetThemeData(
            showDragHandle: true,
          ),
          textTheme: TextTheme(
              titleLarge: textTheme.titleLarge?.copyWith(
                fontFamily: 'Cabin',
                fontWeight: FontWeight.w500,
              ),
              displayMedium: textTheme.displayMedium?.copyWith(
                fontFamily: 'Cabin',
                fontSize: 64,
              ),
              displayLarge: textTheme.displayLarge?.copyWith(
                fontFamily: 'CabinCondensed',
                fontWeight: FontWeight.w600,
                fontSize: 64,
                color: Colors.white,
              )),
        ),
        routerConfig: Modular.routerConfig,
      ),
    ); //added by extension
  }
}
