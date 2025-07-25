import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/loan_model.dart';
import '../models/bank_model.dart';
import '../models/company_model.dart';
import '../models/credit_limit_model.dart';

class LoanProvider extends ChangeNotifier {
  List<LoanModel> _loans = [];
  List<BankModel> _banks = [];
  List<CompanyModel> _companies = [];
  List<CreditLimitModel> _creditLimits = [];
  bool _isLoading = false;
  String? _error;

  List<LoanModel> get loans => _loans;
  List<BankModel> get banks => _banks;
  List<CompanyModel> get companies => _companies;
  List<CreditLimitModel> get creditLimits => _creditLimits;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBanks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://api.finance-loan.com/banks'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _banks = data.map((json) => BankModel.fromJson(json)).toList();
      }
    } catch (e) {
      _error = 'Failed to fetch banks';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCompanies() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://api.finance-loan.com/companies'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _companies = data.map((json) => CompanyModel.fromJson(json)).toList();
      }
    } catch (e) {
      _error = 'Failed to fetch companies';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserLoans(String userId, String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://api.finance-loan.com/loans/user/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _loans = data.map((json) => LoanModel.fromJson(json)).toList();
      }
    } catch (e) {
      _error = 'Failed to fetch loans';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCreditLimits(String userId, String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://api.finance-loan.com/credit-limits/user/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _creditLimits = data.map((json) => CreditLimitModel.fromJson(json)).toList();
      }
    } catch (e) {
      _error = 'Failed to fetch credit limits';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitLoanRequest({
    required String userId,
    required String bankId,
    required String companyId,
    required double amount,
    required int durationMonths,
    required String token,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://api.finance-loan.com/loans'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'userId': userId,
          'bankId': bankId,
          'companyId': companyId,
          'amount': amount,
          'durationMonths': durationMonths,
        }),
      );

      if (response.statusCode == 201) {
        await fetchUserLoans(userId, token);
        await fetchCreditLimits(userId, token);
        return true;
      } else {
        final errorData = json.decode(response.body);
        _error = errorData['message'] ?? 'Failed to submit loan request';
        return false;
      }
    } catch (e) {
      _error = 'Network error occurred';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  double getAvailableCredit(String bankId, String companyId) {
    final creditLimit = _creditLimits.firstWhere(
      (limit) => limit.bankId == bankId && limit.companyId == companyId,
      orElse: () => CreditLimitModel(
        id: '',
        userId: '',
        bankId: bankId,
        companyId: companyId,
        totalLimit: 0,
        usedLimit: 0,
        availableLimit: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    return creditLimit.availableLimit;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
