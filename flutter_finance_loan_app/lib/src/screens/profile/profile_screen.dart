import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../utils/app_localizations.dart';
import '../../constants/theme_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            const SizedBox(height: AppSizes.xl),
            
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.xl),
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
                children: [
                  // Profile Avatar
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.white,
                          backgroundImage: authProvider.user?.profileImage != null
                              ? NetworkImage(authProvider.user!.profileImage!)
                              : null,
                          child: authProvider.user?.profileImage == null
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.sm),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSizes.lg),
                  
                  // User Name
                  Text(
                    authProvider.user?.fullName ?? 'User Name',
                    style: AppTextStyles.headline3.copyWith(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: AppSizes.sm),
                  
                  // User Email
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                    ),
                    child: Text(
                      authProvider.user?.email ?? 'user@example.com',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            // Profile Settings
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                boxShadow: [AppShadows.cardShadow],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: Text(
                      'Account Settings',
                      style: AppTextStyles.headline4.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  
                  // Language Setting
                  _buildSettingTile(
                    icon: Icons.language_outlined,
                    title: localizations.translate('language'),
                    subtitle: _getLanguageName(languageProvider.currentLanguage),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md,
                        vertical: AppSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                      ),
                      child: DropdownButton<String>(
                        value: languageProvider.currentLanguage,
                        underline: const SizedBox(),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'en',
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('🇺🇸', style: TextStyle(fontSize: 16)),
                                SizedBox(width: AppSizes.xs),
                                Text('English'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'ar',
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('🇸🇦', style: TextStyle(fontSize: 16)),
                                SizedBox(width: AppSizes.xs),
                                Text('العربية'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'ku',
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('🏴', style: TextStyle(fontSize: 16)),
                                SizedBox(width: AppSizes.xs),
                                Text('کوردی'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            languageProvider.changeLanguage(value);
                          }
                        },
                      ),
                    ),
                  ),
                  
                  _buildDivider(),
                  
                  // Phone Number
                  _buildSettingTile(
                    icon: Icons.phone_outlined,
                    title: 'Phone Number',
                    subtitle: authProvider.user?.phoneNumber ?? 'Not provided',
                    trailing: Icon(
                      Icons.edit_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onTap: () {
                      // Handle phone number edit
                    },
                  ),
                  
                  _buildDivider(),
                  
                  // Member Since
                  _buildSettingTile(
                    icon: Icons.calendar_today_outlined,
                    title: 'Member Since',
                    subtitle: authProvider.user?.createdAt != null
                        ? '${authProvider.user!.createdAt.day}/${authProvider.user!.createdAt.month}/${authProvider.user!.createdAt.year}'
                        : 'Unknown',
                  ),
                  
                  _buildDivider(),
                  
                  // Notifications
                  _buildSettingTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage your notification preferences',
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        // Handle notification toggle
                      },
                      activeColor: AppColors.primary,
                    ),
                  ),
                  
                  _buildDivider(),
                  
                  // Security
                  _buildSettingTile(
                    icon: Icons.security_outlined,
                    title: 'Security',
                    subtitle: 'Change password and security settings',
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    onTap: () {
                      // Handle security settings
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            // Support Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                boxShadow: [AppShadows.cardShadow],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: Text(
                      'Support & Information',
                      style: AppTextStyles.headline4.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  
                  _buildSettingTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get help with your account',
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    onTap: () {
                      // Handle help & support
                    },
                  ),
                  
                  _buildDivider(),
                  
                  _buildSettingTile(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App version and information',
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    onTap: () {
                      // Handle about
                    },
                  ),
                  
                  _buildDivider(),
                  
                  _buildSettingTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    onTap: () {
                      // Handle privacy policy
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            // Logout Button
            Container(
              width: double.infinity,
              height: AppSizes.buttonHeightLarge,
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Show confirmation dialog
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                      ),
                      title: Text(
                        'Logout',
                        style: AppTextStyles.headline4,
                      ),
                      content: Text(
                        'Are you sure you want to logout?',
                        style: AppTextStyles.bodyMedium,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            'Cancel',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                          ),
                          child: Text(
                            'Logout',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  
                  if (shouldLogout == true) {
                    final authProvider = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );
                    await authProvider.logout();
                    
                    if (mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                ),
                icon: Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ),
                label: Text(
                  localizations.translate('logout'),
                  style: AppTextStyles.buttonLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            // App Version
            Text(
              'Finance Loan App v1.0.0',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.sm,
      ),
      leading: Container(
        padding: const EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: AppSizes.iconMedium,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: trailing,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.border,
      indent: AppSizes.lg + AppSizes.iconMedium + AppSizes.sm + AppSizes.lg,
      endIndent: AppSizes.lg,
    );
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      case 'ku':
        return 'کوردی';
      default:
        return 'English';
    }
  }
}
