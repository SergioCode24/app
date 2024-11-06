import 'package:flutter/material.dart';

class TextFieldEnterForActualExpenses extends StatelessWidget {
  final TextEditingController? textControllerActualExpenses;
  final String? labelText;
  final TextInputType? keyboardType;

  const TextFieldEnterForActualExpenses(
      {super.key,
      required this.labelText,
      required this.textControllerActualExpenses,
      required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: textControllerActualExpenses,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
