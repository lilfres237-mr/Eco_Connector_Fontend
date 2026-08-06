enum PickupStatus { pending, searching, confirmed, onWay, arrived, completed, cancelled }

class PickupRider {
  final String id;
  final String name;
  final String avatar;
  final String vehicleInfo;
  final String contactNumber;
  final double rating;
  final String estimatedArrival;

  PickupRider({
    required this.id,
    required this.name,
    required this.avatar,
    required this.vehicleInfo,
    required this.contactNumber,
    required this.rating,
    required this.estimatedArrival,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'vehicleInfo': vehicleInfo,
      'contactNumber': contactNumber,
      'rating': rating,
      'estimatedArrival': estimatedArrival,
    };
  }

  factory PickupRider.fromJson(Map<String, dynamic> json) {
    return PickupRider(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      vehicleInfo: json['vehicleInfo'],
      contactNumber: json['contactNumber'],
      rating: (json['rating'] as num).toDouble(),
      estimatedArrival: json['estimatedArrival'],
    );
  }
}

class PickupRequest {
  final String id;
  final String customerId;
  final String customerName;
  final String address;
  final String description;
  final String wasteType;
  final double weightKg;
  final DateTime dateTime;
  final String contactNumber;
  final String? specialInstructions;
  final PickupStatus status;
  final String trackingNumber;
  final PickupRider? assignedRider;
  final bool isBroadcasted;

  PickupRequest({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.address,
    required this.description,
    required this.wasteType,
    required this.weightKg,
    required this.dateTime,
    required this.contactNumber,
    this.specialInstructions,
    this.status = PickupStatus.pending,
    required this.trackingNumber,
    this.assignedRider,
    this.isBroadcasted = false,
  });

  PickupRequest copyWith({
    PickupStatus? status,
    PickupRider? assignedRider,
    bool? isBroadcasted,
  }) {
    return PickupRequest(
      id: id,
      customerId: customerId,
      customerName: customerName,
      address: address,
      description: description,
      wasteType: wasteType,
      weightKg: weightKg,
      dateTime: dateTime,
      contactNumber: contactNumber,
      specialInstructions: specialInstructions,
      status: status ?? this.status,
      trackingNumber: trackingNumber,
      assignedRider: assignedRider ?? this.assignedRider,
      isBroadcasted: isBroadcasted ?? this.isBroadcasted,
    );
  }
}
