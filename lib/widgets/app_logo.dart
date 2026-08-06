import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animate_do/animate_do.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

enum LogoVariant { icon, full, horizontal }

class AppLogo extends StatelessWidget {
  final double size;
  final LogoVariant variant;
  final bool animate;
  final Color? color;

  const AppLogo({
    super.key,
    this.size = 100,
    this.variant = LogoVariant.full,
    this.animate = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (variant) {
      case LogoVariant.icon:
        content = _buildIcon(context);
        break;
      case LogoVariant.full:
        content = _buildFullLogo(context);
        break;
      case LogoVariant.horizontal:
        content = _buildHorizontalLogo(context);
        break;
    }

    if (animate) {
      return ZoomIn(
        duration: const Duration(milliseconds: 1200),
        child: FadeIn(
          duration: const Duration(milliseconds: 1000),
          child: content,
        ),
      );
    }

    return content;
  }

  Widget _buildIcon(BuildContext context) {
    return SvgPicture.asset(
      'assets/branding/logo.svg',
      width: size,
      height: size,
      fit: BoxFit.contain,
      // In a real app, we might want to swap colors based on theme if the SVG doesn't use current color
      // For now, the SVG has baked-in colors that fit Light/Dark mode reasonably well
    );
  }

  Widget _buildFullLogo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIcon(context),
        const SizedBox(height: 16),
        _buildBrandText(context, isDark),
        const SizedBox(height: 8),
        _buildSlogan(context, isDark),
      ],
    );
  }

  Widget _buildHorizontalLogo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIcon(context),
        const SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBrandText(context, isDark),
            _buildSlogan(context, isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildBrandText(BuildContext context, bool isDark) {
    return Text(
      'EcoConnect',
      style: TextStyle(
        fontSize: size * 0.28,
        fontWeight: FontWeight.bold,
        color: color ?? (isDark ? Colors.white : AppColors.primary),
        fontFamily: AppTextStyles.fontFamily,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSlogan(BuildContext context, bool isDark) {
    return Text(
      'COLLECT • RECYCLE • CONNECT',
      style: TextStyle(
        fontSize: size * 0.1,
        fontWeight: FontWeight.w600,
        color: color?.withValues(alpha: 0.7) ?? (isDark ? Colors.white70 : AppColors.textSecondary),
        fontFamily: AppTextStyles.fontFamily,
        letterSpacing: 2.0,
      ),
    );
  }
}
