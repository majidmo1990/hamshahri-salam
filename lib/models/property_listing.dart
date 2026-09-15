class PropertyListing {
  final int id;
  final String dealType;
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
  final List<String> imageUrls; // URLهای سرور
  final String? videoUrl;
  final String sellerPhone;
  final int views;
  final DateTime createdAt;

  PropertyListing({
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
    required this.imageUrls,
    this.videoUrl,
    required this.sellerPhone,
    required this.views,
    required this.createdAt,
  });

  bool get isVilla => categoryId == 'villa';
  bool get isRent => dealType == 'rent';

  // Backward compat: اسم قبلی imagePaths هم کار کنه
  List<String> get imagePaths => imageUrls;

  factory PropertyListing.fromJson(Map<String, dynamic> json) {
    return PropertyListing(
      id: json['id'] as int,
      dealType: json['deal_type'] as String,
      categoryId: json['category_id'] as String,
      categoryLabel: json['category_label'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      district: json['district'] as String,
      landArea: json['land_area'] as String?,
      buildArea: json['build_area'] as String?,
      priceDisplay: json['price_display'] as String,
      priceValue: (json['price_value'] as num).toInt(),
      details: Map<String, dynamic>.from(json['details'] ?? {}),
      description: json['description'] as String? ?? '',
      imageUrls: (json['image_urls'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      videoUrl: json['video_url'] as String?,
      sellerPhone: json['seller_phone'] as String,
      views: (json['views'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  PropertyListing copyWith({int? views}) {
    return PropertyListing(
      id: id,
      dealType: dealType,
      categoryId: categoryId,
      categoryLabel: categoryLabel,
      title: title,
      location: location,
      district: district,
      landArea: landArea,
      buildArea: buildArea,
      priceDisplay: priceDisplay,
      priceValue: priceValue,
      details: details,
      description: description,
      imageUrls: imageUrls,
      videoUrl: videoUrl,
      sellerPhone: sellerPhone,
      views: views ?? this.views,
      createdAt: createdAt,
    );
  }
}
