import 'package:home_finance_management/pages/page_actual_expenses/model/filter_dates_actual_expenses.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/filtered_actual_expenses_list.dart';
import 'package:home_finance_management/pages/page_actual_expenses/model/list_actual_expenses.dart';

void filterActualExpenses(Function updateState) {
  filteredActualExpensesList = listActualExpenses.where((actualExpenses) {
    return (actualExpenses.dateActualExpenses.isAfter(
                filterDatesActualExpenses[0].startDateActualExpenses) ||
            actualExpenses.dateActualExpenses.isAtSameMomentAs(
                filterDatesActualExpenses[0].startDateActualExpenses)) &&
        (actualExpenses.dateActualExpenses
                .isBefore(filterDatesActualExpenses[0].endDateActualExpenses) ||
            actualExpenses.dateActualExpenses.isAtSameMomentAs(
                filterDatesActualExpenses[0].endDateActualExpenses));
  }).toList();
  updateState();
}
