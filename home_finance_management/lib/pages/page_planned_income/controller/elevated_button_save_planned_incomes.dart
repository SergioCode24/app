import 'package:flutter/material.dart';
import 'package:home_finance_management/component/conver_currency.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/component/show_error_dialog.dart';
import 'package:home_finance_management/model/selected_currency.dart';
import 'package:home_finance_management/pages/page_planned_income/components/filter_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/model/text_controller_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/model/list_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/model/planned_incomes_selected_date.dart';

class ElevatedButtonSavePlannedIncomes extends StatefulWidget {
  final VoidCallback updatePlannedIncomes;

  const ElevatedButtonSavePlannedIncomes(
      {super.key, required this.updatePlannedIncomes});

  @override
  State<ElevatedButtonSavePlannedIncomes> createState() =>
      _ElevatedButtonSavePlannedIncomesState();
}

class _ElevatedButtonSavePlannedIncomesState
    extends State<ElevatedButtonSavePlannedIncomes> {
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
        if (textControllerPlannedIncomes.text.isEmpty) {
          return;
        }
        double sum;
        try {
          sum = double.parse(textControllerPlannedIncomes.text);
        } catch (e) {
          showErrorDialog(context, 'Ошибка ввода',
              'Пожалуйста, введите корректное числовое значение.');
          return;
        }
        double convertedSum;
        if (selectedCurrency != 'RUB') {
          convertedSum = await convertCurrency(
            selectedCurrency,
            'RUB',
            sum,
          );
        } else {
          convertedSum = sum;
        }
        final dbHelper = DatabaseHelper();
        await dbHelper.insertPlannedIncome({
          'date': plannedIncomeSelectedDate.toIso8601String(),
          'sum': convertedSum,
        });
        textControllerPlannedIncomes.clear();
        listPlannedIncomes = await getPlannedIncomesFromDatabase();
        listPlannedIncomes.sort(
            (a, b) => a.datePlannedIncomes.compareTo(b.datePlannedIncomes));
        filterPlannedIncomes(() {});
        widget.updatePlannedIncomes();
      },
      child: const Text(
        'Сохранить',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
