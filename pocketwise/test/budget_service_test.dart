import 'package:test/test.dart';
import 'package:pocketwise/model/plan_period.dart';
import 'package:pocketwise/service/budget_service.dart';

void main() {
  test('creates a budget plan', () {
    final budgetService = Budgetservice();

    budgetService.createPlan(
      'Semester Plan', 
      PlanPeriod.weekly, 
      DateTime(2024, 5, 1)
    );

    expect(budgetService.currentPlan!.name, 'Semester Plan');
  });

  test('rejects a second active plan', () {
    final budgetService = Budgetservice();

    budgetService.createPlan('Plan 1', PlanPeriod.monthly, DateTime(2024, 5, 1));

    expect(
      () => budgetService.createPlan('Plan 2', PlanPeriod.weekly, DateTime(2024, 6, 1)), 
      throwsException
    );
  });

  test('rejects invalid income amounts', () {
    final budgetService = Budgetservice();
    
    budgetService.createPlan('Plan 1', PlanPeriod.monthly, DateTime(2024, 5, 1));

    expect(
      () => budgetService.addIncome('I1', -50.0, 'Allowance', DateTime(2024, 5, 2)), 
      throwsException
    );
  });

  test('allows expense exactly on the plan start date', () {
    final budgetService = Budgetservice();
    
    final food = budgetService.addCategory('C1', 'Food');
    budgetService.createPlan('Plan 1', PlanPeriod.weekly, DateTime(2024, 5, 1));

    budgetService.addExpense('E1', 20.0, DateTime(2024, 5, 1), food);

    expect(budgetService.currentPlan!.expenses.first.amount, 20.0);
  });

  test('rejects expense outside the plan period', () {
    final budgetService = Budgetservice();
    
    final food = budgetService.addCategory('C1', 'Food');
    budgetService.createPlan('Plan 1', PlanPeriod.weekly, DateTime(2024, 5, 10));

    expect(
      () => budgetService.addExpense('E1', 15.0, DateTime(2024, 5, 5), food), 
      throwsException
    );
  });

  test('detects an overspent category', () {
    final budgetService = Budgetservice();
    
    final food = budgetService.addCategory('C1', 'Food');
    budgetService.createPlan('Plan 1', PlanPeriod.monthly, DateTime(2024, 5, 1));

    budgetService.addPlan('P1', 100.0, DateTime(2024, 5, 1), food);
    budgetService.addExpense('E1', 50.0, DateTime(2024, 5, 2), food);
    
    expect(budgetService.isCategoryOverSpent(food), false);

    budgetService.addExpense('E2', 60.0, DateTime(2024, 5, 3), food);
    
    expect(budgetService.isCategoryOverSpent(food), true);
  });
  
  test('rejects a duplicate category name', () {
    final budgetService = Budgetservice();
    
    budgetService.addCategory('C1', 'Food');
    
    expect(() => budgetService.addCategory('C2', 'food'), throwsException);
  });
}