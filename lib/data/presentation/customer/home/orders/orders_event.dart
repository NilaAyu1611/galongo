part of 'orders_bloc.dart';

@immutable
sealed class OrdersEvent {}

class CreateOrder extends OrdersEvent {
  final OrderRequestModel request;

  CreateOrder(this.request);
}

class GetOrderHistory extends OrdersEvent {}