import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/selected_currency_actual_expenses.dart';

class DropdownButtonCurrencyForActualExpenses extends StatefulWidget {
  const DropdownButtonCurrencyForActualExpenses({super.key});

  @override
  State<DropdownButtonCurrencyForActualExpenses> createState() =>
      _DropdownButtonCurrencyForActualExpensesState();
}

class _DropdownButtonCurrencyForActualExpensesState
    extends State<DropdownButtonCurrencyForActualExpenses> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedCurrencyActualExpenses,
      onChanged: (String? newValue) {
        setState(() {
          selectedCurrencyActualExpenses = newValue!;
        });
      },
      items: <String>['USD', 'EUR', 'RUB']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
