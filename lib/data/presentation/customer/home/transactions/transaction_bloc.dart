import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:galongo/data/model/request/customer/transaction_request_model.dart';
import 'package:galongo/data/model/response/customer/transaction_response_model.dart';
import 'package:galongo/data/repository/transaction_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository transactionRepository;

  TransactionBloc(this.transactionRepository) : super(TransactionInitial()) {
    on<LoadAllTransactions>(_onLoadAllTransactions);
    on<CreateTransaction>(_onCreateTransaction);
  }

  Future<void> _onLoadAllTransactions(
    LoadAllTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    final result = await transactionRepository.getAllTransactions();
    result.fold(
      (error) => emit(TransactionFailure(error)),
      (transactions) => emit(TransactionSuccess(transactions)),
    );
  }

  Future<void> _onCreateTransaction(
    CreateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    final result = await transactionRepository.createTransaction(event.request);
    result.fold(
      (error) => emit(TransactionFailure(error)),
      (response) => emit(TransactionCreated(response)),
    );
  }
}
