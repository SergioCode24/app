import 'package:flutter/material.dart';
import 'package:home_finance_management/model/selected_currency.dart';

class TextButtonCancel extends StatelessWidget {
  final String tempSelectedCurrency;

  const TextButtonCancel({super.key, required this.tempSelectedCurrency});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        selectedCurrency = tempSelectedCurrency;
        Navigator.of(context).pop();
      },
      child: const Text(
        'Отмена',
        style: TextStyle(color: Colors.deepPurpleAccent),
      ),
    );
  }
}
