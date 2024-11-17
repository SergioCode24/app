import 'package:flutter/material.dart';

class TextFieldEnterForPlannedExpenses extends StatelessWidget {
  final TextEditingController? textControllerPlannedExpenses;
  final String? labelText;
  final TextInputType? keyboardType;

  const TextFieldEnterForPlannedExpenses(
      {super.key,
      required this.labelText,
      required this.textControllerPlannedExpenses,
      required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: textControllerPlannedExpenses,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
