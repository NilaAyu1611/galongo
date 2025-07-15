import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final int stockId;
  final int quantity;

  AddToCartEvent({required this.stockId, this.quantity = 1});

  @override
  List<Object?> get props => [stockId, quantity];
}

class LoadCartEvent extends CartEvent {}

class RemoveFromCartEvent extends CartEvent {
  final int cartItemId;

  RemoveFromCartEvent({required this.cartItemId});

  @override
  List<Object?> get props => [cartItemId];
}