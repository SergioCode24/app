import 'package:flutter/material.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/categories_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/text_controller_categories_actual_expenses.dart';

class IconButtonAddNewCategoryActualExpenses extends StatefulWidget {
  final VoidCallback updateState;

  const IconButtonAddNewCategoryActualExpenses(
      {super.key, required this.updateState});

  @override
  State<IconButtonAddNewCategoryActualExpenses> createState() =>
      _IconButtonAddNewCategoryActualExpensesState();
}

class _IconButtonAddNewCategoryActualExpensesState
    extends State<IconButtonAddNewCategoryActualExpenses> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Добавить новую категорию'),
              content: TextField(
                controller: textControllerCategoriesActualExpenses,
                decoration: const InputDecoration(
                  hintText: 'Введите название категории',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Отмена'),
                ),
                TextButton(
                  onPressed: () async {
                    if (textControllerCategoriesActualExpenses
                        .text.isNotEmpty) {
                      final dbHelper = DatabaseHelper();
                      await dbHelper.insertCategoriesActualExpenses({
                        'name': textControllerCategoriesActualExpenses.text
                      });
                      categoriesActualExpenses =
                          await getCategoriesActualExpensesFromDatabase();
                      widget.updateState();
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Добавить'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
