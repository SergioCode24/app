class FilterForPlannedIncomes {
  DateTime startDatePlannedIncomes;
  DateTime endDatePlannedIncomes;

  FilterForPlannedIncomes(
      {required this.startDatePlannedIncomes,
      required this.endDatePlannedIncomes});
}

List<FilterForPlannedIncomes> filterDatesPlannedIncomes = [
  FilterForPlannedIncomes(
      startDatePlannedIncomes: DateTime.now(),
      endDatePlannedIncomes: DateTime(2124))
];
