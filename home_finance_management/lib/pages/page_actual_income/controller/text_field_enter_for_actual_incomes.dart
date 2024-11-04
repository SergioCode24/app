import 'package:flutter/material.dart';

class TextFieldEnterForActualIncomes extends StatelessWidget {
  final TextEditingController? textControllerActualIncomes;
  final String? labelText;
  final TextInputType? keyboardType;

  const TextFieldEnterForActualIncomes(
      {super.key,
        required this.labelText,
        required this.textControllerActualIncomes,
        required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: textControllerActualIncomes,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}