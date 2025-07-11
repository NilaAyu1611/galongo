import 'dart:convert';

class TransactionResponseModel {
    final String? message;
    final int? statusCode;
    final String? data;

    TransactionResponseModel({
        this.message,
        this.statusCode,
        this.data,
    });

    factory TransactionResponseModel.fromJson(String str) => TransactionResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TransactionResponseModel.fromMap(Map<String, dynamic> json) => TransactionResponseModel(
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
