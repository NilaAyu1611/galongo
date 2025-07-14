import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:galongo/data/model/response/stock_list_response_model.dart';
import 'package:meta/meta.dart';
import 'package:galongo/data/model/request/admin/stock_request_model.dart';
import 'package:galongo/data/model/response/stock_response_model.dart';
import 'package:galongo/data/repository/stock_repository.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final StockRepository stockRepository;

  StockBloc({required this.stockRepository}) : super(StockInitial()) {
    // GET ALL STOCK
    on<LoadAllStock>((event, emit) async {
      emit(StockLoading());

      final role = await _getRole();
      final result = role == "admin"
          ? await stockRepository.getAllStock()
          : await stockRepository.getStockForCustomer();

      result.fold(
        (error) => emit(StockFailure(message: error)),
        (stockList) => emit(StockLoadSuccess(stockList: stockList)),
      );
    });

   

    // ADD STOCK
    on<AddStock>((event, emit) async {
      emit(StockLoading());

      final result = await stockRepository.addStock(event.request);

      result.fold(
        (error) => emit(StockFailure(message: error)),
        (response) => emit(StockAddSuccess(message: response.message ?? "Stok berhasil ditambahkan")),
      );
    });
   

    // on<UpdateStock>((event, emit) async {
    //   emit(StockLoading());

    //   final result = await stockRepository.updateStock(event.id, event.request);

    //   result.fold(
    //     (error) => emit(StockError(error)),
    //     (updatedStock) async {
    //       emit(StockSuccess("Stock berhasil diperbarui"));
    //       add(LoadAllStock()); // reload list
    //     },
    //   );
    // });

    on<UpdateStock>((event, emit) async {
      emit(StockLoading());

      final result = await stockRepository.updateStock(event.id, event.request);

      result.fold(
        (error) => emit(StockError(error)),
        (message) async {
          emit(StockSuccess(message));
          add(LoadAllStock());
        },
      );
    });


    on<DeleteStock>((event, emit) async {
      emit(StockLoading());

      final result = await stockRepository.deleteStock(event.id);

      result.fold(
        (error) => emit(StockError(error)),
        (message) async {
          emit(StockSuccess(message));
          add(LoadAllStock()); // reload list
        },
      );
    });

  }

  Future<String> _getRole() async {
    const storage = FlutterSecureStorage();
    final role = await storage.read(key: "userRole");
    return role ?? "customer";
  }
}
