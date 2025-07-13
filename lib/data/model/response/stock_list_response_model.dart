import 'dart:convert';
import 'stock_response_model.dart';

class StockListResponseModel {
  final int? statusCode;
  final String? message;
  final List<StockData> data;

  StockListResponseModel({
    this.statusCode,
    this.message,
    required this.data,
  });

  factory StockListResponseModel.fromJson(String str) =>
      StockListResponseModel.fromMap(json.decode(str));

  factory StockListResponseModel.fromMap(Map<String, dynamic> json) =>
      StockListResponseModel(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<StockData>.from(json["data"].map((x) => StockData.fromMap(x))),
      );
}

class StockData {
  final int? id;
  final int? quantity;
  final int? price;
  final String? image;

  StockData({
    this.id,
    this.quantity,
    this.price,
    this.image,
  });

  factory StockData.fromMap(Map<String, dynamic> json) => StockData(
        id: json["id"],
        quantity: json["quantity"],
        price: int.tryParse(json["price"].toString()),
        image: json["image"],
      );
}