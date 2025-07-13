part of 'report_damage_bloc.dart';

@immutable
sealed class ReportDamageEvent {}

class SubmitDamageReport extends ReportDamageEvent {
  final int orderId;
  final String description;
  final String photoBase64;

  SubmitDamageReport({
    required this.orderId,
    required this.description,
    required this.photoBase64,
  });
}