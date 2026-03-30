class Product {
  final int id;
  final int categoryId;
  final String arabicName;
  final String? englishName;      // optional – many menus only use Arabic
  final int price;
  final String? imagePath;
  final String? arabicDescription;
  final String? englishDescription;
  final bool isAvailable;         // useful for "out of stock" feature
  final double? discountPrice;    // optional – for promotions

  Product({
    required this.id,
    required this.categoryId,
    required this.arabicName,
    this.englishName,
    required this.price,
    this.imagePath,
    this.arabicDescription,
    this.englishDescription,
    this.isAvailable = true,
    this.discountPrice,
  });

  // ────────────────────────────────────────────────
  // JSON serialization (required for sembast)
  // ────────────────────────────────────────────────

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'arabicName': arabicName,
      'englishName': englishName,
      'price': price,
      'imagePath': imagePath,
      'arabicDescription': arabicDescription,
      'englishDescription': englishDescription,
      'isAvailable': isAvailable,
      'discountPrice': discountPrice,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] as num).toInt(),
      categoryId: (json['categoryId'] as num).toInt(),
      arabicName: json['arabicName'] as String,
      englishName: json['englishName'] as String?,
      price: (json['price'] as num).toInt(),
      imagePath: json['imagePath'] as String?,
      arabicDescription: json['arabicDescription'] as String?,
      englishDescription: json['englishDescription'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
    );
  }
  // ────────────────────────────────────────────────
  // Helpers
  // ────────────────────────────────────────────────

  Product copyWith({
    int? id,
    int? categoryId,
    String? arabicName,
    String? englishName,
    int? price,
    String? imagePath,
    String? arabicDescription,
    String? englishDescription,
    bool? isAvailable,
    double? discountPrice,
  }) {
    return Product(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      arabicName: arabicName ?? this.arabicName,
      englishName: englishName ?? this.englishName,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      arabicDescription: arabicDescription ?? this.arabicDescription,
      englishDescription: englishDescription ?? this.englishDescription,
      isAvailable: isAvailable ?? this.isAvailable,
      discountPrice: discountPrice ?? this.discountPrice,
    );
  }

  /// Get description based on language code
  String getDescription(String languageCode) {
    if (languageCode == 'ar') {
      return arabicDescription ?? englishDescription ?? '';
    }
    return englishDescription ?? arabicDescription ?? '';
  }

  /// Check if description exists in the specified language
  bool hasDescription(String languageCode) {
    if (languageCode == 'ar') {
      return arabicDescription != null && arabicDescription!.isNotEmpty;
    }
    return englishDescription != null && englishDescription!.isNotEmpty;
  }

  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  // int get displayPrice => hasDiscount ? discountPrice! : price;

  @override
  String toString() {
    return 'Product(id: $id, "$arabicName", ${price.toStringAsFixed(0)} EGP, cat: $categoryId)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Product &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}