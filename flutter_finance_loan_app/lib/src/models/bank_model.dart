class BankModel {
  final String id;
  final String name;
  final String code;
  final String logo;
  final double interestRate;
  final int maxLoanPeriod;
  final bool isActive;

  BankModel({
    required this.id,
    required this.name,
    required this.code,
    required this.logo,
    required this.interestRate,
    required this.maxLoanPeriod,
    required this.isActive,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      logo: json['logo'] ?? '',
      interestRate: (json['interestRate'] ?? 0.0).toDouble(),
      maxLoanPeriod: json['maxLoanPeriod'] ?? 12,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'logo': logo,
      'interestRate': interestRate,
      'maxLoanPeriod': maxLoanPeriod,
      'isActive': isActive,
    };
  }
}
