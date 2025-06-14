import 'package:auto_care_plus_app/app/modules/splash/splash_controller.dart';
import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with ThemeMixin {
  final SplashController controller = Modular.get<SplashController>();

  @override
  void initState() {
    controller.load(context);
    controller.fadeInLogo();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary,
              colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Observer(
                builder: (context) {
                  return AnimatedOpacity(
                    opacity: controller.opacity,
                    duration: const Duration(milliseconds: 1500),
                    child: Image.asset(
                      'assets/img/logo_white_app.png',
                      width: 280,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
