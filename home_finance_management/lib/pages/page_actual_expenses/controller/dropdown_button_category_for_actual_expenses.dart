import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/categories_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/selected_category_actual_expenses.dart';

class DropdownButtonCategoryForActualExpenses extends StatefulWidget {
  const DropdownButtonCategoryForActualExpenses({super.key});

  @override
  State<DropdownButtonCategoryForActualExpenses> createState() =>
      _DropdownButtonCategoryForActualExpensesState();
}

class _DropdownButtonCategoryForActualExpensesState
    extends State<DropdownButtonCategoryForActualExpenses> {

  @override
  Widget build(BuildContext context) {
    return DropdownButton<CategoryActualExpenses>(
          value: selectedCategoryActualExpenses,
          hint: const Text('Выберите категорию'),
          onChanged: (CategoryActualExpenses? newValue) {
            setState(() {
              selectedCategoryActualExpenses = newValue!;
            });
          },
          items: categoriesActualExpenses
              .map<DropdownMenuItem<CategoryActualExpenses>>((CategoryActualExpenses value) {
            return DropdownMenuItem<CategoryActualExpenses>(
              value: value.nameActualExpenses,
              child: Text(value.nameActualExpenses),
            );
          }).toList(),
        );
  }
}
