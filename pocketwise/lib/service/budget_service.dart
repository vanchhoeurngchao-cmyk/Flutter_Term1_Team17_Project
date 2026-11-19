import '../model/plan_period.dart';
import '../model/category.dart';
import '../model/income_record.dart';
import '../model/planned_expense.dart';
import '../model/actual_expense.dart';
import '../model/budget_plan.dart';

class Budgetservice {
  BudgetPlan? currentPlan;

  List<Category> categories = [];
  String _idGenerator() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  BudgetPlan createPlan(
    String name,
    PlanPeriod period,
    DateTime startDate,
  ) {
    if (currentPlan != null) {
      throw Exception(
        "You already have an active plan. New plan can't be create!",
      );
    }

    BudgetPlan newPlan = BudgetPlan(
      id: _idGenerator(),
      name: name,
      period: period,
      startDate: startDate,
    );
    currentPlan = newPlan;
    return newPlan;
  }

  Category addCategory(String id, String name) {
    for (var c in categories) {
      if (c.name.toLowerCase() == name.toLowerCase()) {
        throw Exception("This Category already exists!");
      }
    }

    Category newCategory = Category(id: id, name: name);
    categories.add(newCategory);
    return newCategory;
  }

  IncomeRecord addIncome(
    String id,
    double amount,
    String source,
    DateTime date,
  ) {
    if (currentPlan == null) {
      throw Exception("No Active plan! Please create Plan first.");
    }

    if (amount <= 0) {
      throw Exception("The amount must be greater than 0!");
    }

    IncomeRecord newIncome = IncomeRecord(
      id: id,
      amount: amount,
      source: source,
      date: date,
    );

    currentPlan!.addIncome(newIncome);
    return newIncome;
  }

  PlannedExpense addPlan(
    String id,
    double amount,
    DateTime date,
    Category category,
  ) {
    if (currentPlan == null) {
      throw Exception("No Active plan! Please create Plan first.");
    }

    if (amount <= 0) {
      throw Exception("The amount must be greater than 0!");
    }

    bool categoryExists = false;
    for (var c in categories) {
      if (c.id == category.id) {
        categoryExists = true;
        break;
      }
    }

    if (!categoryExists) {
      throw Exception("This Category doesn't exists");
    }

    PlannedExpense plan = PlannedExpense(
      id: id,
      amount: amount,
      date: date,
      category: category,
    );

    currentPlan!.addPlan(plan);
    return plan;
  }

  ActualExpense addExpense(
    String id,
    double amount,
    DateTime date,
    Category category,
  ) {
    if (currentPlan == null) {
      throw Exception("No Active plan! Please create Plan first.");
    }

    if (amount <= 0) {
      throw Exception("The amount must be greater than 0!");
    }

    bool categoryExists = false;
    for (var c in categories) {
      if (c.id == category.id) {
        categoryExists = true;
        break;
      }
    }

    if (!categoryExists) {
      throw Exception("This Category doesn't exists");
    }

    if (date.isBefore(currentPlan!.startDate) ||
        date.isAfter(currentPlan!.endDate)) {
      throw Exception("Expense date must stay between the plan period");
    }

    ActualExpense expense = ActualExpense(
      id: id,
      amount: amount,
      date: date,
      category: category,
    );

    currentPlan!.addExpense(expense);
    return expense;
  }

  bool isCategoryOverSpent(Category category) {
    if (currentPlan == null) {
      return false;
    }

    double totalPlan = 0.0;
    for (var p in currentPlan!.plans) {
      if (p.category.id == category.id) {
        totalPlan += p.amount;
      }
    }

    double totalExpense = 0.0;
    for (var e in currentPlan!.expenses) {
      if (e.category.id == category.id) {
        totalExpense += e.amount;
      }
    }

    if (totalExpense > totalPlan) {
      return true;
    }

    return false;
  }
}
