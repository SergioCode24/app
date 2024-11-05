import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_planned_income/model/selected_currency_planned_incomes.dart';

class DropdownButtonCurrencyForPlannedIncomes extends StatefulWidget {
  const DropdownButtonCurrencyForPlannedIncomes({super.key});

  @override
  State<DropdownButtonCurrencyForPlannedIncomes> createState() =>
      _DropdownButtonCurrencyForPlannedIncomesState();
}

class _DropdownButtonCurrencyForPlannedIncomesState
    extends State<DropdownButtonCurrencyForPlannedIncomes> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedCurrencyPlannedIncomes,
      onChanged: (String? newValue) {
        setState(() {
          selectedCurrencyPlannedIncomes = newValue!;
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
