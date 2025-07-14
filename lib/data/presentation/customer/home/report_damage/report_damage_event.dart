part of 'report_damage_bloc.dart';

@immutable
abstract class ReportDamageEvent {}

class SubmitDamageReport extends ReportDamageEvent {
  final ReportDamageRequestModel request;
  SubmitDamageReport(this.request);
}

class LoadDamageReports extends ReportDamageEvent {}
