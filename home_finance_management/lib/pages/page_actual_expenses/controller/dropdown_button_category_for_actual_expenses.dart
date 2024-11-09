import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/categories_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/selected_category_actual_expenses.dart';

class DropdownButtonCategoryForActualExpenses extends StatefulWidget {
  final VoidCallback updateState;

  const DropdownButtonCategoryForActualExpenses(
      {super.key, required this.updateState});

  @override
  State<DropdownButtonCategoryForActualExpenses> createState() =>
      _DropdownButtonCategoryForActualExpensesState();
}

class _DropdownButtonCategoryForActualExpensesState
    extends State<DropdownButtonCategoryForActualExpenses> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedCategoryActualExpenses,
      hint: const Text('Выберите категорию'),
      onChanged: (String? newValue) {
        setState(() {
          selectedCategoryActualExpenses = newValue!;
        });
        widget.updateState();
      },
      items: categoriesActualExpenses
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
