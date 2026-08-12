import 'dart:io';
import 'package:flutter/material.dart';
import '../core/constants/app_images.dart';

enum ImageType { asset, file, network, unknown }

class EcoImage extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String fallbackImage;
  final double? radius;
  final BoxShape shape;

  const EcoImage({
    super.key,
    this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackImage = AppImages.avatarPlaceholder,
    this.radius,
    this.shape = BoxShape.rectangle,
  });

  ImageType _getImageType(String? path) {
    if (path == null || path.isEmpty) return ImageType.unknown;
    if (path.startsWith('assets/')) return ImageType.asset;
    if (path.startsWith('http') || path.startsWith('https')) return ImageType.network;
    if (path.startsWith('/') || path.contains(':\\') || path.contains('cache')) return ImageType.file;
    return ImageType.unknown;
  }

  @override
  Widget build(BuildContext context) {
    final type = _getImageType(imagePath);

    Widget imageWidget;

    switch (type) {
      case ImageType.asset:
        imageWidget = Image.asset(
          imagePath!,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _buildFallback(),
        );
        break;
      case ImageType.network:
        imageWidget = Image.network(
          imagePath!,
          width: width,
          height: height,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: width,
              height: height,
              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          },
          errorBuilder: (context, error, stackTrace) => _buildFallback(),
        );
        break;
      case ImageType.file:
        imageWidget = Image.file(
          File(imagePath!),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _buildFallback(),
        );
        break;
      case ImageType.unknown:
      default:
        imageWidget = _buildFallback();
    }

    if (shape == BoxShape.circle) {
      return Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        clipBehavior: Clip.antiAlias,
        child: imageWidget,
      );
    }

    if (radius != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius!),
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildFallback() {
    return Image.asset(
      fallbackImage,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
