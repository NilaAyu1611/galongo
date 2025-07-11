import 'dart:convert';

class ReviewRequestModel {
    final int? orderId;
    final int? rating;
    final String? comment;

    ReviewRequestModel({
        this.orderId,
        this.rating,
        this.comment,
    });

    factory ReviewRequestModel.fromJson(String str) => ReviewRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ReviewRequestModel.fromMap(Map<String, dynamic> json) => ReviewRequestModel(
        orderId: json["order_id"],
        rating: json["rating"],
        comment: json["comment"],
    );

    Map<String, dynamic> toMap() => {
        "order_id": orderId,
        "rating": rating,
        "comment": comment,
    };
}
