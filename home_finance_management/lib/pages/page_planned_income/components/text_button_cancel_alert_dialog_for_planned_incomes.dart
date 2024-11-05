import 'package:flutter/material.dart';

class TextButtonCancelAlertDialogForPlannedIncomes extends StatelessWidget {
  final String text;

  const TextButtonCancelAlertDialogForPlannedIncomes(
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
