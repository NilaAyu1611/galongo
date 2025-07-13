part of 'transaction_state.dart';


import 'package:galongo/data/model/response/customer/transaction_response_model.dart';

sealed class TransactionState {}

final class TransactionInitial extends TransactionState {}

final class TransactionLoading extends TransactionState {}

final class TransactionSuccess extends TransactionState {
  final List<String> transactions;

  TransactionSuccess(this.transactions);
}

final class TransactionFailure extends TransactionState {
  final String message;

  TransactionFailure(this.message);
}

final class TransactionCreated extends TransactionState {
  final TransactionResponseModel response;

  TransactionCreated(this.response);
}
