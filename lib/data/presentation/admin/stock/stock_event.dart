part of 'stock_bloc.dart';


sealed class StockEvent {}


class LoadAllStock extends StockEvent {}

class AddStock extends StockEvent {
  final StockRequestModel request;

  AddStock({required this.request});
}

class UpdateStock extends StockEvent {
  final int id;
  final StockRequestModel request;

  UpdateStock({required this.id, required this.request});
}


class DeleteStock extends StockEvent {
  final int id;
  DeleteStock(this.id);
}


