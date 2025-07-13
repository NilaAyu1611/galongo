part of 'confirmation_bloc.dart';

@immutable
sealed class ConfirmationEvent {}
class SubmitConfirmation extends ConfirmationEvent {
  final ConfirmationRequestModel request;

  SubmitConfirmation(this.request);
}
