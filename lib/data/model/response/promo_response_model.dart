import 'dart:convert';

class PromoResponseModel {
    final String? message;
    final int? statusCode;
    final String? data;

    PromoResponseModel({
        this.message,
        this.statusCode,
        this.data,
    });

    factory PromoResponseModel.fromJson(String str) => PromoResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PromoResponseModel.fromMap(Map<String, dynamic> json) => PromoResponseModel(
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
