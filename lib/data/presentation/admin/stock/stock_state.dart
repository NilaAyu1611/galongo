part of 'stock_bloc.dart';


sealed class StockState {}

class StockInitial extends StockState {}

class StockLoading extends StockState {}

class StockLoadSuccess extends StockState {
  final List<StockData> stockList;

  StockLoadSuccess({required this.stockList});
}

class StockAddSuccess extends StockState {
  final String message;

  StockAddSuccess({required this.message});
}

class StockFailure extends StockState {
  final String message;

  StockFailure({required this.message});
}

// ✅ Tambahkan ini untuk update/delete success
class StockSuccess extends StockState {
  final String message;
  StockSuccess(this.message);
}

// ✅ Tambahkan ini untuk update/delete error
class StockError extends StockState {
  final String message;
  StockError(this.message);
}
