enum PlanPeriod {
  weekly,
  fortnight,
  monthly;

  DateTime calculateEndDate(DateTime startDate) {
    if (this == PlanPeriod.weekly) {
      return startDate.add(Duration(days: 7));
    } else if (this == PlanPeriod.fortnight) {
      return startDate.add(Duration(days: 14));
    } else {
      return startDate.add(Duration(days: 30));
    }
  }
}
