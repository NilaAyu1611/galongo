import 'dart:convert';

class PromoRequestModel {
    final String? title;
    final String? description;
    final int? discountPercentage;
    final DateTime? startDate;
    final DateTime? endDate;
    final List<int>? stockIds;

    PromoRequestModel({
        this.title,
        this.description,
        this.discountPercentage,
        this.startDate,
        this.endDate,
        this.stockIds,
    });

    factory PromoRequestModel.fromJson(String str) => PromoRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PromoRequestModel.fromMap(Map<String, dynamic> json) => PromoRequestModel(
        title: json["title"],
        description: json["description"],
        discountPercentage: json["discount_percentage"],
        startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
        endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        stockIds: json["stock_ids"] == null ? [] : List<int>.from(json["stock_ids"]!.map((x) => x)),
    );

    Map<String, dynamic> toMap() => {
        "title": title,
        "description": description,
        "discount_percentage": discountPercentage,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "stock_ids": stockIds == null ? [] : List<dynamic>.from(stockIds!.map((x) => x)),
    };
}
 