import 'dart:convert';

class OrderResponseModel {
    final int? statusCode;
    final String? message;
    final Data? data;

    OrderResponseModel({
        this.statusCode,
        this.message,
        this.data,
    });

    factory OrderResponseModel.fromJson(String str) => OrderResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory OrderResponseModel.fromMap(Map<String, dynamic> json) => OrderResponseModel(
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
    final int? customerId;
    final int? stockId;
    final int? quantity;
    final String? status;
    final int? totalPrice;

    Data({
        this.id,
        this.customerId,
        this.stockId,
        this.quantity,
        this.status,
        this.totalPrice,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        customerId: json["customer_id"],
        stockId: json["stock_id"],
        quantity: json["quantity"],
        status: json["status"],
        totalPrice: json["total_price"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "customer_id": customerId,
        "stock_id": stockId,
        "quantity": quantity,
        "status": status,
        "total_price": totalPrice,
    };
}
