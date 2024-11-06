class FilterForActualExpenses {
  DateTime startDateActualExpenses;
  DateTime endDateActualExpenses;

  FilterForActualExpenses(
      {required this.startDateActualExpenses,
      required this.endDateActualExpenses});
}

List<FilterForActualExpenses> filterDatesActualExpenses = [
  FilterForActualExpenses(
      startDateActualExpenses: DateTime(2000, 1, 1),
      endDateActualExpenses: DateTime.now())
];