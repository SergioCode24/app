import 'package:flutter/material.dart';

class TextButtonCancelAlertDialogForActualIncomes extends StatelessWidget {
  final String text;

  const TextButtonCancelAlertDialogForActualIncomes({super.key, required this.text});

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