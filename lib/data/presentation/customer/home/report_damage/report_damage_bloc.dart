import 'dart:io';

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
      final result = await repository.reportDamage(event.request, event.imageFile);
      result.fold(
        (l) => emit(ReportDamageFailure(l)),
        (r) => emit(ReportDamageSubmitSuccess(r.message ?? "Laporan berhasil dikirim")),
      );
    });    
     on<LoadDamageReports>((event, emit) async {
      emit(ReportDamageLoading());
      final result = await repository.getAllDamageReports(); // Ganti dengan method-mu
      result.fold(
        (l) => emit(ReportDamageFailure(l)),
        (r) => emit(ReportDamageLoadSuccess(r)), // r seharusnya List<dynamic> atau model kamu
      );
    });


  }
}