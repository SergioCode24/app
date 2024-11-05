import 'package:flutter/material.dart';

class TextFieldEnterForPlannedIncomes extends StatelessWidget {
  final TextEditingController? textControllerPlannedIncomes;
  final String? labelText;
  final TextInputType? keyboardType;

  const TextFieldEnterForPlannedIncomes(
      {super.key,
      required this.labelText,
      required this.textControllerPlannedIncomes,
      required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: textControllerPlannedIncomes,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
