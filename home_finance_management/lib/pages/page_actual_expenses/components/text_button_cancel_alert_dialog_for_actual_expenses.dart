import 'package:flutter/material.dart';

class TextButtonCancelAlertDialogForActualExpenses extends StatelessWidget {
  final String text;

  const TextButtonCancelAlertDialogForActualExpenses(
      {super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text(text),
    );
  }
}
