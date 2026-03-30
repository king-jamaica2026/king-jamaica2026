// import 'package:hive/hive.dart';
//
// part 'category.g.dart';
//
// @HiveType(typeId: 0)
// class Category {
//   @HiveField(0)
//   final int id;
//   @HiveField(1)
//   final String arabicName;
//   @HiveField(2)
//   final String englishName;
//   @HiveField(3)
//   final String imagePath; // e.g. "assets/categories/coffee.jpg"
//
//   Category({
//     required this.id,
//     required this.arabicName,
//     required this.englishName,
//     required this.imagePath,
//   });
// }
// lib/models/category.dart
class Category {
  final int id;
  final String arabicName;
  final String englishName;
  final String? imagePath;     // can be null if no image
  final String? description;   // optional

  Category({
    required this.id,
    required this.arabicName,
    required this.englishName,
    this.imagePath,
    this.description,
  });

  // ────────────────────────────────────────────────
  // JSON serialization (required for sembast)
  // ────────────────────────────────────────────────

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabicName': arabicName,
      'englishName': englishName,
      'imagePath': imagePath,
      'description': description,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      arabicName: json['arabicName'] as String,
      englishName: json['englishName'] as String,
      imagePath: json['imagePath'] as String?,
      description: json['description'] as String?,
    );
  }

  // ────────────────────────────────────────────────
  // Useful helpers
  // ────────────────────────────────────────────────

  Category copyWith({
    int? id,
    String? arabicName,
    String? englishName,
    String? imagePath,
    String? description,
  }) {
    return Category(
      id: id ?? this.id,
      arabicName: arabicName ?? this.arabicName,
      englishName: englishName ?? this.englishName,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, arabic: "$arabicName", english: "$englishName")';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Category &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}