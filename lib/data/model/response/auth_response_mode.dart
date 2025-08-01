import 'dart:convert';

class AuthResponseModel {
    final int? statusCode;
    final String? message;
    final Data? data;

    AuthResponseModel({
        this.statusCode,
        this.message,
        this.data,
    });

    factory AuthResponseModel.fromJson(String str) => AuthResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AuthResponseModel.fromMap(Map<String, dynamic> json) => AuthResponseModel(
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
    final String? name;
    final String? username;
    final String? email;
    final String? phone;
    final String? role;
    final String? token;

    Data({
        this.id,
        this.name,
        this.username,
        this.email,
        this.phone,
        this.role,
        this.token,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        role: json["role"],
         token: json["token"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "phone": phone,
        "role": role,
        "token": token,
    };
}
