class LoanModel {
  final String id;
  final String userId;
  final String bankId;
  final String companyId;
  final double amount;
  final double interestRate;
  final int durationMonths;
  final double monthlyPayment;
  final double totalAmount;
  final String status;
  final DateTime requestDate;
  final DateTime? approvalDate;
  final DateTime? rejectionDate;
  final String? rejectionReason;
  final DateTime createdAt;

  LoanModel({
    required this.id,
    required this.userId,
    required this.bankId,
    required this.companyId,
    required this.amount,
    required this.interestRate,
    required this.durationMonths,
    required this.monthlyPayment,
    required this.totalAmount,
    required this.status,
    required this.requestDate,
    this.approvalDate,
    this.rejectionDate,
    this.rejectionReason,
    required this.createdAt,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      bankId: json['bankId'] ?? '',
      companyId: json['companyId'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      interestRate: (json['interestRate'] ?? 0.0).toDouble(),
      durationMonths: json['durationMonths'] ?? 12,
      monthlyPayment: (json['monthlyPayment'] ?? 0.0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      requestDate: DateTime.parse(json['requestDate'] ?? DateTime.now().toIso8601String()),
      approvalDate: json['approvalDate'] != null 
          ? DateTime.parse(json['approvalDate']) 
          : null,
      rejectionDate: json['rejectionDate'] != null 
          ? DateTime.parse(json['rejectionDate']) 
          : null,
      rejectionReason: json['rejectionReason'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'bankId': bankId,
      'companyId': companyId,
      'amount': amount,
      'interestRate': interestRate,
      'durationMonths': durationMonths,
      'monthlyPayment': monthlyPayment,
      'totalAmount': totalAmount,
      'status': status,
      'requestDate': requestDate.toIso8601String(),
      'approvalDate': approvalDate?.toIso8601String(),
      'rejectionDate': rejectionDate?.toIso8601String(),
      'rejectionReason': rejectionReason,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'processing':
        return 'Processing';
      case 'completed':
        return 'Completed';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'processing':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
