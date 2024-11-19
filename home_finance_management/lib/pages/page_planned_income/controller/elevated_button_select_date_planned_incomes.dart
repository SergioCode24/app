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
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.white24),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.white),
          ),
        ),
      ),
      onPressed: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2124),
          locale: const Locale('ru'),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.dark(),
              ),
              child: child!,
            );
          },
        );
        if (picked != null && picked != plannedIncomeSelectedDate) {
          setState(() {
            plannedIncomeSelectedDate = picked;
          });
        }
      },
      child: const Text(
        'Выбрать дату',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
