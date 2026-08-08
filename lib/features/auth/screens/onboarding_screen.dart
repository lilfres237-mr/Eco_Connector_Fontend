import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../widgets/app_logo.dart';
import '../../../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<String> _images = [
    'https://images.unsplash.com/photo-1530587191325-3db32d826c18?w=800', // Landfill
    'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=800', // Better Recycling Bins
    'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800', // Lush Green Field (Success)
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Carousel with Blended Edges
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.6, 1.0],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.dstIn,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    _images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                        alignment: Alignment.center,
                        child: const AppLogo(size: 80, variant: LogoVariant.icon),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          
          // Content Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  
                  // Floating "Next Pickup" indicator that updates
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const AppLogo(size: 24, variant: LogoVariant.icon, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Next Pickup', 
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
                              ),
                              Text(
                                'Tomorrow, 8:00 AM', 
                                style: Theme.of(context).textTheme.bodySmall
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: Text(
                      'Welcome to EcoConnect',
                      style: AppTextStyles.h1.copyWith(color: Theme.of(context).colorScheme.primary, fontSize: 32),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      'Join thousands of households making waste collection easier and cleaner.',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_images.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  
                  const Spacer(),
                  
                  CustomButton(
                    text: 'Login',
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  CustomButton(
                    text: 'Get Started',
                    type: ButtonType.outline,
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
