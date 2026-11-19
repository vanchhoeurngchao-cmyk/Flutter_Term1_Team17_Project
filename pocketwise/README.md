# PocketWise - Personal Budget Planner

**Milestone 2: System Design & Architecture**

PocketWise is a beginner-friendly mobile application designed to help university students and young workers manage their income and expenses through flexible planning periods (weekly, two-week, or monthly).

---

## 1. System Architecture

The application follows a strict layered architecture to separate concerns. This ensures the UI does not know about business rules, and the models do not know about the UI.

### Layer Overview

1. **Presentation Layer (Flutter UI - M3)**
   - Contains screens (Dashboard, Add Expense, Summary).
   - Only handles user input and displays data.
   - **Does not** perform calculations or enforce rules.
2. **Service Layer (Business Logic - M2)**
   - Acts as the "brain" (e.g., `BudgetService`).
   - Enforces business rules, validates inputs, and coordinates data flow.
   - Interfaces between the UI and the Models.
3. **Model Layer (Domain Data - M2)**
   - Contains the core entities (`BudgetPlan`, `Category`, `IncomeRecord`, etc.).
   - Holds the data structure and basic mathematical logic (e.g., calculating totals).
   - Uses Object-Oriented Programming (OOP) principles like Composition, Aggregation, and Interfaces.

### How Everything Connects (Flow of a Transaction)

1. **User Action:** User taps "Save" on the UI to record a $10 Food expense.
2. **Service Call:** The UI calls `budgetService.recordActualExpense(10.0, foodCategory, today)`.
3. **Business Rule Check:** The Service validates:
   - Is the amount > 0?
   - Is there an active budget plan?
   - Is the date within the plan's start and end dates?
4. **Model Update:** If valid, the Service creates an `ActualExpense` object and adds it to the `BudgetPlan` via its `addActualExpense()` method.
5. **Calculation:** The `BudgetPlan` model automatically updates its totals. The UI queries the service for the updated `remainingMoney` and refreshes the screen.

---

## 2. Domain Model (Class Relationships)

The Model Layer uses strict OOP relationships:
- **Composition (◆):** The `BudgetPlan` strictly owns its lists of `IncomeRecord`, `PlannedExpense`, and `ActualExpense`. If a plan is deleted, its records are destroyed.
- **Aggregation (◇):** An `Expense` holds a reference to a `Category`. If a category is deleted, the expense remains (but must be reassigned).
- **Interface:** `IncomeRecord` and `Expense` implement the `Transaction` interface, ensuring they all have an `id`, `amount`, and `date`.

*(Refer to the draw.io "System Design" diagram for the visual blueprint).*

---

## 3. Business Rules (Enforced by the Service Layer)

The `BudgetService` is responsible for enforcing the following rules during Milestone 2:

1. **Positive Values:** All income and expenses must be strictly greater than `0.0`.
2. **Single Active Plan:** A user cannot create a new `BudgetPlan` if one is currently active. They must close the active plan first.
3. **Valid Dates:** An actual expense cannot be recorded with a date that falls outside the `startDate` and `endDate` of the current plan.
4. **Overspending Alerts:** If an `ActualExpense` causes the total spent in a category to exceed the `PlannedExpense` for that category, the Service flags an overspending warning.
5. **Category Deletion:** A category cannot be deleted if it is currently referenced by any Planned or Actual Expense.

---

## 4. OOP Principles Demonstrated

- **Abstraction:** The `Transaction` interface hides implementation details and enforces a contract for all money movements.
- **Inheritance/Polymorphism:** The `BudgetService` can treat `IncomeRecord` and `ActualExpense` as `Transaction` types when generating a combined history.
- **Encapsulation:** The `BudgetPlan` uses getters (like `totalIncome`) so external classes can read the math but cannot directly mutate the internal lists without going through the approved `add...` methods.
- **Enhanced Enums:** `PlanningPeriod` contains logic (`calculateEndDate()`) to keep date math clean and centralized.