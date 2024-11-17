import 'package:home_finance_management/pages/page_actual_income/model/filter_dates_actual_incomes.dart';
import 'package:home_finance_management/pages/page_actual_income/model/filtered_actual_incomes_list.dart';
import 'package:home_finance_management/pages/page_actual_income/model/list_actual_incomes.dart';

void filterActualIncomes(Function updateState) {
  filteredActualIncomesList = listActualIncomes.where((actualIncome) {
    return (actualIncome.dateActualIncomes
                .isAfter(filterDatesActualIncomes[0].startDateActualIncomes) ||
            actualIncome.dateActualIncomes.isAtSameMomentAs(
                filterDatesActualIncomes[0].startDateActualIncomes)) &&
        (actualIncome.dateActualIncomes
                .isBefore(filterDatesActualIncomes[0].endDateActualIncomes) ||
            actualIncome.dateActualIncomes.isAtSameMomentAs(
                filterDatesActualIncomes[0].endDateActualIncomes));
  }).toList();
  updateState();
}
