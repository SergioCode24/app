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
          firstDate: DateTime(2024),
          lastDate: DateTime.now(),
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
        if (picked != null && picked != actualIncomeSelectedDate) {
          setState(() {
            actualIncomeSelectedDate = picked;
          });
        }
      },
      child: const Text('Выбрать дату',style: TextStyle(color: Colors.white),),
    );
  }
}
