import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/loan_provider.dart';
import '../../utils/app_localizations.dart';
import '../../constants/theme_constants.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final loanProvider = Provider.of<LoanProvider>(context, listen: false);

    if (authProvider.user != null && authProvider.token != null) {
      await loanProvider.fetchUserLoans(
        authProvider.user!.id,
        authProvider.token!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final loanProvider = Provider.of<LoanProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.lg),
            margin: const EdgeInsets.all(AppSizes.lg),
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
                        Icons.history_outlined,
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
                            'Transaction History',
                            style: AppTextStyles.headline3.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'View all your loan transactions',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSizes.lg),
                
                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        'Total Loans',
                        loanProvider.loans.length.toString(),
                        Icons.receipt_long_outlined,
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: _buildStatItem(
                        'Total Amount',
                        '\$${_getTotalAmount(loanProvider.loans)}',
                        Icons.attach_money_outlined,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Transactions List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadTransactions,
              color: AppColors.primary,
              child: loanProvider.isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: AppSizes.md),
                          Text(
                            'Loading transactions...',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : loanProvider.loans.isEmpty
                      ? _buildEmptyState(localizations)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                          itemCount: loanProvider.loans.length,
                          itemBuilder: (context, index) {
                            final loan = loanProvider.loans[index];
                            final bank = loanProvider.banks.firstWhere(
                              (b) => b.id == loan.bankId,
                              orElse: () => loanProvider.banks.first,
                            );
                            final company = loanProvider.companies.firstWhere(
                              (c) => c.id == loan.companyId,
                              orElse: () => loanProvider.companies.first,
                            );

                            return Container(
                              margin: const EdgeInsets.only(bottom: AppSizes.md),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                                boxShadow: [AppShadows.cardShadow],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(AppSizes.lg),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(loan.status).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                                  ),
                                  child: Icon(
                                    _getStatusIcon(loan.status),
                                    color: _getStatusColor(loan.status),
                                    size: AppSizes.iconMedium,
                                  ),
                                ),
                                title: Text(
                                  '${bank.name} - ${company.name}',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: AppSizes.xs),
                                    Text(
                                      '\$${loan.amount.toStringAsFixed(0)} • ${loan.durationMonths} months',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: AppSizes.xs),
                                    Text(
                                      _formatDate(loan.requestDate),
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.md,
                                    vertical: AppSizes.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(loan.status).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                                    border: Border.all(
                                      color: _getStatusColor(loan.status).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    _getStatusText(loan.status),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: _getStatusColor(loan.status),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                onTap: () => _showLoanDetails(context, loan, bank, company),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: AppSizes.iconMedium,
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations localizations) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.lg),
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [AppShadows.cardShadow],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.textLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 40,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'No Transactions Found',
            style: AppTextStyles.headline4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'You haven\'t made any loan requests yet.\nStart by requesting your first loan!',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.xl),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to loan request screen
            },
            icon: Icon(Icons.add),
            label: Text('Request Loan'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.xl,
                vertical: AppSizes.md,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle_outline;
      case 'pending':
        return Icons.pending_outlined;
      case 'rejected':
        return Icons.cancel_outlined;
      case 'processing':
        return Icons.hourglass_empty_outlined;
      case 'completed':
        return Icons.done_all_outlined;
      default:
        return Icons.help_outline;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppColors.accent;
      case 'pending':
        return AppColors.warning;
      case 'rejected':
        return AppColors.error;
      case 'processing':
        return AppColors.primary;
      case 'completed':
        return AppColors.accent;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Approved';
      case 'pending':
        return 'Pending';
      case 'rejected':
        return 'Rejected';
      case 'processing':
        return 'Processing';
      case 'completed':
        return 'Completed';
      default:
        return 'Unknown';
    }
  }

  String _getTotalAmount(List loans) {
    double total = 0;
    for (var loan in loans) {
      total += loan.amount;
    }
    return total.toStringAsFixed(0);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showLoanDetails(
    BuildContext context,
    loan,
    bank,
    company,
  ) {
    final localizations = AppLocalizations.of(context)!;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.radiusLarge),
              topRight: Radius.circular(AppSizes.radiusLarge),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                const SizedBox(height: AppSizes.lg),
                
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.md),
                      decoration: BoxDecoration(
                        color: _getStatusColor(loan.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                      ),
                      child: Icon(
                        _getStatusIcon(loan.status),
                        color: _getStatusColor(loan.status),
                        size: AppSizes.iconLarge,
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Loan Details',
                            style: AppTextStyles.headline4.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Transaction ID: ${loan.id}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md,
                        vertical: AppSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(loan.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                        border: Border.all(
                          color: _getStatusColor(loan.status).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _getStatusText(loan.status),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: _getStatusColor(loan.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSizes.xl),
                
                // Details
                _buildDetailRow('Bank', bank.name, Icons.account_balance_outlined),
                _buildDetailRow('Company', company.name, Icons.business_outlined),
                _buildDetailRow('Amount', '\$${loan.amount.toStringAsFixed(2)}', Icons.attach_money_outlined),
                _buildDetailRow('Duration', '${loan.durationMonths} months', Icons.schedule_outlined),
                _buildDetailRow('Request Date', _formatDate(loan.requestDate), Icons.calendar_today_outlined),
                
                if (loan.rejectionReason != null) ...[
                  const SizedBox(height: AppSizes.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                      border: Border.all(
                        color: AppColors.error.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                              size: AppSizes.iconMedium,
                            ),
                            const SizedBox(width: AppSizes.sm),
                            Text(
                              'Rejection Reason',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          loan.rejectionReason!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: AppSizes.xl),
                
                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.textSecondary,
            size: AppSizes.iconMedium,
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
