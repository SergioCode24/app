import 'package:flutter/material.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/pages/page_actual_expenses/components/filter_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/categories_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/list_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/selected_category_actual_expenses.dart';

class IconButtonResetCategoriesActualExpenses extends StatefulWidget {
  final VoidCallback updateState;

  const IconButtonResetCategoriesActualExpenses(
      {super.key, required this.updateState});

  @override
  State<IconButtonResetCategoriesActualExpenses> createState() =>
      _IconButtonResetCategoriesActualExpensesState();
}

class _IconButtonResetCategoriesActualExpensesState
    extends State<IconButtonResetCategoriesActualExpenses> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.autorenew),
      onPressed: () async {
        final dbHelper = DatabaseHelper();
        await dbHelper.clearCategoriesActualExpenses();
        selectedCategoryActualExpenses = 'Другое';
        listActualExpenses = await getActualExpensesFromDatabase();
        listActualExpenses
            .sort((a, b) => a.dateActualExpenses.compareTo(b.dateActualExpenses));
        categoriesActualExpenses = await getCategoriesActualExpensesFromDatabase();
        filterActualExpenses(widget.updateState);
        widget.updateState();
      },
    );
  }
}
