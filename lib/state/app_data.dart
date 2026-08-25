import 'package:flutter/material.dart';

class PropertyListing {
  final String id;
  final String dealType; // 'rent' or 'sell'
  final String categoryId;
  final String categoryLabel;
  final String title;
  final String location;
  final String district;
  final String? landArea;
  final String? buildArea;
  final String priceDisplay;
  final int priceValue;
  final Map<String, dynamic> details;
  final String description;
  final List<String> imagePaths;
  final String? videoPath;
  final int views;
  final DateTime createdAt;

  const PropertyListing({
    required this.id,
    required this.dealType,
    required this.categoryId,
    required this.categoryLabel,
    required this.title,
    required this.location,
    required this.district,
    this.landArea,
    this.buildArea,
    required this.priceDisplay,
    required this.priceValue,
    required this.details,
    required this.description,
    required this.imagePaths,
    this.videoPath,
    required this.views,
    required this.createdAt,
  });

  bool get isVilla => categoryId == 'villa';
}

class Reservation {
  final PropertyListing property;
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

  final List<PropertyListing> _listings = [
    PropertyListing(
      id: 'prop1',
      dealType: 'sell',
      categoryId: 'apartment',
      categoryLabel: 'آپارتمانی',
      title: 'آپارتمان ۱۲۰ متری',
      location: 'سعادت‌آباد',
      district: 'میدان آزادی و حومه',
      buildArea: '۱۲۰',
      priceDisplay: '۳ میلیارد تومان',
      priceValue: 3000000000,
      details: const {
        'formData_bedrooms': '۳',
        'formData_floor': '۳',
        'formData_deed': 'سند تک‌برگ',
      },
      description: 'آپارتمان نوساز با نور مناسب و دسترسی عالی.',
      imagePaths: const ['assets/images/slider1.jpg'],
      views: 340,
      createdAt: DateTime.now(),
    ),
    PropertyListing(
      id: 'prop2',
      dealType: 'rent',
      categoryId: 'commercial',
      categoryLabel: 'تجاری',
      title: 'مغازه تجاری',
      location: 'خیابان ولیعصر',
      district: 'پشت فرمانداری',
      landArea: '۴۵',
      priceDisplay: 'رهن ۲۰۰ / اجاره ۱۵',
      priceValue: 15000000,
      details: const {
        'formData_landDeed': 'سند تک‌برگ',
        'formData_utilities': true,
      },
      description: 'مغازه با ویترین بزرگ، مناسب کسب‌وکارهای خدماتی.',
      imagePaths: const ['assets/images/slider2.jpg'],
      views: 210,
      createdAt: DateTime.now(),
    ),
    PropertyListing(
      id: 'prop3',
      dealType: 'sell',
      categoryId: 'farmland',
      categoryLabel: 'زمین مزروعی',
      title: 'زمین مزروعی',
      location: 'کرج، اطراف',
      district: 'میدان مادر',
      landArea: '۱۰۰۰',
      priceDisplay: '۸۰۰ میلیون تومان',
      priceValue: 800000000,
      details: const {
        'formData_landDeed': 'قولنامه‌ای',
        'formData_utilities': false,
      },
      description: 'زمین مناسب کشاورزی با دسترسی به جاده اصلی.',
      imagePaths: const ['assets/images/slider3.jpg'],
      views: 150,
      createdAt: DateTime.now(),
    ),
    PropertyListing(
      id: 'prop4',
      dealType: 'rent',
      categoryId: 'villa',
      categoryLabel: 'ویلایی',
      title: 'واحد ویلایی نوساز',
      location: 'لواسان',
      district: 'شهرک',
      landArea: '۳۰۰',
      buildArea: '۲۰۰',
      priceDisplay: 'رهن ۵۰۰ / اجاره ۴۰',
      priceValue: 40000000,
      details: const {
        'formData_bedrooms': '۴',
        'formData_buildYear': '۰',
        'formData_deed': 'تک‌برگ',
        'formData_parking': true,
        'formData_storage': true,
        'formData_elevator': false,
        'formData_insurance': true,
      },
      description: 'ویلای نوساز با محوطه اختصاصی و طراحی مدرن.',
      imagePaths: const ['assets/images/slider1.jpg'],
      views: 95,
      createdAt: DateTime.now(),
    ),
  ];

  Set<String> get favoriteIds => _favoriteIds;
  List<Reservation> get reservations => List.unmodifiable(_reservations);
  List<PropertyListing> get listings => List.unmodifiable(_listings);

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  void addReservation(PropertyListing property, String phoneNumber) {
    _reservations.add(
      Reservation(
        property: property,
        phoneNumber: phoneNumber,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void addListing(PropertyListing listing) {
    _listings.insert(0, listing);
    notifyListeners();
  }
}
