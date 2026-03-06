import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_values.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  UserRole? _selectedRole;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: AppValues.animSlow,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_selectedRole == null) return;
    context.read<AuthProvider>().setRole(_selectedRole!);
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(AppValues.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppValues.paddingLg),

                // Step indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppValues.paddingSm + 4,
                    vertical: AppValues.paddingXs + 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppValues.radiusRound),
                  ),
                  child: Text(
                    'Step 2 of 2',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),

                const SizedBox(height: AppValues.paddingLg),

                Text(
                  AppStrings.selectRole,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppValues.paddingSm),
                Text(
                  AppStrings.selectRoleSubtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColors.textSecondary),
                ),

                const SizedBox(height: AppValues.paddingXl),

                // Solar Owner Card
                _RoleCard(
                  icon: Icons.solar_power_rounded,
                  emoji: '☀️',
                  title: AppStrings.solarOwner,
                  description: AppStrings.solarOwnerDesc,
                  gradient: AppColors.solarGradient,
                  isSelected: _selectedRole == UserRole.solarOwner,
                  onTap: () =>
                      setState(() => _selectedRole = UserRole.solarOwner),
                ),

                const SizedBox(height: AppValues.paddingMd),

                // Energy Buyer Card
                _RoleCard(
                  icon: Icons.electric_bolt_rounded,
                  emoji: '⚡',
                  title: AppStrings.energyBuyer,
                  description: AppStrings.energyBuyerDesc,
                  gradient: AppColors.onboardingGradient3,
                  isSelected: _selectedRole == UserRole.energyBuyer,
                  onTap: () =>
                      setState(() => _selectedRole = UserRole.energyBuyer),
                ),

                const Spacer(),

                // Continue
                SizedBox(
                  width: double.infinity,
                  height: AppValues.buttonHeight,
                  child: ElevatedButton(
                    onPressed: _selectedRole != null ? _onContinue : null,
                    child: const Text(AppStrings.continueText),
                  ),
                ),

                const SizedBox(height: AppValues.paddingMd),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String emoji;
  final String title;
  final String description;
  final LinearGradient gradient;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.emoji,
    required this.title,
    required this.description,
    required this.gradient,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppValues.animFast,
        padding: const EdgeInsets.all(AppValues.paddingLg),
        decoration: BoxDecoration(
          color: isSelected
              ? gradient.colors.first.withValues(alpha: 0.08)
              : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppValues.radiusLg),
          border: Border.all(
            color: isSelected ? gradient.colors.first : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: gradient.colors.first.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: isSelected ? gradient : null,
                color: isSelected ? null : AppColors.textMuted.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppValues.radiusMd),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: AppValues.paddingMd),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isSelected ? gradient.colors.first : null,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),
            // Check
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: gradient.colors.first,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
