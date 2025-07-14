import 'package:bloc/bloc.dart';
import 'package:galongo/data/model/request/customer/order_request_model.dart';
import 'package:meta/meta.dart';
import 'package:galongo/data/model/response/customer/order_response_model.dart';

import '../../../../repository/order_repository.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository orderRepository;

  OrdersBloc({required this.orderRepository}) : super(OrdersInitial()) { 

   on<GetOrderHistory>((event, emit) async {
    emit(OrdersLoading());
    final result = await orderRepository.getOrderHistory();
    result.fold(
      (l) => emit(OrdersFailure(l)),
      (r) => emit(OrdersLoadSuccess(r)),
    );
  });

  on<ConfirmOrder>((event, emit) async {
    emit(OrdersLoading());
    final result = await orderRepository.confirmOrderReceived(event.id);
    result.fold(
      (l) => emit(OrdersFailure(l)),
      (r) => add(GetOrderHistory()), // reload after confirm
    );
  });

  on<LoadAllCustomerOrders>((event, emit) async {
    emit(OrdersLoading());
    final result = await orderRepository.getAllCustomerOrders();
    result.fold(
      (l) => emit(OrdersFailure(l)),
      (r) => emit(OrdersLoadSuccess(r)),
    );
  });

  on<UpdateOrder>((event, emit) async {
  emit(OrdersLoading());
  final result = await orderRepository.updateOrderByAdmin(event.orderId, event.updatedData);
  result.fold(
    (err) => emit(OrdersFailure(err)),
    (_) => add(LoadAllCustomerOrders()),
  );
});
  
  }
}
