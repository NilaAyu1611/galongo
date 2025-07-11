import 'dart:convert';

class CartResponseModel {
    final String? message;
    final int? statusCode;
    final String? data;

    CartResponseModel({
        this.message,
        this.statusCode,
        this.data,
    });

    factory CartResponseModel.fromJson(String str) => CartResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CartResponseModel.fromMap(Map<String, dynamic> json) => CartResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"],
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "status_code": statusCode,
        "data": data,
    };
}
