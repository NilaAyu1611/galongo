part of 'report_damage_bloc.dart';

@immutable
sealed class ReportDamageState {}

final class ReportDamageInitial extends ReportDamageState {}

final class ReportDamageLoading extends ReportDamageState {}

final class ReportDamageSuccess extends ReportDamageState {
  final String message;
  ReportDamageSuccess(this.message);
}

final class ReportDamageFailure extends ReportDamageState {
  final String message;
  ReportDamageFailure(this.message);
}