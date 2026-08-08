/// Central app configuration.
class AppConfig {
  /// Google Maps API key.
  ///
  /// Replace with a real key to enable the live map, and ALSO update:
  /// - android/app/src/main/AndroidManifest.xml (`com.google.android.geo.API_KEY`)
  ///   — the native Maps SDK reads the key from the manifest, not from Dart.
  static const String googleMapsApiKey = 'YOUR_API_KEY_HERE';

  /// Whether a real Google Maps API key has been configured.
  ///
  /// While this is false the app renders a static fallback instead of a
  /// live GoogleMap, because instantiating the native map without a key
  /// crashes the app on Android.
  static bool get isGoogleMapsConfigured =>
      googleMapsApiKey.isNotEmpty && !googleMapsApiKey.startsWith('YOUR_');
}
