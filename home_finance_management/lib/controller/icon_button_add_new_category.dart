import 'package:flutter/material.dart';
import 'package:home_finance_management/component/database_helper.dart';
import 'package:home_finance_management/model/categories.dart';
import 'package:home_finance_management/model/text_controller_categories.dart';

class IconButtonAddNewCategory extends StatefulWidget {
  final VoidCallback updateState;

  const IconButtonAddNewCategory(
      {super.key, required this.updateState});

  @override
  State<IconButtonAddNewCategory> createState() =>
      _IconButtonAddNewCategoryState();
}

class _IconButtonAddNewCategoryState
    extends State<IconButtonAddNewCategory> {
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
                controller: textControllerCategories,
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
                    if (textControllerCategories
                        .text.isNotEmpty) {
                      final dbHelper = DatabaseHelper();
                      await dbHelper.insertCategories({
                        'name': textControllerCategories.text
                      });
                      categories =
                          await getCategoriesFromDatabase();
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
