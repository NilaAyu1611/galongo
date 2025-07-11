import 'dart:convert';

class CartRequestModel {
    final int? stockId;
    final int? quantity;

    CartRequestModel({
        this.stockId,
        this.quantity,
    });

    factory CartRequestModel.fromJson(String str) => CartRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CartRequestModel.fromMap(Map<String, dynamic> json) => CartRequestModel(
        stockId: json["stock_id"],
        quantity: json["quantity"],
    );

    Map<String, dynamic> toMap() => {
        "stock_id": stockId,
        "quantity": quantity,
    };
}
