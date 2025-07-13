part of 'dashboard_bloc.dart';


sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}


final class DashboardLoading extends DashboardState {}

final class DashboardSuccess extends DashboardState {
  final DashboardResponseModel dashboard;

  DashboardSuccess({required this.dashboard});
}

final class DashboardFailure extends DashboardState {
  final String message;

  DashboardFailure({required this.message});
}