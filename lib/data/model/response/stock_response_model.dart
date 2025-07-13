import 'dart:convert';

class StockResponseModel {
  final int? statusCode;
  final String? message;
  final SingleStockData? data;

  StockResponseModel({
    this.statusCode,
    this.message,
    this.data,
  });

  factory StockResponseModel.fromJson(String str) =>
      StockResponseModel.fromMap(json.decode(str));

  factory StockResponseModel.fromMap(Map<String, dynamic> json) =>
      StockResponseModel(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null ? null : SingleStockData.fromMap(json["data"]),
      );
}

class SingleStockData {
  final int? id;
  final int? quantity;
  final int? price; 
  final String? image;

  SingleStockData({
    this.id,
    this.quantity,
    this.price,
    this.image,
  });

  factory SingleStockData.fromMap(Map<String, dynamic> json) => SingleStockData(
        id: json["id"],
        quantity: json["quantity"],
        price: double.tryParse(json["price"].toString())?.toInt(),
        image: json["image"],
      );
}
