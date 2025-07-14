class TransactionSummary {
  final String? totalIn;
  final String? totalOut;
  final int? netBalance;

  TransactionSummary({this.totalIn, this.totalOut, this.netBalance});

  factory TransactionSummary.fromMap(Map<String, dynamic> json) => TransactionSummary(
        totalIn: json["total_in"],
        totalOut: json["total_out"],
        netBalance: json["net_balance"],
      );
}

// transaction_model.dart
class TransactionData {
  final int id;
  final int customerId;
  final double amount;
  final String type;
  final String description;
  final String createdAt;
  final String? customerName;

  TransactionData({
    required this.id,
    required this.customerId,
    required this.amount,
    required this.type,
    required this.description,
    required this.createdAt,
    required this.customerName,
  });

  factory TransactionData.fromMap(Map<String, dynamic> json) => TransactionData(
        id: json['id'],
        customerId: json['customer_id'],
        amount: double.tryParse(json['amount'].toString()) ?? 0.0,
        type: json['type'],
        description: json['description'],
        createdAt: json['created_at'],
        customerName: json['customer']?['user']?['name'],
      );
}
