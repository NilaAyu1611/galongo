import 'dart:convert';
import 'stock_response_model.dart';

class StockListResponseModel {
  final int? statusCode;
  final String? message;
  final List<StckData>? data;

  StockListResponseModel({this.statusCode, this.message, this.data});

  factory StockListResponseModel.fromJson(String str) =>
      StockListResponseModel.fromMap(json.decode(str));

  factory StockListResponseModel.fromMap(Map<String, dynamic> json) =>
      StockListResponseModel(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<StockData>.from(
                json["data"].map((x) => StockData.fromMap(x))),
      );
}