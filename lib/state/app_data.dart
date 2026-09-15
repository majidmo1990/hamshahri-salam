import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/property_listing.dart';
import '../services/api_service.dart';

export '../models/property_listing.dart';

class Reservation {
  final PropertyListing property;
  final String phoneNumber;
  final DateTime date;

  Reservation({
    required this.property,
    required this.phoneNumber,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'propertyId': property.id,
        'propertyTitle': property.title,
        'propertyLocation': property.location,
        'propertyImage': property.imageUrls.isNotEmpty
            ? property.imageUrls.first
            : '',
        'priceDisplay': property.priceDisplay,
        'phoneNumber': phoneNumber,
        'date': date.toIso8601String(),
      };

  factory Reservation.fromJson(Map<String, dynamic> json) {
    // یه PropertyListing موقت از دیتای ذخیره شده می‌سازیم
    final tempProperty = PropertyListing(
      id: json['propertyId'] as int,
      dealType: '',
      categoryId: '',
      categoryLabel: '',
      title: json['propertyTitle'] as String,
      location: json['propertyLocation'] as String,
      district: '',
      priceDisplay: json['priceDisplay'] as String,
      priceValue: 0,
      details: {},
      description: '',
      imageUrls: json['propertyImage'] != null &&
              (json['propertyImage'] as String).isNotEmpty
          ? [json['propertyImage'] as String]
          : [],
      sellerPhone: '',
      views: 0,
      createdAt: DateTime.now(),
    );
    return Reservation(
      property: tempProperty,
      phoneNumber: json['phoneNumber'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}

class AppData extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<PropertyListing> _listings = [];
  Set<int> _favoriteIds = {};
  List<Reservation> _reservations = [];

  bool _loading = false;
  String? _error;
  bool _initialized = false;

  static const _reservationsKey = 'local_reservations';

  // ============ Getters ============
  List<PropertyListing> get listings => List.unmodifiable(_listings);
  Set<int> get favoriteIds => Set.unmodifiable(_favoriteIds);
  List<Reservation> get reservations =>
      List.unmodifiable(_reservations.reversed);
  bool get loading => _loading;
  String? get error => _error;

  bool isFavorite(int id) => _favoriteIds.contains(id);

  // ============ Init ============
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    await _loadReservationsFromDisk();
    await loadProperties();
  }

  // ============ Properties ============
  Future<void> loadProperties({
    String? q,
    String? dealType,
    String? categoryId,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final list = await _api.getProperties(
        q: q,
        dealType: dealType,
        categoryId: categoryId,
      );
      _listings = list.map((e) => PropertyListing.fromJson(e)).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _listings = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadProperties();
    await loadFavorites();
  }

  // ============ Favorites ============
  Future<void> loadFavorites() async {
    try {
      final list = await _api.getFavorites();
      _favoriteIds = list.map((e) => e['id'] as int).toSet();
      notifyListeners();
    } catch (_) {
      // اگه کاربر لاگین نبود، خطا رو نادیده بگیر
    }
  }

  Future<void> toggleFavorite(int id) async {
    final wasFav = _favoriteIds.contains(id);
    // Optimistic update
    if (wasFav) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();

    try {
      if (wasFav) {
        await _api.removeFavorite(id);
      } else {
        await _api.addFavorite(id);
      }
    } catch (e) {
      // اگه خطا داد، برگردون
      if (wasFav) {
        _favoriteIds.add(id);
      } else {
        _favoriteIds.remove(id);
      }
      notifyListeners();
    }
  }

  // ============ Add / Delete ============
  Future<PropertyListing?> addListing(Map<String, dynamic> data) async {
    try {
      final json = await _api.createProperty(data);
      final listing = PropertyListing.fromJson(json);
      _listings.insert(0, listing);
      notifyListeners();
      return listing;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteListing(int id) async {
    try {
      await _api.deleteProperty(id);
      _listings.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ============ Views ============
  Future<void> incrementViews(int id) async {
    final index = _listings.indexWhere((l) => l.id == id);
    if (index == -1) return;

    // Optimistic
    _listings[index] = _listings[index].copyWith(
      views: _listings[index].views + 1,
    );
    notifyListeners();

    try {
      await _api.getProperty(id); // سرور خودش views رو +1 می‌کنه
    } catch (_) {}
  }

  // ============ Reservations (Local) ============
  Future<void> addReservation(PropertyListing property, String phoneNumber) async {
    final res = Reservation(
      property: property,
      phoneNumber: phoneNumber,
      date: DateTime.now(),
    );
    _reservations.add(res);
    notifyListeners();
    await _saveReservationsToDisk();
  }

  Future<void> _saveReservationsToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _reservations.map((r) => r.toJson()).toList();
    await prefs.setString(_reservationsKey, jsonEncode(list));
  }

  Future<void> _loadReservationsFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_reservationsKey);
    if (str == null || str.isEmpty) return;
    try {
      final list = (jsonDecode(str) as List)
          .map((e) => Reservation.fromJson(e as Map<String, dynamic>))
          .toList();
      _reservations = list;
      notifyListeners();
    } catch (_) {}
  }

  /// بعد از logout صدا بزن تا کش پاک شه
  Future<void> onLogout() async {
    _favoriteIds.clear();
    notifyListeners();
  }
}
