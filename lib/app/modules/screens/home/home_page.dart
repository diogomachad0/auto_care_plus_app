import 'package:auto_care_plus_app/app/shared/services/autenticacao_service/auth_service.dart';
import 'package:auto_care_plus_app/app/shared/services/personagem_service/personagem_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required AuthService authService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PersonagemServices service = PersonagemServices();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
