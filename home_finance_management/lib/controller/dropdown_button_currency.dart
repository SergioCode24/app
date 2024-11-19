import 'package:flutter/material.dart';
import 'package:home_finance_management/model/selected_currency.dart';

class DropdownButtonCurrency extends StatefulWidget {
  const DropdownButtonCurrency({super.key});

  @override
  State<DropdownButtonCurrency> createState() => _DropdownButtonCurrencyState();
}

class _DropdownButtonCurrencyState extends State<DropdownButtonCurrency> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      iconEnabledColor: Colors.white,
      dropdownColor: Colors.black54,
      value: selectedCurrency,
      onChanged: (String? newValue) {
        setState(() {
          selectedCurrency = newValue!;
        });
      },
      items: <String>['USD', 'EUR', 'RUB']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }
}
