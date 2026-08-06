class AppImages {
  // Common placeholders for offline mode to avoid CORS
  static const String avatarPlaceholder = 'assets/images/placeholder_avatar.png';
  static const String wastePlaceholder = 'assets/images/placeholder_waste.png';
  
  // Category specific defaults
  static const String plasticDefault = 'assets/images/plastic_waste.png';
  static const String metalDefault = 'assets/images/metal_waste.png';
  static const String paperDefault = 'assets/images/paper_waste.png';
  static const String glassDefault = 'assets/images/glass_waste.png';
  static const String electronicDefault = 'assets/images/electronic_waste.png';
  static const String organicDefault = 'assets/images/organic_waste.png';
  
  // Helper to get safe image URL
  static String getSafeImage(String? url, {String fallback = wastePlaceholder}) {
    if (url == null || url.isEmpty || url.startsWith('http')) {
      // In production quality prototype, we replace all network calls with local assets
      // until backend CORS is configured.
      return fallback;
    }
    return url;
  }
}
