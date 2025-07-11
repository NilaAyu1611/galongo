import 'dart:convert';

class StockRequestModel {
    final int? quantity;
    final int? price;
    final String? image;

    StockRequestModel({
        this.quantity,
        this.price,
        this.image,
    });

    factory StockRequestModel.fromJson(String str) => StockRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory StockRequestModel.fromMap(Map<String, dynamic> json) => StockRequestModel(
        quantity: json["quantity"],
        price: json["price"],
        image: json["image"],
    );

    Map<String, dynamic> toMap() => {
        "quantity": quantity,
        "price": price,
        "image": image,
    };
}
