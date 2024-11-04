import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_planned_income/model/selected_date.dart';

class ElevatedButtonSelectDate extends StatefulWidget {
  const ElevatedButtonSelectDate({super.key});

  @override
  State<ElevatedButtonSelectDate> createState() => _ElevatedButtonSelectDate();
}

class _ElevatedButtonSelectDate extends State<ElevatedButtonSelectDate> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2024),
          lastDate: DateTime.now(),
        );
        if (picked != null && picked != actualIncomeSelectedDate) {
          setState(() {
            actualIncomeSelectedDate = picked;
          });
        }
      },
      child: const Text('Выбрать дату'),
    );
  }
}