import 'package:flutter/material.dart';

void confirmarLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.amber,
        title: const Text(
          "Fazer logout",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Você realmente deseja sair?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Não",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, "/");
            },
            child: const Text(
              "Sim",
              style: TextStyle(
                color: Colors.red
              ),
            ),
          ),
        ],
      );
    },
  );
}
