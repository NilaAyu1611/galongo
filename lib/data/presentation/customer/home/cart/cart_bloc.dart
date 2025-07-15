// cart_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galongo/data/model/request/customer/cart_request_model.dart';
import 'package:galongo/data/model/response/customer/cart_response_model.dart';
import 'package:galongo/data/repository/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc(this.cartRepository) : super(CartInitial()) {
    on<AddToCartEvent>(_onAddToCart);
    on<LoadCartEvent>(_onLoadCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());

    final result = await cartRepository.addToCart(
      CartRequestModel(stockId: event.stockId, quantity: event.quantity),
    );

    result.fold(
      (failure) => emit(CartFailure(failure)),
      (success) => emit(CartActionSuccess(success.message ?? "Berhasil ditambahkan")),
    );
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());

    final result = await cartRepository.getCartItems();

    result.fold(
      (failure) => emit(CartFailure(failure)),
      (success) {
        final rawItems = success.data ?? [];

        try {
          final itemList = List<Map<String, dynamic>>.from(rawItems);
          final items = itemList.map((e) => CartItem.fromMap(e)).toList();

          final total = items.fold<int>(0, (sum, item) {
            final price = int.tryParse(item.stock['price'].toString()) ?? 0;
            return sum + (item.quantity * price);
          });

          emit(CartLoadSuccess(items: items, totalPrice: total));
        } catch (e) {
          emit(CartFailure("Gagal parsing data cart: $e"));
        }
      },
    );
  }

  Future<void> _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());

    final result = await cartRepository.removeFromCart(event.cartItemId);

    result.fold(
      (failure) => emit(CartFailure(failure)),
      (message) => emit(CartActionSuccess(message)),
    );
  }
}
