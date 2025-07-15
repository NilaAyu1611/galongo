import 'package:equatable/equatable.dart';
import 'package:galongo/data/model/response/customer/cart_response_model.dart';

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoadSuccess extends CartState {
  final List<CartItem> items;
  final int totalPrice;

  CartLoadSuccess({required this.items, required this.totalPrice});

  @override
  List<Object?> get props => [items, totalPrice];
}

class CartActionSuccess extends CartState {
  final String message;

  CartActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CartFailure extends CartState {
  final String message;

  CartFailure(this.message);

  @override
  List<Object?> get props => [message];
}