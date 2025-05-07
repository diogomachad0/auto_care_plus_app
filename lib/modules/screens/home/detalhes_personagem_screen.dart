import 'package:auto_care_plus_app/shared/models/personagem.dart';
import 'package:flutter/material.dart';

class DetalhesPersonagemScreen extends StatelessWidget {
  final Personagem personagem;

  const DetalhesPersonagemScreen({super.key, required this.personagem});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(personagem.character),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              personagem.image,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                personagem.quote,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
