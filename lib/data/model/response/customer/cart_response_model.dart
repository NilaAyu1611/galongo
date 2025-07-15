import 'dart:convert';

class CartResponseModel {
    final String? message;
    final int? statusCode;
    final List<dynamic>? data;

    CartResponseModel({
        this.message,
        this.statusCode,
        this.data,
    });

     factory CartResponseModel.fromMap(Map<String, dynamic> json) => CartResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"],
      );


    
}


class CartItem {
  final int id;
  final int quantity;
  final Map<String, dynamic> stock;

  CartItem({
    required this.id,
    required this.quantity,
    required this.stock,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      quantity: map['quantity'],
      stock: Map<String, dynamic>.from(map['stock'] ?? {}),
    );
  }

  int get price {
    return (stock['price'] as int?) ?? 0;
  }

  String get name {
    return (stock['name'] as String?) ?? 'Produk';
  }

}
