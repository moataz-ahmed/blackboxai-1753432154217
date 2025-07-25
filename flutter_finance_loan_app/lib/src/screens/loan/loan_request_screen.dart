import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/loan_provider.dart';
import '../../utils/app_localizations.dart';
import '../../constants/theme_constants.dart';

class LoanRequestScreen extends StatefulWidget {
  const LoanRequestScreen({super.key});

  @override
  State<LoanRequestScreen> createState() => _LoanRequestScreenState();
}

class _LoanRequestScreenState extends State<LoanRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String? _selectedBankId;
  String? _selectedCompanyId;
  int _durationMonths = 12;

  @override
  void initState() {
    super.initState();
    final loanProvider = Provider.of<LoanProvider>(context, listen: false);
    if (loanProvider.banks.isEmpty) {
      loanProvider.fetchBanks();
    }
    if (loanProvider.companies.isEmpty) {
      loanProvider.fetchCompanies();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submitLoanRequest() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final loanProvider = Provider.of<LoanProvider>(context, listen: false);

    final amount = double.parse(_amountController.text);
    final availableCredit = loanProvider.getAvailableCredit(
      _selectedBankId!,
      _selectedCompanyId!,
    );

    if (amount > availableCredit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Amount exceeds available credit limit of \$${availableCredit.toStringAsFixed(2)}',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await loanProvider.submitLoanRequest(
      userId: authProvider.user!.id,
      bankId: _selectedBankId!,
      companyId: _selectedCompanyId!,
      amount: amount,
      durationMonths: _durationMonths,
      token: authProvider.token!,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Loan request submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      _formKey.currentState!.reset();
      _amountController.clear();
      setState(() {
        _selectedBankId = null;
        _selectedCompanyId = null;
        _durationMonths = 12;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final loanProvider = Provider.of<LoanProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: loanProvider.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppSizes.md),
                  Text(
                    'Loading loan options...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.lg),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                      boxShadow: [AppShadows.cardShadow],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSizes.md),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                              ),
                              child: Icon(
                                Icons.request_quote_outlined,
                                color: Colors.white,
                                size: AppSizes.iconLarge,
                              ),
                            ),
                            const SizedBox(width: AppSizes.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Loan Request',
                                    style: AppTextStyles.headline3.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Apply for a new loan',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.xl),
                  
                  // Form Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.lg),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                      boxShadow: [AppShadows.cardShadow],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Loan Details',
                            style: AppTextStyles.headline4.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSizes.lg),
                          
                          // Bank Selection
                          Text(
                            'Select Bank',
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSizes.sm),
                          DropdownButtonFormField<String>(
                            value: _selectedBankId,
                            decoration: InputDecoration(
                              hintText: 'Choose your preferred bank',
                              prefixIcon: Icon(
                                Icons.account_balance_outlined,
                                color: AppColors.textSecondary,
                              ),
                              filled: true,
                              fillColor: AppColors.background,
                            ),
                            items: loanProvider.banks
                                .where((bank) => bank.isActive)
                                .map((bank) => DropdownMenuItem(
                                      value: bank.id,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundImage: NetworkImage(bank.logo),
                                            backgroundColor: AppColors.background,
                                          ),
                                          const SizedBox(width: AppSizes.md),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  bank.name,
                                                  style: AppTextStyles.bodyMedium.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  '${bank.interestRate}% interest rate',
                                                  style: AppTextStyles.bodySmall.copyWith(
                                                    color: AppColors.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBankId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a bank';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: AppSizes.lg),
                          
                          // Company Selection
                          Text(
                            'Select Company',
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSizes.sm),
                          DropdownButtonFormField<String>(
                            value: _selectedCompanyId,
                            decoration: InputDecoration(
                              hintText: 'Choose your company',
                              prefixIcon: Icon(
                                Icons.business_outlined,
                                color: AppColors.textSecondary,
                              ),
                              filled: true,
                              fillColor: AppColors.background,
                            ),
                            items: loanProvider.companies
                                .where((company) => company.isActive)
                                .map((company) => DropdownMenuItem(
                                      value: company.id,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundImage: NetworkImage(company.logo),
                                            backgroundColor: AppColors.background,
                                          ),
                                          const SizedBox(width: AppSizes.md),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  company.name,
                                                  style: AppTextStyles.bodyMedium.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  company.category,
                                                  style: AppTextStyles.bodySmall.copyWith(
                                                    color: AppColors.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCompanyId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a company';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: AppSizes.lg),
                          
                          // Loan Amount
                          Text(
                            'Loan Amount',
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSizes.sm),
                          TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            style: AppTextStyles.bodyLarge,
                            decoration: InputDecoration(
                              hintText: 'Enter loan amount',
                              prefixIcon: Icon(
                                Icons.attach_money_outlined,
                                color: AppColors.textSecondary,
                              ),
                              prefixText: '\$ ',
                              filled: true,
                              fillColor: AppColors.background,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter loan amount';
                              }
                              final amount = double.tryParse(value);
                              if (amount == null || amount <= 0) {
                                return 'Please enter a valid amount';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: AppSizes.lg),
                          
                          // Duration
                          Text(
                            'Loan Duration',
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSizes.sm),
                          DropdownButtonFormField<int>(
                            value: _durationMonths,
                            decoration: InputDecoration(
                              hintText: 'Select loan duration',
                              prefixIcon: Icon(
                                Icons.schedule_outlined,
                                color: AppColors.textSecondary,
                              ),
                              filled: true,
                              fillColor: AppColors.background,
                            ),
                            items: [6, 12, 18, 24, 36, 48]
                                .map((months) => DropdownMenuItem(
                                      value: months,
                                      child: Text(
                                        '$months months',
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _durationMonths = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.lg),
                  
                  // Available Credit Card
                  if (_selectedBankId != null && _selectedCompanyId != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSizes.lg),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.credit_score_outlined,
                                color: AppColors.accent,
                                size: AppSizes.iconMedium,
                              ),
                              const SizedBox(width: AppSizes.sm),
                              Text(
                                'Available Credit',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.md),
                          Text(
                            '\$${loanProvider.getAvailableCredit(_selectedBankId!, _selectedCompanyId!).toStringAsFixed(0)}',
                            style: AppTextStyles.headline2.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSizes.sm),
                          Text(
                            'This is your maximum available credit limit',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),
                  ],
                  
                  // Submit Button
                  Container(
                    width: double.infinity,
                    height: AppSizes.buttonHeightLarge,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _submitLoanRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                        ),
                      ),
                      icon: Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        localizations.translate('submit_request'),
                        style: AppTextStyles.buttonLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.lg),
                  
                  // Info Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.lg),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.primary,
                              size: AppSizes.iconMedium,
                            ),
                            const SizedBox(width: AppSizes.sm),
                            Text(
                              'Important Information',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.md),
                        Text(
                          '• Loan approval is subject to bank verification\n'
                          '• Interest rates may vary based on your credit score\n'
                          '• Processing time is typically 2-3 business days\n'
                          '• All loan terms are subject to bank policies',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
