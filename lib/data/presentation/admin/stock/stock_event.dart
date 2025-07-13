part of 'stock_bloc.dart';


sealed class StockEvent {}


class LoadAllStock extends StockEvent {}

class AddStock extends StockEvent {
  final StockRequestModel request;

  AddStock({required this.request});
}