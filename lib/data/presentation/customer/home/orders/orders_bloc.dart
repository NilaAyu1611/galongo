import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:galongo/data/model/request/customer/order_request_model.dart';
import 'package:galongo/data/model/response/customer/order_response_model.dart';
import 'package:galongo/data/repository/order_repository.dart';
import 'package:meta/meta.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository orderRepository;

  OrdersBloc(this.orderRepository) : super(OrdersInitial()) {
    on<CreateOrder>((event, emit) async {
      emit(OrdersLoading());
      final result = await orderRepository.createOrder(event.request);

      result.fold(
        (error) => emit(OrdersFailure(error)),
        (data) => emit(OrderCreatedSuccess(data)),
      );
    });

    on<GetOrderHistory>((event, emit) async {
      emit(OrdersLoading());
      final result = await orderRepository.getOrderHistory();

      result.fold(
        (error) => emit(OrdersFailure(error)),
        (orders) => emit(OrdersSuccess(orders)),
      );
    });
  }
}
