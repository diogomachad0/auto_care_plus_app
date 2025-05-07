import 'package:auto_care_plus_app/shared/models/personagem.dart';
import 'package:auto_care_plus_app/shared/services/autenticacao_service/auth_service.dart';
import 'package:auto_care_plus_app/shared/services/personagem_service/personagem_services.dart';
import 'package:auto_care_plus_app/shared/widgets/confirmarLogout.dart';
import 'package:flutter/material.dart';

import 'detalhes_personagem_screen.dart';

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
