part of 'promo_bloc.dart';

abstract class PromoState {}

class PromoInitial extends PromoState {}

class PromoLoading extends PromoState {}

class PromoLoadSuccess extends PromoState {
  final List<dynamic> promos;
  PromoLoadSuccess(this.promos);
}

class PromoOperationSuccess extends PromoState {
  final String message;
  PromoOperationSuccess(this.message);
}

class PromoFailure extends PromoState {
  final String message;
  PromoFailure(this.message);
}