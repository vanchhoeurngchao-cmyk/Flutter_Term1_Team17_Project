import './plan_period.dart';
import './income_record.dart';
import './planned_expense.dart';
import './actual_expense.dart';

class BudgetPlan {
  final String id;
  final String name;
  final PlanPeriod period;
  final DateTime startDate;
  final DateTime endDate;

  final List<IncomeRecord> incomes = [];
  final List<PlannedExpense> plans = [];
  final List<ActualExpense> expenses = [];

  BudgetPlan({
    required this.id,
    required this.name,
    required this.period,
    required this.startDate,
  }) : endDate = period.calculateEndDate(startDate);

  void addIncome(IncomeRecord income) {
    incomes.add(income);
  }

  void addPlan(PlannedExpense plan) {
    plans.add(plan);
  }

  void addExpense(ActualExpense expense) {
    expenses.add(expense);
  }

  double get totalIncome => incomes.fold(0.0, (sum, item) => sum + item.amount);
  double get totalPlan => plans.fold(0.0, (sum, item) => sum + item.amount);
  double get totalExpense => expenses.fold(0.0, (sum, item) => sum + item.amount);
  double get estimatedSaving => totalIncome - totalPlan;
  double get remaining => totalIncome - totalExpense;
}
