import 'package:flutter/material.dart';

class DropdownButtonCurrencyForPlannedIncomes extends StatefulWidget {
  String selectedCurrency; // здесь остановился

  DropdownButtonCurrencyForPlannedIncomes({super.key, required this.selectedCurrency});

  @override
  State<DropdownButtonCurrencyForPlannedIncomes> createState() => _DropdownButtonCurrencyForPlannedIncomesState();
}

class _DropdownButtonCurrencyForPlannedIncomesState extends State<DropdownButtonCurrencyForPlannedIncomes> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedCurrency,
      onChanged: (String? newValue) {
        setState(() {
          widget.selectedCurrency = newValue!;
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
