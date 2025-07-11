import 'dart:convert';

class ReviewResponseModel {
    final String? message;
    final String? data;
    final int? statusCode;

    ReviewResponseModel({
        this.message,
        this.data,
        this.statusCode,
    });

    factory ReviewResponseModel.fromJson(String str) => ReviewResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ReviewResponseModel.fromMap(Map<String, dynamic> json) => ReviewResponseModel(
        message: json["message"],
        data: json["data"],
        statusCode: json["status_code"],
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data,
        "status_code": statusCode,
    };
}
