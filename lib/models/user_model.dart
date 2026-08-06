enum UserRole { customer, rider }

class UserModel {
  final String id;
  String name;
  String email;
  String phoneNumber;
  String profileImageUrl;
  double wasteRecycledKg;
  double ecoRating;
  String address;
  String? bio;
  UserRole role;
  String? governmentIdUrl;
  DateTime? joinedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl = 'https://i.pravatar.cc/150?img=11',
    this.wasteRecycledKg = 0.0,
    this.ecoRating = 0.0,
    this.address = '',
    this.bio,
    this.role = UserRole.customer,
    this.governmentIdUrl,
    this.joinedAt,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    double? wasteRecycledKg,
    double? ecoRating,
    String? address,
    String? bio,
    UserRole? role,
    String? governmentIdUrl,
    DateTime? joinedAt,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      wasteRecycledKg: wasteRecycledKg ?? this.wasteRecycledKg,
      ecoRating: ecoRating ?? this.ecoRating,
      address: address ?? this.address,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      governmentIdUrl: governmentIdUrl ?? this.governmentIdUrl,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'wasteRecycledKg': wasteRecycledKg,
      'ecoRating': ecoRating,
      'address': address,
      'bio': bio,
      'role': role.index,
      'governmentIdUrl': governmentIdUrl,
      'joinedAt': joinedAt?.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'] ?? 'https://i.pravatar.cc/150?img=11',
      wasteRecycledKg: (json['wasteRecycledKg'] as num?)?.toDouble() ?? 0.0,
      ecoRating: (json['ecoRating'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      bio: json['bio'],
      role: UserRole.values[json['role'] ?? 0],
      governmentIdUrl: json['governmentIdUrl'],
      joinedAt: json['joinedAt'] != null ? DateTime.parse(json['joinedAt']) : null,
    );
  }
}
