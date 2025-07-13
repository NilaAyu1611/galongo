import 'package:bloc/bloc.dart';
import 'package:galongo/data/model/request/customer/order_request_model.dart';
import 'package:meta/meta.dart';
import 'package:galongo/data/repository/order_repository.dart';
import 'package:galongo/data/model/response/customer/order_response_model.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository repository;

  OrdersBloc(this.repository) : super(OrdersInitial()) {
    on<LoadCustomerOrders>((event, emit) async {
      emit(OrdersLoading());
      final result = await repository.getOrderHistory();
      result.fold(
        (error) => emit(OrdersFailure(error)),
        (orders) => emit(OrdersLoadSuccess(orders)),
      );
    });
  }
}
