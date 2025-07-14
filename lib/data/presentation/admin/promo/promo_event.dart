part of 'promo_bloc.dart';

@immutable
sealed class PromoEvent {}
class SubmitPromo extends PromoEvent {
  final PromoRequestModel request;
  SubmitPromo(this.request);
}

class FetchPromoList extends PromoEvent {}

