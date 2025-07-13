part of 'transaction_event.dart';
import 'package:galongo/data/model/request/customer/transaction_request_model.dart';


sealed class TransactionEvent {}

class LoadAllTransactions extends TransactionEvent {}

class CreateTransaction extends TransactionEvent {
  final TransactionRequestModel request;

  CreateTransaction(this.request);
}
