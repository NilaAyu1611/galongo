part of 'orders_bloc.dart';

@immutable
sealed class OrdersEvent {}

class CreateOrder extends OrdersEvent {
  final OrderRequestModel request;

  CreateOrder(this.request);
}

class ConfirmOrder extends OrdersEvent { final int id; ConfirmOrder(this.id); }
class LoadAllCustomerOrders extends OrdersEvent {} // For admin

class GetOrderHistory extends OrdersEvent {}

class LoadCustomerOrders extends OrdersEvent {}

class UpdateOrder extends OrdersEvent {
  final int orderId;
  final Map<String, dynamic> updatedData;

  UpdateOrder(this.orderId, this.updatedData);
}
