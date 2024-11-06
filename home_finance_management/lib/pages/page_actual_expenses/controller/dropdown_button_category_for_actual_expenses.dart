import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/categories_actual_expenses.dart';

class DropdownButtonCategoryForActualExpenses extends StatefulWidget {
  const DropdownButtonCategoryForActualExpenses({super.key});

  @override
  State<DropdownButtonCategoryForActualExpenses> createState() =>
      _DropdownButtonCategoryForActualExpensesState();
}

class _DropdownButtonCategoryForActualExpensesState
    extends State<DropdownButtonCategoryForActualExpenses> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          value: selectedCategory,
          hint: const Text('Выберите категорию'),
          onChanged: (String? newValue) {
            setState(() {
              selectedCategory = newValue!;
            });
          },
          items: categoriesActualExpenses
              .map<DropdownMenuItem<String>>((CategoryActualExpenses value) {
            return DropdownMenuItem<String>(
              value: value.nameActualExpenses,
              child: Text(value.nameActualExpenses),
            );
          }).toList(),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            _showAddCategoryDialog(context);
          },
        ),
      ],
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Добавить новую категорию'),
          content: TextField(
            controller: controller,
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
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    categoriesActualExpenses.add(CategoryActualExpenses(
                        nameActualExpenses: controller.text));
                    selectedCategory = controller.text;
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }
}
