import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_planned_income/model/planned_incomes_selected_date.dart';

class ElevatedButtonSelectDatePlannedIncomes extends StatefulWidget {
  const ElevatedButtonSelectDatePlannedIncomes({super.key});

  @override
  State<ElevatedButtonSelectDatePlannedIncomes> createState() =>
      _ElevatedButtonSelectDatePlannedIncomesState();
}

class _ElevatedButtonSelectDatePlannedIncomesState
    extends State<ElevatedButtonSelectDatePlannedIncomes> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2124),
        );
        if (picked != null && picked != plannedIncomeSelectedDate) {
          setState(() {
            plannedIncomeSelectedDate = picked;
          });
        }
      },
      child: const Text('Выбрать дату'),
    );
  }
}
