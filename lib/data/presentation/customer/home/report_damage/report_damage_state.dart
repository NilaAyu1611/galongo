part of 'report_damage_bloc.dart';

@immutable
abstract class ReportDamageState {}

class ReportDamageInitial extends ReportDamageState {}
class ReportDamageLoading extends ReportDamageState {}
class ReportDamageSubmitSuccess extends ReportDamageState {
  final String message;
  ReportDamageSubmitSuccess(this.message);
}
class ReportDamageLoadSuccess extends ReportDamageState {
  final List<dynamic> reports;
  ReportDamageLoadSuccess(this.reports);
}
class ReportDamageFailure extends ReportDamageState {
  final String error;
  ReportDamageFailure(this.error);
}