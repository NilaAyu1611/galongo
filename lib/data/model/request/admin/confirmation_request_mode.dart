import 'dart:convert';

class ConfirmationRequestModel {
    final int? orderId;
    final DateTime? confirmedAt;
    final String? notes;

    ConfirmationRequestModel({
        this.orderId,
        this.confirmedAt,
        this.notes,
    });

    factory ConfirmationRequestModel.fromJson(String str) => ConfirmationRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ConfirmationRequestModel.fromMap(Map<String, dynamic> json) => ConfirmationRequestModel(
        orderId: json["order_id"],
        confirmedAt: json["confirmed_at"] == null ? null : DateTime.parse(json["confirmed_at"]),
        notes: json["notes"],
    );

    Map<String, dynamic> toMap() => {
        "order_id": orderId,
        "confirmed_at": confirmedAt?.toIso8601String(),
        "notes": notes,
    };
}
