import 'dart:convert';

class OrderRequestModel {
    final int? stockId;
    final int? quantity;
    final double? latitude;
    final double? longitude;

    OrderRequestModel({
        this.stockId,
        this.quantity,
        this.latitude,
        this.longitude,
    });

    factory OrderRequestModel.fromJson(String str) => OrderRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory OrderRequestModel.fromMap(Map<String, dynamic> json) => OrderRequestModel(
        stockId: json["stock_id"],
        quantity: json["quantity"],
        latitude: json["latitude"],
        longitude: json["longitude"],
    );

    Map<String, dynamic> toMap() => {
        "stock_id": stockId,
        "quantity": quantity,
        "latitude": latitude,
        "longitude": longitude,
    };
}
