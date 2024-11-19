import 'package:flutter/material.dart';

class TextFieldEnterForActualIncomes extends StatelessWidget {
  final TextEditingController? textControllerActualIncomes;

  const TextFieldEnterForActualIncomes(
      {super.key, required this.textControllerActualIncomes});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      controller: textControllerActualIncomes,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'Введите доход',
        labelStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
