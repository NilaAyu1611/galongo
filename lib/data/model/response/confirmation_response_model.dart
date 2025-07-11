import 'dart:convert';

class ConfirmationResponseModel {
    final int? statusCode;
    final String? message;
    final String? data;

    ConfirmationResponseModel({
        this.statusCode,
        this.message,
        this.data,
    });

    factory ConfirmationResponseModel.fromJson(String str) => ConfirmationResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ConfirmationResponseModel.fromMap(Map<String, dynamic> json) => ConfirmationResponseModel(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"],
    );

    Map<String, dynamic> toMap() => {
        "status_code": statusCode,
        "message": message,
        "data": data,
    };
}
