import 'dart:convert';

class ReportDamageRequestModel {
    final int? orderId;
    final String? description;
    final String? photo;

    ReportDamageRequestModel({
        this.orderId,
        this.description,
        this.photo,
    });

    factory ReportDamageRequestModel.fromJson(String str) => ReportDamageRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ReportDamageRequestModel.fromMap(Map<String, dynamic> json) => ReportDamageRequestModel(
        orderId: json["order_id"],
        description: json["description"],
        photo: json["photo"],
    );

    Map<String, dynamic> toMap() => {
        "order_id": orderId,
        "description": description,
        "photo": photo,
    };
}
