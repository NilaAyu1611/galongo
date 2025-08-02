part of 'transaction_bloc.dart';


abstract class TransactionEvent {}
class LoadTransactions extends TransactionEvent {}
class LoadTransactionSummary extends TransactionEvent {}


class LoadAllTransactionData extends TransactionEvent {}
