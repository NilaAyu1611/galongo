class TransactionSummary {
  final double totalIn;
  final double totalOut;
  final double netBalance;

  TransactionSummary({
    required this.totalIn,
    required this.totalOut,
    required this.netBalance,
  });

  factory TransactionSummary.fromMap(Map<String, dynamic> json) => TransactionSummary(
        totalIn: double.tryParse(json["total_in"].toString()) ?? 0.0,
        totalOut: double.tryParse(json["total_out"].toString()) ?? 0.0,
        netBalance: double.tryParse(json["net_balance"].toString()) ?? 0.0,
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
