import 'package:flutter/material.dart';
import 'package:home_finance_management/model/categories.dart';
import 'package:home_finance_management/model/selected_category.dart';

class DropdownButtonCategoryInDialog extends StatefulWidget {
  final VoidCallback updateState;

  const DropdownButtonCategoryInDialog(
      {super.key, required this.updateState});

  @override
  State<DropdownButtonCategoryInDialog> createState() =>
      _DropdownButtonCategoryInDialogState();
}

class _DropdownButtonCategoryInDialogState
    extends State<DropdownButtonCategoryInDialog> {

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedCategory,
      hint: const Text('Выберите категорию'),
      onChanged: (String? newValue) {
        setState(() {
          selectedCategory = newValue!;
          widget.updateState();
        });
      },
      items: categories
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
