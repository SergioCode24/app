class FilterForPlannedExpenses {
  DateTime startDatePlannedExpenses;
  DateTime endDatePlannedExpenses;

  FilterForPlannedExpenses(
      {required this.startDatePlannedExpenses,
      required this.endDatePlannedExpenses});
}

List<FilterForPlannedExpenses> filterDatesPlannedExpenses = [
  FilterForPlannedExpenses(
      startDatePlannedExpenses: DateTime.now().subtract(const Duration(days: 1)),
      endDatePlannedExpenses: DateTime(2124))
];
