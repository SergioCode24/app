import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_actual_expenses/components/filter_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/filter_dates_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/filtered_actual_expenses_list.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/list_actual_expenses.dart';

class WrapFilterButtonsForActualExpenses extends StatefulWidget {
  final VoidCallback updateActualExpenses;

  const WrapFilterButtonsForActualExpenses(
      {super.key, required this.updateActualExpenses});

  @override
  State<WrapFilterButtonsForActualExpenses> createState() =>
      _WrapFilterButtonsForActualExpensesState();
}

class _WrapFilterButtonsForActualExpensesState
    extends State<WrapFilterButtonsForActualExpenses> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      filterDatesActualExpenses[0].startDateActualExpenses =
                          picked;
                      filterActualExpenses(widget.updateActualExpenses);
                    });
                  }
                },
                child: const Text('Выбрать начальную дату',
                    textAlign: TextAlign.center),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      filterDatesActualExpenses[0].endDateActualExpenses =
                          picked;
                      filterActualExpenses(widget.updateActualExpenses);
                    });
                  }
                },
                child: const Text('Выбрать конечную дату',
                    textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              filteredActualExpensesList = listActualExpenses;
              filterDatesActualExpenses = [
                FilterForActualExpenses(
                    startDateActualExpenses: DateTime(2000, 1, 1),
                    endDateActualExpenses: DateTime.now())
              ];
              filterActualExpenses(widget.updateActualExpenses);
            });
          },
          child: const Text('Сбросить фильтр', textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
