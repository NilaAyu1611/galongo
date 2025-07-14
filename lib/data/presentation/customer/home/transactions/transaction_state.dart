part of 'transaction_bloc.dart';

abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoadSuccess extends TransactionState {
  final List<TransactionData> transactions;
  TransactionLoadSuccess(this.transactions);
}

class TransactionSummarySuccess extends TransactionState {
  final TransactionSummary summary;
  TransactionSummarySuccess(this.summary);
}

class TransactionFailure extends TransactionState {
  final String message;
  TransactionFailure(this.message);
}