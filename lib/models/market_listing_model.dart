enum ListingCategory { metals, plastic, glass, paper, electronics, organic, textile, other }

class MarketListing {
  final String id;
  final String title;
  final String description;
  final ListingCategory category;
  final double pricePerKg;
  final double availableQuantity;
  final String unit;
  final String sellerId;
  final String sellerName;
  final String sellerAvatar;
  final List<String> imageUrls;
  final double rating;
  final String location;
  final DateTime createdAt;
  final String condition;
  final bool isVerified;

  MarketListing({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.pricePerKg,
    required this.availableQuantity,
    this.unit = 'kg',
    required this.sellerId,
    required this.sellerName,
    required this.sellerAvatar,
    required this.imageUrls,
    this.rating = 0.0,
    required this.location,
    required this.createdAt,
    this.condition = 'Recyclable',
    this.isVerified = true,
  });

  MarketListing copyWith({
    String? title,
    String? description,
    ListingCategory? category,
    double? pricePerKg,
    double? availableQuantity,
    String? unit,
    String? sellerId,
    String? sellerName,
    String? sellerAvatar,
    List<String>? imageUrls,
    double? rating,
    String? location,
    DateTime? createdAt,
    String? condition,
    bool? isVerified,
  }) {
    return MarketListing(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      unit: unit ?? this.unit,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerAvatar: sellerAvatar ?? this.sellerAvatar,
      imageUrls: imageUrls ?? this.imageUrls,
      rating: rating ?? this.rating,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      condition: condition ?? this.condition,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.index,
      'pricePerKg': pricePerKg,
      'availableQuantity': availableQuantity,
      'unit': unit,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerAvatar': sellerAvatar,
      'imageUrls': imageUrls,
      'rating': rating,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'condition': condition,
      'isVerified': isVerified,
    };
  }

  factory MarketListing.fromJson(Map<String, dynamic> json) {
    return MarketListing(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: ListingCategory.values[json['category']],
      pricePerKg: (json['pricePerKg'] as num).toDouble(),
      availableQuantity: (json['availableQuantity'] as num).toDouble(),
      unit: json['unit'] ?? 'kg',
      sellerId: json['sellerId'],
      sellerName: json['sellerName'],
      sellerAvatar: json['sellerAvatar'],
      imageUrls: json['imageUrls'] is List ? List<String>.from(json['imageUrls']) : const [],
      rating: (json['rating'] as num).toDouble(),
      location: json['location'],
      createdAt: DateTime.parse(json['createdAt']),
      condition: json['condition'] ?? 'Recyclable',
      isVerified: json['isVerified'] ?? true,
    );
  }
}
