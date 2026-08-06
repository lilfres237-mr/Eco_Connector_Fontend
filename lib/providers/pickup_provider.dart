import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/pickup_request.dart';
import '../models/notification_model.dart';
import 'notification_provider.dart';
import '../services/storage_service.dart';
import '../core/constants/app_images.dart';

class PickupProvider extends ChangeNotifier {
  NotificationProvider? _notificationProvider;

  List<PickupRequest> _requests = [];

  PickupProvider() {
    _loadRequests();
  }

  void _loadRequests() {
    final requestsJson = StorageService.getString('pickup_requests');
    if (requestsJson != null && requestsJson.isNotEmpty) {
      final List<dynamic> decoded = json.decode(requestsJson);
      _requests = decoded.map((r) => PickupRequest.fromJson(r)).toList();
    } else {
      _requests = [
        PickupRequest(
          id: '1',
          customerId: 'u1',
          customerName: 'John Doe',
          address: '123 Maple St, San Francisco',
          description: 'Monthly plastic recycling',
          wasteType: 'Plastic Waste',
          weightKg: 15.0,
          dateTime: DateTime.now().add(const Duration(days: 1)),
          contactNumber: '+1 555 123 4567',
          status: PickupStatus.confirmed,
          trackingNumber: 'ECO-98234-SF',
          assignedRider: PickupRider(
            id: 'r1',
            name: 'Marcus Chen',
            avatar: AppImages.avatarPlaceholder,
            vehicleInfo: 'Electric Trike • GEX-902',
            contactNumber: '+1 555 999 0000',
            rating: 4.9,
            estimatedArrival: '8 mins',
          ),
        ),
        PickupRequest(
          id: '2',
          customerId: 'u2',
          customerName: 'Alice Green',
          address: '456 Oak St, San Francisco',
          description: 'Mixed cardboard and paper',
          wasteType: 'Paper & Cardboard',
          weightKg: 8.5,
          dateTime: DateTime.now().add(const Duration(hours: 2)),
          contactNumber: '+1 555 111 2222',
          status: PickupStatus.searching,
          trackingNumber: 'ECO-12345-SF',
          isBroadcasted: true,
        ),
        PickupRequest(
          id: '3',
          customerId: 'u3',
          customerName: 'Bob Smith',
          address: '789 Pine St, San Francisco',
          description: 'Old laptop and cables',
          wasteType: 'Electronics',
          weightKg: 4.0,
          dateTime: DateTime.now().add(const Duration(hours: 4)),
          contactNumber: '+1 555 333 4444',
          status: PickupStatus.searching,
          trackingNumber: 'ECO-67890-SF',
          isBroadcasted: true,
        ),
      ];
      _saveRequests();
    }
    notifyListeners();
  }

  Future<void> _saveRequests() async {
    final requestsJson = json.encode(_requests.map((r) => r.toJson()).toList());
    await StorageService.setString('pickup_requests', requestsJson);
  }

  void setNotificationProvider(NotificationProvider provider) {
    _notificationProvider = provider;
  }

  List<PickupRequest> get activeRequests => _requests.where((r) => r.status != PickupStatus.completed && r.status != PickupStatus.cancelled).toList();
  List<PickupRequest> get completedRequests => _requests.where((r) => r.status == PickupStatus.completed).toList();
  
  // Rider specific getters
  List<PickupRequest> get availableForRiders => _requests.where((r) => r.status == PickupStatus.searching && r.isBroadcasted).toList();
  List<PickupRequest> getRiderJobs(String riderId) => _requests.where((r) => r.assignedRider?.id == riderId).toList();

  void addRequest(PickupRequest request) {
    // Set to searching and broadcasted initially
    final newRequest = request.copyWith(
      status: PickupStatus.searching,
      isBroadcasted: true,
    );
    
    _requests.insert(0, newRequest);
    _saveRequests();
    notifyListeners();
  }

  Future<bool> acceptPickup(String requestId, PickupRider rider) async {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index != -1 && _requests[index].status == PickupStatus.searching) {
      await Future.delayed(const Duration(milliseconds: 500));
      
      _requests[index] = _requests[index].copyWith(
        status: PickupStatus.confirmed,
        assignedRider: rider,
        isBroadcasted: false,
      );
      
      await _saveRequests();
      notifyListeners();

      // Notify the customer
      _notificationProvider?.addNotification(
        NotificationModel(
          id: DateTime.now().toString(),
          title: 'Rider Assigned!',
          message: '${rider.name} has accepted your pickup request for ${_requests[index].wasteType}.',
          timestamp: DateTime.now(),
          type: NotificationType.riderAccepted,
        ),
      );
      
      return true;
    }
    return false;
  }

  void updateStatus(String id, PickupStatus status) {
    final index = _requests.indexWhere((r) => r.id == id);
    if (index != -1) {
      _requests[index] = _requests[index].copyWith(status: status);
      _saveRequests();
      notifyListeners();
    }
  }
}
