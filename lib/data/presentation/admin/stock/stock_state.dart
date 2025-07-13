part of 'stock_bloc.dart';


sealed class StockState {}

final class StockInitial extends StockState {}


final class StockLoading extends StockState {}

final class StockLoadSuccess extends StockState {
  final List<Data> stockList;

  StockLoadSuccess({required this.stockList});
}

final class StockAddSuccess extends StockState {
  final String message;

  StockAddSuccess({required this.message});
}

final class StockFailure extends StockState {
  final String message;

  StockFailure({required this.message});
}