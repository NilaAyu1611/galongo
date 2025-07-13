part of 'confirmation_bloc.dart';

@immutable
sealed class ConfirmationState {}

final class ConfirmationInitial extends ConfirmationState {}

class ConfirmationLoading extends ConfirmationState {}

class ConfirmationSuccess extends ConfirmationState {
  final String message;

  ConfirmationSuccess(this.message);
}

class ConfirmationFailure extends ConfirmationState {
  final String error;

  ConfirmationFailure(this.error);
}