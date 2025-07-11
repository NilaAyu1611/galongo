import 'dart:convert';

class StockResponseModel {
    final int? statusCode;
    final String? message;
    final Data? data;

    StockResponseModel({
        this.statusCode,
        this.message,
        this.data,
    });

    factory StockResponseModel.fromJson(String str) => StockResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory StockResponseModel.fromMap(Map<String, dynamic> json) => StockResponseModel(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "data": data?.toMap(),
    };
}

class Data {
    final int? id;
    final int? quantity;
    final int? price;

    Data({
        this.id,
        this.quantity,
        this.price,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        quantity: json["quantity"],
        price: json["price"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "quantity": quantity,
        "price": price,
    };
}
