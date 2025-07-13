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
