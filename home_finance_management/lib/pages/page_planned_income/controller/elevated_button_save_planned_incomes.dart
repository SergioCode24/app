import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_planned_income/model/selected_currency_planned_incomes.dart';
import 'package:http/http.dart' as http;
import 'package:home_finance_management/pages/page_planned_income/components/database_helper_for_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/components/filter_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/components/show_error_dialog_for_planned_incomes.dart';
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
  final String apiKey = 'd3d37cccac2e9edeb3161e0f';
  final String apiUrl = 'https://api.exchangerate-api.com/v4/latest/';

  Future<double> convertCurrency(String from, String to, double amount) async {
    final response = await http.get(Uri.parse('$apiUrl$from'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rate = data['rates'][to];
      return amount * rate;
    } else {
      throw Exception('Failed to load currency data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (textControllerPlannedIncomes.text.isEmpty) {
          return;
        }
        double sum;
        try {
          sum = double.parse(textControllerPlannedIncomes.text);
        } catch (e) {
          showErrorDialogForPlannedIncomes(context, 'Ошибка ввода',
              'Пожалуйста, введите корректное числовое значение.');
          return;
        }

        double convertedSum;
        if (selectedCurrencyPlannedIncomes != 'RUB') {
          convertedSum = await convertCurrency(
            selectedCurrencyPlannedIncomes,
            'RUB',
            sum,
          );
        } else {
          convertedSum = sum;
        }

        final dbHelper = DatabaseHelperForPlannedIncomes();
        final id = await dbHelper.insertPlannedIncome({
          'date': plannedIncomeSelectedDate.toIso8601String(),
          'sum': convertedSum,
        });

        final plannedIncome = PlannedIncomes(
            idPlannedIncomes: id,
            datePlannedIncomes: plannedIncomeSelectedDate,
            sumPlannedIncomes: convertedSum);
        listPlannedIncomes.add(plannedIncome);
        textControllerPlannedIncomes.clear();

        listPlannedIncomes.sort(
            (a, b) => a.datePlannedIncomes.compareTo(b.datePlannedIncomes));

        filterPlannedIncomes(() {});

        widget.updatePlannedIncomes();
      },
      child: const Text('Сохранить'),
    );
  }
}
