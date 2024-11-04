import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_planned_income/components/filter_planned_incomes.dart';
import 'package:home_finance_management/pages/page_planned_income/model/filter_dates.dart';
import 'package:home_finance_management/pages/page_planned_income/model/filtered_list.dart';
import 'package:home_finance_management/pages/page_planned_income/model/list_incomes.dart';

class WrapFilterButtons extends StatefulWidget {
  final VoidCallback onSave;

  const WrapFilterButtons({super.key, required this.onSave});

  @override
  State<WrapFilterButtons> createState() => _WrapFilterButtons();
}

class _WrapFilterButtons extends State<WrapFilterButtons> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0, // Расстояние между элементами по горизонтали
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
                      filterDatesPlannedIncomes[0].startDatePlannedIncomes = picked;
                      filterPlannedIncomes(widget.onSave);
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
                      filterDatesPlannedIncomes[0].endDatePlannedIncomes = picked;
                      filterPlannedIncomes(widget.onSave);
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
              filteredPlannedIncomesList = listPlannedIncomes;
              filterDatesPlannedIncomes = [
                FilterForPlannedIncomes(startDatePlannedIncomes: DateTime(2000, 1, 1), endDatePlannedIncomes: DateTime.now())
              ];
              filterPlannedIncomes(widget.onSave);
            });
          },
          child: const Text('Сбросить фильтр', textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
