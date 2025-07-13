import 'package:bloc/bloc.dart';
import 'package:galongo/data/model/request/admin/confirmation_request_mode.dart';
import 'package:galongo/data/repository/confirmation_repository.dart';
import 'package:meta/meta.dart';

part 'confirmation_event.dart';
part 'confirmation_state.dart';

class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
  final ConfirmationRepository repository;

  ConfirmationBloc(this.repository) : super(ConfirmationInitial()) {
    on<SubmitConfirmation>((event, emit) async {
      emit(ConfirmationLoading());

      final result = await repository.confirmOrder(event.request);
      result.fold(
        (err) => emit(ConfirmationFailure(err)),
        (response) => emit(ConfirmationSuccess(response.message ?? 'Konfirmasi berhasil')),
      );
    });
  }
}
