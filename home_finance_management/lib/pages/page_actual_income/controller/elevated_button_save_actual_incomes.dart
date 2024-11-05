import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:home_finance_management/pages/page_actual_income/components/database_helper_for_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/components/filter_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/components/show_error_dialog_for_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/model/text_controller_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/model/list_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/model/actual_income_selected_date.dart';
import 'package:home_finance_management/pages/page_actual_income/model/selected_currency_actual_incomes.dart';

class ElevatedButtonSaveActualIncomes extends StatefulWidget {
  final VoidCallback updateActualIncomes;

  const ElevatedButtonSaveActualIncomes(
      {super.key, required this.updateActualIncomes});

  @override
  State<ElevatedButtonSaveActualIncomes> createState() =>
      _ElevatedButtonSaveActualIncomes();
}

class _ElevatedButtonSaveActualIncomes
    extends State<ElevatedButtonSaveActualIncomes> {
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
        if (textControllerActualIncomes.text.isEmpty) {
          return;
        }
        double sum;
        try {
          sum = double.parse(textControllerActualIncomes.text);
        } catch (e) {
          showErrorDialogForActualIncomes(context, 'Ошибка ввода',
              'Пожалуйста, введите корректное числовое значение.');
          return;
        }

        double convertedSum;
        if (selectedCurrencyActualIncomes != 'RUB') {
          convertedSum = await convertCurrency(
            selectedCurrencyActualIncomes,
            'RUB',
            sum,
          );
        } else {
          convertedSum = sum;
        }

        final dbHelper = DatabaseHelperForActualIncomes();
        final id = await dbHelper.insertActualIncome({
          'date': actualIncomeSelectedDate.toIso8601String(),
          'sum': convertedSum,
        });

        final actualIncome = ActualIncomes(
            idActualIncomes: id,
            dateActualIncomes: actualIncomeSelectedDate,
            sumActualIncomes: convertedSum);
        listActualIncomes.add(actualIncome);
        textControllerActualIncomes.clear();

        listActualIncomes
            .sort((a, b) => a.dateActualIncomes.compareTo(b.dateActualIncomes));

        filterActualIncomes(() {});

        widget.updateActualIncomes();
      },
      child: const Text('Сохранить'),
    );
  }
}
