import 'package:flutter/material.dart';

/// Static fallback shown in place of a live GoogleMap until a real Maps API
/// key is configured (see [AppConfig]).
class MapFallback extends StatelessWidget {
  const MapFallback({super.key, this.compact = false});

  /// Whether to use a compact layout suitable for small embedded cards.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.primary.withValues(alpha: 0.6)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, size: compact ? 28 : 40, color: Colors.white70),
            SizedBox(height: compact ? 8 : 12),
            Text(
              'MAP PREVIEW',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Live map is unavailable until a Google Maps API key is configured.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
