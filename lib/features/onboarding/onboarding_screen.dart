import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_values.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      icon: Icons.solar_power_rounded,
      title: AppStrings.onboarding1Title,
      description: AppStrings.onboarding1Desc,
      gradient: AppColors.onboardingGradient1,
      bgIcon: Icons.wb_sunny_rounded,
    ),
    _OnboardingData(
      icon: Icons.sell_rounded,
      title: AppStrings.onboarding2Title,
      description: AppStrings.onboarding2Desc,
      gradient: AppColors.onboardingGradient2,
      bgIcon: Icons.bolt_rounded,
    ),
    _OnboardingData(
      icon: Icons.shopping_cart_rounded,
      title: AppStrings.onboarding3Title,
      description: AppStrings.onboarding3Desc,
      gradient: AppColors.onboardingGradient3,
      bgIcon: Icons.eco_rounded,
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppValues.animNormal,
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppValues.paddingMd),
                child: TextButton(
                  onPressed: _navigateToLogin,
                  child: Text(
                    AppStrings.skip,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textDarkSecondary,
                        ),
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return _OnboardingPage(data: _pages[index]);
                },
              ),
            ),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.all(AppValues.paddingLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.textDarkSecondary.withValues(alpha: 0.3),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                      spacing: 6,
                    ),
                  ),
                  // Next / Get Started button
                  GestureDetector(
                    onTap: _onNext,
                    child: AnimatedContainer(
                      duration: AppValues.animFast,
                      padding: EdgeInsets.symmetric(
                        horizontal: _currentPage == _pages.length - 1
                            ? AppValues.paddingLg
                            : AppValues.paddingMd,
                        vertical: AppValues.paddingSm + 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius:
                            BorderRadius.circular(AppValues.radiusRound),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentPage == _pages.length - 1
                                ? AppStrings.getStarted
                                : AppStrings.next,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppValues.paddingMd),
          ],
        ),
      ),
    );
  }
}

// ── Onboarding Page ──
class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.paddingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration area
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: data.gradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: data.gradient.colors.first.withValues(alpha: 0.3),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background icon
                Positioned(
                  top: 20,
                  right: 25,
                  child: Icon(
                    data.bgIcon,
                    size: 40,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                // Main icon
                Icon(
                  data.icon,
                  size: 80,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppValues.paddingXxl),
          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppValues.paddingMd),
          // Description
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textDarkSecondary,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Data class ──
class _OnboardingData {
  final IconData icon;
  final String title;
  final String description;
  final LinearGradient gradient;
  final IconData bgIcon;

  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.bgIcon,
  });
}
