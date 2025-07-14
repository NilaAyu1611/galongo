part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final AuthResponseModel responseModel;
  final String role;

  LoginSuccess({required this.responseModel, required this.role});
}

final class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}