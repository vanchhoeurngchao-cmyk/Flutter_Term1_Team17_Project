import './transaction.dart';

class IncomeRecord implements Transaction {
  @override
  final String id;
  @override
  final double amount;
  final String source;
  @override
  final DateTime date;

  IncomeRecord({required this.id, required this.amount, required this.source, required this.date});
}
