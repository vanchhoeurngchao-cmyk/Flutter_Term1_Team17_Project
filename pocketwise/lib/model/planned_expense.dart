import './transaction.dart';
import './category.dart';

class PlannedExpense implements Transaction {
  @override
  final String id;
  @override
  final double amount;
  @override
  final DateTime date;
  final Category category;

  PlannedExpense({required this.id, required this.amount, required this.date, required this.category});
}
