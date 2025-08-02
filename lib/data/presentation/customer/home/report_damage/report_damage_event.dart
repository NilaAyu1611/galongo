part of 'report_damage_bloc.dart';

@immutable
abstract class ReportDamageEvent {}

class SubmitDamageReport extends ReportDamageEvent {
  final ReportDamageRequestModel request;
  final File imageFile;

  SubmitDamageReport(this.request, this.imageFile);
}

class LoadDamageReports extends ReportDamageEvent {}

class UpdateDamageReportStatus extends ReportDamageEvent {
  final int id;
  final String newStatus;

  UpdateDamageReportStatus({required this.id, required this.newStatus});
}
