import 'market_listing_model.dart';

enum OrderStatus { pending, confirmed, processing, shipped, delivered, cancelled }
enum PaymentMethod { momo, orangeMoney, cashOnDelivery, wallet }

class OrderModel {
  final String id;
  final String customerId;
  final MarketListing item;
  final double quantity;
  final double totalPrice;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final double? rating;
  final String? review;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.item,
    required this.quantity,
    required this.totalPrice,
    this.status = OrderStatus.pending,
    required this.paymentMethod,
    required this.createdAt,
    this.rating,
    this.review,
  });

  OrderModel copyWith({
    OrderStatus? status,
    double? rating,
    String? review,
  }) {
    return OrderModel(
      id: id,
      customerId: customerId,
      item: item,
      quantity: quantity,
      totalPrice: totalPrice,
      status: status ?? this.status,
      paymentMethod: paymentMethod,
      createdAt: createdAt,
      rating: rating ?? this.rating,
      review: review ?? this.review,
    );
  }
}
