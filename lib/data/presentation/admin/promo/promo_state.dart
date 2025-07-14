part of 'promo_bloc.dart';

@immutable
sealed class PromoState {}

final class PromoInitial extends PromoState {}
class PromoLoading extends PromoState {}

class PromoSuccess extends PromoState {
  final String message;
  PromoSuccess(this.message);
}

class PromoFailure extends PromoState {
  final String error;
  PromoFailure(this.error);
}

class PromoListLoaded extends PromoState {
  final List<dynamic> promos;
  PromoListLoaded(this.promos);
}
