import 'package:bloc/bloc.dart';
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

      final result = await stockRepository.getAllStock();

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
  }
}
