import 'dart:convert';

class CustomerRequestModel {
    final int? id;
    final int? userId;
    final String? address;
    final String? phone;
    final String? saldo;
    final String? latitude;
    final String? longitude;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    CustomerRequestModel({
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

    factory CustomerRequestModel.fromJson(String str) => CustomerRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CustomerRequestModel.fromMap(Map<String, dynamic> json) => CustomerRequestModel(
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
