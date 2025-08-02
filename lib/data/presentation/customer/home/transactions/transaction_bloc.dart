import 'package:bloc/bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/model/response/transaction_summary_respon_mode.dart';
import 'package:galongo/data/repository/transaction_repository.dart';
import 'package:meta/meta.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;
  TransactionBloc(this.repository) : super(TransactionInitial()) {
    on<LoadTransactions>((event, emit) async {
      emit(TransactionLoading());
      final result = await repository.getAdminTransactions();
      result.fold(
        (l) => emit(TransactionFailure(l)),
        (r) => emit(TransactionLoadSuccess(r)),
      );
    });

    on<LoadTransactionSummary>((event, emit) async {
      emit(TransactionLoading());
      final result = await repository.getAdminTransactionSummary();
      result.fold(
        (l) => emit(TransactionFailure(l)),
        (r) => emit(TransactionSummarySuccess(r)),
      );
    });
    
    on<LoadAllTransactionData>((event, emit) async {
  emit(TransactionLoading());

  final trxResult = await repository.getAdminTransactions();
  final summaryResult = await repository.getAdminTransactionSummary();

  if (trxResult.isLeft()) {
    emit(TransactionFailure(trxResult.fold((l) => l, (_) => '')));
    return;
  }

  if (summaryResult.isLeft()) {
    emit(TransactionFailure(summaryResult.fold((l) => l, (_) => '')));
    return;
  }

  emit(TransactionAllLoaded(
    transactions: trxResult.getOrElse(() => []),
    summary: summaryResult.getOrElse(() => TransactionSummary(totalIn: 0, totalOut: 0, netBalance: 0)),
  ));
});

    
  }
    
}
