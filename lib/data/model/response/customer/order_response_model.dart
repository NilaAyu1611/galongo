import 'dart:convert';

class OrderResponseModel {
    final int? statusCode;
    final String? message;
    final List<Data>? data;

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
        data: json["data"] == null
            ? null
            : List<Data>.from(json["data"].map((x) => Data.fromMap(x))),
      );

    Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "data": data?.map((x) => x.toMap()).toList(),
      };
}

class Data {
    final int? id;
    final int? customerId;
    final int? stockId;
    final int? quantity;
    final String? status;
    final dynamic totalPrice;

    final Customer? customer;

    Data({
        this.id,
        this.customerId,
        this.stockId,
        this.quantity,
        this.status,
        this.totalPrice,
        this.customer,
    });

   

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        customerId: json["customer_id"],
        stockId: json["stock_id"],
        quantity: json["quantity"],
        status: json["status"],
        totalPrice: json["total_price"],
        customer:
            json["customer"] == null ? null : Customer.fromMap(json["customer"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "customer_id": customerId,
        "stock_id": stockId,
        "quantity": quantity,
        "status": status,
        "total_price": totalPrice,
        "customer": customer?.toMap(),
      };
}

class Customer {
  final int? id;
  final String? address;
  final String? phone;
  final User? user;

  Customer({
    this.id,
    this.address,
    this.phone,
    this.user,
  });

  factory Customer.fromMap(Map<String, dynamic> json) => Customer(
        id: json["id"],
        address: json["address"],
        phone: json["phone"],
        user: json["user"] == null ? null : User.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "address": address,
        "phone": phone,
        "user": user?.toMap(),
      };
}

class User {
  final int? id;
  final String? name;
  final String? username;

  User({
    this.id,
    this.name,
    this.username,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        username: json["username"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "username": username,
      };
}