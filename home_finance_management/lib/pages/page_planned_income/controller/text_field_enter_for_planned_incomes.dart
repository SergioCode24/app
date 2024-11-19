import 'package:flutter/material.dart';

class TextFieldEnterForPlannedIncomes extends StatelessWidget {
  final TextEditingController? textControllerPlannedIncomes;

  const TextFieldEnterForPlannedIncomes({
    super.key,
    required this.textControllerPlannedIncomes,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      controller: textControllerPlannedIncomes,
      decoration: const InputDecoration(
        labelText: 'Введите доход',
        labelStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
