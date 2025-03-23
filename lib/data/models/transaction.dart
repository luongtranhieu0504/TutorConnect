class TransactionModel {
  final String id;
  final String userId;
  final int amount;
  final String method; // momo, vnpay, zalopay
  final String status; // pending, completed, failed
  final DateTime createdAt;
  final String? sessionId;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.method,
    required this.status,
    required this.createdAt,
    this.sessionId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['user_id'],
      amount: json['amount'],
      method: json['method'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      sessionId: json['session_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'amount': amount,
    'method': method,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'session_id': sessionId,
  };
}
