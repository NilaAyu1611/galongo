import 'dart:convert';

class TransactionRequestModel {
    final double? amount;
    final String? type;
    final String? description;

    TransactionRequestModel({
        this.amount,
        this.type,
        this.description,
    });

    factory TransactionRequestModel.fromJson(String str) => TransactionRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TransactionRequestModel.fromMap(Map<String, dynamic> json) => TransactionRequestModel(
        amount: json["amount"]?.toDouble(),
        type: json["type"],
        description: json["description"],
    );

    Map<String, dynamic> toMap() => {
        "amount": amount,
        "type": type,
        "description": description,
    };
}
