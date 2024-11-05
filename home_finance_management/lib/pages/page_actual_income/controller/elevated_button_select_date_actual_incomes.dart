import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_actual_income/model/actual_income_selected_date.dart';

class ElevatedButtonSelectDateActualIncomes extends StatefulWidget {
  const ElevatedButtonSelectDateActualIncomes({super.key});

  @override
  State<ElevatedButtonSelectDateActualIncomes> createState() =>
      _ElevatedButtonSelectDateActualIncomesState();
}

class _ElevatedButtonSelectDateActualIncomesState
    extends State<ElevatedButtonSelectDateActualIncomes> {
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
