part of 'profile_customer_bloc.dart';

@immutable
abstract class ProfileCustomerState {}

class ProfileCustomerInitial extends ProfileCustomerState {}

class ProfileCustomerLoading extends ProfileCustomerState {}

class ProfileCustomerLoaded extends ProfileCustomerState {
  final CustomerProfileResponseModel profile;

  ProfileCustomerLoaded(this.profile);
}

class ProfileCustomerUpdated extends ProfileCustomerState {
  final String message;

  ProfileCustomerUpdated(this.message);
}

class ProfileCustomerError extends ProfileCustomerState {
  final String message;

  ProfileCustomerError(this.message);
}