import 'package:flutter/material.dart';

class DropdownButtonCurrencyForActualIncomes extends StatefulWidget {
  String selectedCurrencyActualIncomes;

  DropdownButtonCurrencyForActualIncomes({super.key, required this.selectedCurrencyActualIncomes});

  @override
  State<DropdownButtonCurrencyForActualIncomes> createState() => _DropdownButtonCurrencyForActualIncomesState();
}

class _DropdownButtonCurrencyForActualIncomesState extends State<DropdownButtonCurrencyForActualIncomes> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedCurrencyActualIncomes,
      onChanged: (String? newValue) {
        setState(() {
          widget.selectedCurrencyActualIncomes = newValue!;
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
