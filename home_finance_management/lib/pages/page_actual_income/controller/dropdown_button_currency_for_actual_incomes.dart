import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_actual_income/model/selected_currency_actual_incomes.dart';

class DropdownButtonCurrencyForActualIncomes extends StatefulWidget {
  const DropdownButtonCurrencyForActualIncomes({super.key});

  @override
  State<DropdownButtonCurrencyForActualIncomes> createState() =>
      _DropdownButtonCurrencyForActualIncomesState();
}

class _DropdownButtonCurrencyForActualIncomesState
    extends State<DropdownButtonCurrencyForActualIncomes> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedCurrencyActualIncomes,
      onChanged: (String? newValue) {
        setState(() {
          selectedCurrencyActualIncomes = newValue!;
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
