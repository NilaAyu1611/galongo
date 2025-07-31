part of 'profile_customer_bloc.dart';

@immutable
abstract class ProfileCustomerEvent {}

class LoadCustomerProfile extends ProfileCustomerEvent {}

class UpdateCustomerProfile extends ProfileCustomerEvent {
  final CustomerProfileRequestModel request;

  UpdateCustomerProfile(this.request);
}
