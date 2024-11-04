import 'package:flutter/material.dart';
import 'package:home_finance_management/pages/page_actual_income/components/filter_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/model/filter_dates_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/model/filtered_actual_incomes_list.dart';
import 'package:home_finance_management/pages/page_actual_income/model/list_actual_incomes.dart';

class WrapFilterButtonsForActualIncomes extends StatefulWidget {
  final VoidCallback updateActualIncomes;

  const WrapFilterButtonsForActualIncomes({super.key, required this.updateActualIncomes});

  @override
  State<WrapFilterButtonsForActualIncomes> createState() => _WrapFilterButtonsForActualIncomes();
}

class _WrapFilterButtonsForActualIncomes extends State<WrapFilterButtonsForActualIncomes> {
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
                      filterDatesActualIncomes[0].startDateActualIncomes = picked;
                      filterActualIncomes(widget.updateActualIncomes);
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
                      filterDatesActualIncomes[0].endDateActualIncomes = picked;
                      filterActualIncomes(widget.updateActualIncomes);
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
              filteredActualIncomesList = listActualIncomes;
              filterDatesActualIncomes = [
                FilterForActualIncomes(startDateActualIncomes: DateTime(2000, 1, 1), endDateActualIncomes: DateTime.now())
              ];
              filterActualIncomes(widget.updateActualIncomes);
            });
          },
          child: const Text('Сбросить фильтр', textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
