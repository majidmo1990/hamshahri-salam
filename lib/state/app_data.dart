import 'package:flutter/material.dart';
import '../widgets/property_card.dart';

class Reservation {
  final PropertyPreview property;
  final String phoneNumber;
  final DateTime date;

  Reservation({
    required this.property,
    required this.phoneNumber,
    required this.date,
  });
}

class AppData extends ChangeNotifier {
  final Set<String> _favoriteIds = {};
  final List<Reservation> _reservations = [];

  Set<String> get favoriteIds => _favoriteIds;
  List<Reservation> get reservations => List.unmodifiable(_reservations);

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  void addReservation(PropertyPreview property, String phoneNumber) {
    _reservations.add(
      Reservation(
        property: property,
        phoneNumber: phoneNumber,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
