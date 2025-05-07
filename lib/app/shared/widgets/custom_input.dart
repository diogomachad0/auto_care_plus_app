import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: FilledButton(
          style: FilledButton.styleFrom(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Colors.blue,
          ),
          onPressed: () {},
          child: null,
        ));
  }
}
