import 'package:flutter/material.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/pages/page_actual_expenses/components/filter_actual_expenses.dart';
import 'package:home_finance_management/model/categories.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/list_actual_expenses.dart';
import 'package:home_finance_management/model/selected_category.dart';

class IconButtonResetCategories extends StatefulWidget {
  final VoidCallback updateState;

  const IconButtonResetCategories(
      {super.key, required this.updateState});

  @override
  State<IconButtonResetCategories> createState() =>
      _IconButtonResetCategoriesState();
}

class _IconButtonResetCategoriesState
    extends State<IconButtonResetCategories> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.autorenew),
      onPressed: () async {
        final dbHelper = DatabaseHelper();
        await dbHelper.clearCategories();
        selectedCategory = 'Другое';
        listActualExpenses = await getActualExpensesFromDatabase();
        listActualExpenses
            .sort((a, b) => a.dateActualExpenses.compareTo(b.dateActualExpenses));
        categories = await getCategoriesFromDatabase();
        filterActualExpenses(widget.updateState);
        widget.updateState();
      },
    );
  }
}
