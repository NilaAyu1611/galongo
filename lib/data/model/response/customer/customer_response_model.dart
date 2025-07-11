import 'dart:convert';

class CustomerResponseModel {
    final int? statusCode;
    final String? message;
    final Data? data;

    CustomerResponseModel({
        this.statusCode,
        this.message,
        this.data,
    });

    factory CustomerResponseModel.fromJson(String str) => CustomerResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CustomerResponseModel.fromMap(Map<String, dynamic> json) => CustomerResponseModel(
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
    final User? user;
    final Customer? customer;

    Data({
        this.user,
        this.customer,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        customer: json["customer"] == null ? null : Customer.fromMap(json["customer"]),
    );

    Map<String, dynamic> toMap() => {
        "user": user?.toMap(),
        "customer": customer?.toMap(),
    };
}

class Customer {
    final int? id;
    final int? userId;
    final String? address;
    final String? phone;
    final String? saldo;
    final String? latitude;
    final String? longitude;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Customer({
        this.id,
        this.userId,
        this.address,
        this.phone,
        this.saldo,
        this.latitude,
        this.longitude,
        this.createdAt,
        this.updatedAt,
    });

    factory Customer.fromJson(String str) => Customer.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Customer.fromMap(Map<String, dynamic> json) => Customer(
        id: json["id"],
        userId: json["user_id"],
        address: json["address"],
        phone: json["phone"],
        saldo: json["saldo"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "address": address,
        "phone": phone,
        "saldo": saldo,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class User {
    final int? id;
    final String? name;
    final String? username;
    final String? email;
    final DateTime? emailVerifiedAt;
    final String? phone;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? roleId;

    User({
        this.id,
        this.name,
        this.username,
        this.email,
        this.emailVerifiedAt,
        this.phone,
        this.createdAt,
        this.updatedAt,
        this.roleId,
    });

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
        phone: json["phone"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        roleId: json["role_id"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "phone": phone,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "role_id": roleId,
    };
}
