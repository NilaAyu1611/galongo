part of 'orders_bloc.dart';

sealed class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersSuccess extends OrdersState {
  final List<Data> orderList;

  OrdersSuccess(this.orderList);
}

class OrdersLoadSuccess extends OrdersState {
  final List<Data> orders;
  OrdersLoadSuccess(this.orders);
}

// class OrderCreatedSuccess extends OrdersState {
//   final OrderResponseModel order;

//   OrderCreatedSuccess(this.order);
// }

class OrdersFailure extends OrdersState {
  final String message;

  OrdersFailure(this.message);
}