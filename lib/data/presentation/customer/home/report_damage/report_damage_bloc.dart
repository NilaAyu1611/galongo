import 'package:bloc/bloc.dart';
import 'package:galongo/data/model/request/customer/report_damage_request_model.dart';
import 'package:galongo/data/repository/report_damage_repository.dart';
import 'package:meta/meta.dart';

part 'report_damage_event.dart';
part 'report_damage_state.dart';

class ReportDamageBloc extends Bloc<ReportDamageEvent, ReportDamageState> {
  final ReportDamageRepository repository;

  ReportDamageBloc(this.repository) : super(ReportDamageInitial()) {
    on<SubmitDamageReport>((event, emit) async {
      emit(ReportDamageLoading());

      final request = ReportDamageRequestModel(
        orderId: event.orderId,
        description: event.description,
        photo: event.photoBase64,
      );

      final result = await repository.reportDamage(request);

      result.fold(
        (error) => emit(ReportDamageFailure(error)),
        (success) => emit(ReportDamageSuccess(success.message ?? "Berhasil")),
      );
    });
  }
}