import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/market_listing_model.dart';
import '../services/storage_service.dart';

class MarketProvider extends ChangeNotifier {
  List<MarketListing> _listings = [];

  List<MarketListing> get listings => _listings;

  MarketProvider() {
    _loadListings();
  }

  void _loadListings() {
    final listingsJson = StorageService.getString('market_listings');
    if (listingsJson != null && listingsJson.isNotEmpty) {
      final List<dynamic> decoded = json.decode(listingsJson);
      _listings = decoded.map((l) => MarketListing.fromJson(l)).toList();
    } else {
      // Default mock listings - All waste related with REAL images
      _listings = [
        MarketListing(
          id: 'l1',
          title: 'Industrial Copper Bundles',
          description: 'High-purity industrial copper wire, stripped and compressed into bundles. Ideal for smelting.',
          category: ListingCategory.metals,
          pricePerKg: 450.0,
          availableQuantity: 50.0,
          sellerId: 's1',
          sellerName: 'MetalRecycle Co.',
          sellerAvatar: 'https://i.pravatar.cc/150?img=20',
          imageUrls: [
            'https://images.unsplash.com/photo-1533062629452-70659448f16c?w=800',
            'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800'
          ],
          rating: 4.8,
          location: 'San Francisco, CA',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          condition: 'High Grade',
        ),
        MarketListing(
          id: 'l2',
          title: 'Clean PET Plastic Flakes',
          description: 'Post-consumer PET bottles, thoroughly washed, labels removed, and shredded into 10mm flakes.',
          category: ListingCategory.plastic,
          pricePerKg: 120.0,
          availableQuantity: 100.0,
          sellerId: 's2',
          sellerName: 'PlasticPure Ltd',
          sellerAvatar: 'https://i.pravatar.cc/150?img=32',
          imageUrls: ['https://images.unsplash.com/photo-1595273670150-db0a3bf37b35?w=800'],
          rating: 4.9,
          location: 'Oakland, CA',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          condition: 'Cleaned & Shredded',
        ),
        MarketListing(
          id: 'l3',
          title: 'Cullet Glass (Mixed)',
          description: 'Crushed glass waste sorted by color. Suitable for fiberglass manufacturing or bottle production.',
          category: ListingCategory.glass,
          pricePerKg: 80.0,
          availableQuantity: 300.0,
          sellerId: 's3',
          sellerName: 'GlassWorks',
          sellerAvatar: 'https://i.pravatar.cc/150?img=44',
          imageUrls: ['https://images.unsplash.com/photo-1618770233481-9b165502c2e0?w=800'],
          rating: 4.5,
          location: 'San Jose, CA',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          condition: 'Crushed',
        ),
        MarketListing(
          id: 'l4',
          title: 'Baled Cardboard',
          description: 'Double-walled corrugated cardboard boxes, flattened and baled into standard 500kg units.',
          category: ListingCategory.paper,
          pricePerKg: 65.0,
          availableQuantity: 2000.0,
          sellerId: 's4',
          sellerName: 'PaperCycle',
          sellerAvatar: 'https://i.pravatar.cc/150?img=51',
          imageUrls: ['https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=800'],
          rating: 4.7,
          location: 'Palo Alto, CA',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          condition: 'Baled',
        ),
        MarketListing(
          id: 'l5',
          title: 'E-Waste: Mixed Circuit Boards',
          description: 'Assorted motherboards and peripheral cards for precious metal recovery.',
          category: ListingCategory.electronics,
          pricePerKg: 750.0,
          availableQuantity: 25.0,
          sellerId: 's5',
          sellerName: 'TechRecover',
          sellerAvatar: 'https://i.pravatar.cc/150?img=60',
          imageUrls: ['https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?w=800'],
          rating: 4.6,
          location: 'Fremont, CA',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          condition: 'Non-Functional',
        ),
        MarketListing(
          id: 'l6',
          title: 'Organic Compost Material',
          description: 'Stabilized organic waste ready for final composting stages or agricultural use.',
          category: ListingCategory.organic,
          pricePerKg: 40.0,
          availableQuantity: 500.0,
          sellerId: 's6',
          sellerName: 'GreenEarth',
          sellerAvatar: 'https://i.pravatar.cc/150?img=68',
          imageUrls: ['https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800'],
          rating: 4.4,
          location: 'Hayward, CA',
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
          condition: 'Semi-Processed',
        ),
        MarketListing(
          id: 'l7',
          title: 'Aluminum Beverage Cans',
          description: 'Compressed aluminum cans, rinsed and ready for recycling.',
          category: ListingCategory.metals,
          pricePerKg: 150.0,
          availableQuantity: 200.0,
          sellerId: 's7',
          sellerName: 'AluRecycle',
          sellerAvatar: 'https://i.pravatar.cc/150?img=21',
          imageUrls: ['https://images.unsplash.com/photo-1621451537084-482c73073a0f?w=800'],
          rating: 4.9,
          location: 'San Francisco, CA',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          condition: 'Cleaned',
        ),
        MarketListing(
          id: 'l8',
          title: 'Textile Waste - Cotton Mix',
          description: 'Cotton fabric scraps from garment factories, sorted by color.',
          category: ListingCategory.textile,
          pricePerKg: 50.0,
          availableQuantity: 1000.0,
          sellerId: 's8',
          sellerName: 'FabricCycle',
          sellerAvatar: 'https://i.pravatar.cc/150?img=33',
          imageUrls: ['https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=800'],
          rating: 4.3,
          location: 'Oakland, CA',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          condition: 'Industrial Scrap',
        ),
      ];
    }
    notifyListeners();
  }

  Future<void> addListing(MarketListing listing) async {
    _listings.insert(0, listing);
    await _saveListings();
    notifyListeners();
  }

  Future<void> updateListing(MarketListing updatedListing) async {
    final index = _listings.indexWhere((l) => l.id == updatedListing.id);
    if (index != -1) {
      _listings[index] = updatedListing;
      await _saveListings();
      notifyListeners();
    }
  }

  Future<void> deleteListing(String id) async {
    _listings.removeWhere((l) => l.id == id);
    await _saveListings();
    notifyListeners();
  }

  Future<void> purchaseListing(String listingId, double quantity) async {
    final index = _listings.indexWhere((l) => l.id == listingId);
    if (index != -1) {
      final listing = _listings[index];
      if (listing.availableQuantity >= quantity) {
        _listings[index] = listing.copyWith(
          availableQuantity: listing.availableQuantity - quantity,
        );
        await _saveListings();
        notifyListeners();
      }
    }
  }

  Future<void> _saveListings() async {
    final listingsJson = json.encode(_listings.map((l) => l.toJson()).toList());
    await StorageService.setString('market_listings', listingsJson);
  }
}
