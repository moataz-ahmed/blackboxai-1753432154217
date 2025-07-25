class CreditLimitModel {
  final String id;
  final String userId;
  final String bankId;
  final String companyId;
  final double totalLimit;
  final double usedLimit;
  final double availableLimit;
  final DateTime createdAt;
  final DateTime updatedAt;

  CreditLimitModel({
    required this.id,
    required this.userId,
    required this.bankId,
    required this.companyId,
    required this.totalLimit,
    required this.usedLimit,
    required this.availableLimit,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CreditLimitModel.fromJson(Map<String, dynamic> json) {
    return CreditLimitModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      bankId: json['bankId'] ?? '',
      companyId: json['companyId'] ?? '',
      totalLimit: (json['totalLimit'] ?? 0.0).toDouble(),
      usedLimit: (json['usedLimit'] ?? 0.0).toDouble(),
      availableLimit: (json['availableLimit'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'bankId': bankId,
      'companyId': companyId,
      'totalLimit': totalLimit,
      'usedLimit': usedLimit,
      'availableLimit': availableLimit,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
