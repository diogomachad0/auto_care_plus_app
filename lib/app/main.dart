import 'package:auto_care_plus_app/app/app_module.dart';
import 'package:auto_care_plus_app/app/app_widget.dart';
import 'package:auto_care_plus_app/app/modules/home/home_page.dart';
import 'package:auto_care_plus_app/app/shared/services/autenticacao_service/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'shared/firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    isAuthenticated = authService.user != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: isAuthenticated ? "/home" : "/",
      routes: {
        "/home": (context) => HomePage(authService: authService)
      },
    );
  }
}
