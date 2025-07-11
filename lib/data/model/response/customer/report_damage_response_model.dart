import 'dart:convert';

class ReportDamageResponseModel {
    final String? message;
    final int? statusCode;
    final String? data;

    ReportDamageResponseModel({
        this.message,
        this.statusCode,
        this.data,
    });

    factory ReportDamageResponseModel.fromJson(String str) => ReportDamageResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ReportDamageResponseModel.fromMap(Map<String, dynamic> json) => ReportDamageResponseModel(
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
