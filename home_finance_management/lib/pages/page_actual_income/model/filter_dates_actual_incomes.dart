class FilterForActualIncomes {
  DateTime startDateActualIncomes;
  DateTime endDateActualIncomes;

  FilterForActualIncomes(
      {required this.startDateActualIncomes,
      required this.endDateActualIncomes});
}

List<FilterForActualIncomes> filterDatesActualIncomes = [
  FilterForActualIncomes(
      startDateActualIncomes: DateTime(2000, 1, 1),
      endDateActualIncomes: DateTime.now())
];
