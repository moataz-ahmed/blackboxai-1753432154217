import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/loan_provider.dart';
import '../../providers/language_provider.dart';
import '../../utils/app_localizations.dart';
import '../../constants/theme_constants.dart';
import '../loan/loan_request_screen.dart';
import '../loan/transaction_history_screen.dart';
import '../profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final loanProvider = Provider.of<LoanProvider>(context, listen: false);

    if (authProvider.user != null && authProvider.token != null) {
      await loanProvider.fetchBanks();
      await loanProvider.fetchCompanies();
      await loanProvider.fetchUserLoans(authProvider.user!.id, authProvider.token!);
      await loanProvider.fetchCreditLimits(authProvider.user!.id, authProvider.token!);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);

    final List<Widget> screens = [
      const DashboardHome(),
      const LoanRequestScreen(),
      const TransactionHistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          localizations.translate('dashboard'),
          style: AppTextStyles.headline4.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          // User Avatar
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.md),
            child: GestureDetector(
              onTap: () => _onItemTapped(3), // Navigate to profile
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: authProvider.user?.profileImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          authProvider.user!.profileImage!,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
              ),
            ),
          ),
          // Logout Button
          IconButton(
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          backgroundColor: Colors.white,
          indicatorColor: AppColors.primary.withOpacity(0.1),
          surfaceTintColor: Colors.transparent,
          destinations: [
            NavigationDestination(
              icon: Icon(
                _selectedIndex == 0 ? Icons.dashboard : Icons.dashboard_outlined,
                color: _selectedIndex == 0 ? AppColors.primary : AppColors.textSecondary,
              ),
              label: localizations.translate('dashboard'),
            ),
            NavigationDestination(
              icon: Icon(
                _selectedIndex == 1 ? Icons.request_page : Icons.request_page_outlined,
                color: _selectedIndex == 1 ? AppColors.primary : AppColors.textSecondary,
              ),
              label: localizations.translate('loan_request'),
            ),
            NavigationDestination(
              icon: Icon(
                _selectedIndex == 2 ? Icons.history : Icons.history_outlined,
                color: _selectedIndex == 2 ? AppColors.primary : AppColors.textSecondary,
              ),
              label: localizations.translate('transaction_history'),
            ),
            NavigationDestination(
              icon: Icon(
                _selectedIndex == 3 ? Icons.person : Icons.person_outline,
                color: _selectedIndex == 3 ? AppColors.primary : AppColors.textSecondary,
              ),
              label: localizations.translate('profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final loanProvider = Provider.of<LoanProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final pendingLoans = loanProvider.loans.where((loan) => 
      loan.status.toLowerCase() == 'pending').length;
    final approvedLoans = loanProvider.loans.where((loan) => 
      loan.status.toLowerCase() == 'approved').length;
    final rejectedLoans = loanProvider.loans.where((loan) => 
      loan.status.toLowerCase() == 'rejected').length;

    return RefreshIndicator(
      onRefresh: () async {
        if (authProvider.user != null && authProvider.token != null) {
          await loanProvider.fetchUserLoans(
            authProvider.user!.id, 
            authProvider.token!
          );
          await loanProvider.fetchCreditLimits(
            authProvider.user!.id, 
            authProvider.token!
          );
        }
      },
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
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
                  Text(
                    'Welcome back,',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    authProvider.user?.fullName ?? 'User',
                    style: AppTextStyles.headline3.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'Manage your loans and finances',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSizes.lg),
            
            // Quick Stats Cards
            Text(
              'Loan Overview',
              style: AppTextStyles.headline4.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Pending',
                    value: pendingLoans.toString(),
                    icon: Icons.pending_actions_outlined,
                    color: AppColors.warning,
                    context: context,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: _buildStatCard(
                    title: 'Approved',
                    value: approvedLoans.toString(),
                    icon: Icons.check_circle_outline,
                    color: AppColors.accent,
                    context: context,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: _buildStatCard(
                    title: 'Rejected',
                    value: rejectedLoans.toString(),
                    icon: Icons.cancel_outlined,
                    color: AppColors.error,
                    context: context,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            // Credit Limits Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Credit Limits',
                  style: AppTextStyles.headline4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Navigate to detailed credit limits view
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    'View All',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            
            if (loanProvider.creditLimits.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.xl),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  boxShadow: [AppShadows.cardShadow],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.credit_card_off_outlined,
                      size: 48,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      'No credit limits available',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      'Contact your bank to set up credit limits',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...loanProvider.creditLimits.map((limit) {
                final bank = loanProvider.banks.firstWhere(
                  (b) => b.id == limit.bankId,
                  orElse: () => loanProvider.banks.first,
                );
                final company = loanProvider.companies.firstWhere(
                  (c) => c.id == limit.companyId,
                  orElse: () => loanProvider.companies.first,
                );
                
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSizes.md),
                  padding: const EdgeInsets.all(AppSizes.lg),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    boxShadow: [AppShadows.cardShadow],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
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
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  company.name,
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
                              color: AppColors.accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                            ),
                            child: Text(
                              '\$${limit.totalLimit.toStringAsFixed(0)}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.md),
                      
                      // Progress Bar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Available: \$${limit.availableLimit.toStringAsFixed(0)}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                'Used: \$${limit.usedLimit.toStringAsFixed(0)}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.xs),
                          LinearProgressIndicator(
                            value: limit.usedLimit / limit.totalLimit,
                            backgroundColor: AppColors.border,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              limit.usedLimit / limit.totalLimit > 0.8
                                  ? AppColors.error
                                  : limit.usedLimit / limit.totalLimit > 0.6
                                      ? AppColors.warning
                                      : AppColors.accent,
                            ),
                            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        boxShadow: [AppShadows.cardShadow],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Icon(
              icon,
              size: AppSizes.iconLarge,
              color: color,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            value,
            style: AppTextStyles.headline3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
