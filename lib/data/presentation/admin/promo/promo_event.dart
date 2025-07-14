part of 'promo_bloc.dart';

abstract class PromoEvent {}

class LoadPromos extends PromoEvent {}

class AddPromo extends PromoEvent {
  final PromoRequestModel request;
  AddPromo(this.request);
}

class UpdatePromo extends PromoEvent {
  final int promoId;
  final PromoRequestModel request;
  UpdatePromo(this.promoId, this.request);
}

class DeletePromo extends PromoEvent {
  final int promoId;
  DeletePromo(this.promoId);
}
