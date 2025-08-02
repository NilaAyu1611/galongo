import 'dart:convert';

class DashboardResponseModel {
  final String? status;
  final DashboardData? data;

  DashboardResponseModel({
    this.status,
    this.data,
  });

  // factory DashboardResponseModel.fromJson(String str) =>
  //     DashboardResponseModel.fromMap(json.decode(str));

  // String toJson() => json.encode(toMap());

  factory DashboardResponseModel.fromMap(Map<String, dynamic> json) =>
      DashboardResponseModel(
        status: json["status"],
        data:
            json["data"] == null ? null : DashboardData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "data": data?.toMap(),
      };
}

class DashboardData {
  final int? totalOrder;
  final int? pending;
  final int? confirmed;
  final int? delivered;
  final int? received;
  final double? averageRating;

  DashboardData({
    this.totalOrder,
    this.pending,
    this.confirmed,
    this.delivered,
    this.received,
    this.averageRating,
  });

  // factory DashboardData.fromJson(String str) =>
  //     DashboardData.fromMap(json.decode(str));

  // String toJson() => json.encode(toMap());

  factory DashboardData.fromMap(Map<String, dynamic> json) => DashboardData(
        totalOrder: json["total_order"] ?? 0,
        pending: json["pending"] ?? 0,
        confirmed: json["confirmed"] ?? 0,
        delivered: json["delivered"] ?? 0,
        received: json["received"] ?? 0,
        averageRating: (json["average_rating"] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toMap() => {
        "total_order": totalOrder,
        "pending": pending,
        "confirmed": confirmed,
        "deliverd": delivered,
        "received": received,
        "average_rating": averageRating,
      };
}
