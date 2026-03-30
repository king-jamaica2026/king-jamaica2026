// import 'dart:async';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
// import 'package:sembast/sembast.dart';
// import 'package:sembast_web/sembast_web.dart'; // For web support
// import 'package:sembast/sembast_io.dart'; // For mobile/desktop
// import 'package:flutter/foundation.dart' show kIsWeb;
// import '../models/category.dart';
// import '../models/product.dart';
//
// class MenuDatabase {
//   static final MenuDatabase _instance = MenuDatabase._internal();
//   factory MenuDatabase() => _instance;
//   MenuDatabase._internal();
//
//   Database? _db;
//
//   static const String dbFileName = 'menu2.db';
//
//   static final StoreRef<int, Map<String, dynamic>> categoriesStore =
//   intMapStoreFactory.store('categories');
//
//   static final StoreRef<int, Map<String, dynamic>> productsStore =
//   intMapStoreFactory.store('products');
//
//   Future<Database> get database async {
//     if (_db != null) return _db!;
//
//     try {
//       if (kIsWeb) {
//         // Web implementation - uses IndexedDB
//         _db = await databaseFactoryWeb.openDatabase(dbFileName);
//       } else {
//         // Mobile/Desktop implementation
//         final docsDir = await getApplicationDocumentsDirectory();
//         final path = p.join(docsDir.path, dbFileName);
//         _db = await databaseFactoryIo.openDatabase(path);
//       }
//
//       // Create indexes for better query performance
//       // await productsStore.addIndex(_db!, 'by_category', ['categoryId']);
//
//       await _seedDataIfEmpty();
//
//       return _db!;
//     } catch (e) {
//       print('Error opening database: $e');
//       rethrow;
//     }
//   }
//
//   // ────────────────────────────────────────────────
//   // Seed with your real menu data (runs only once)
//   // ────────────────────────────────────────────────
//   Future<void> _seedDataIfEmpty() async {
//     final db = await database;
//
//     final catCount = await categoriesStore.count(db);
//     if (catCount > 0) return; // already has data → skip
//
//     await db.transaction((txn) async {
//       // 1. Categories
//       final categoryList = [
//         Category(
//             id: 1,
//             arabicName: 'الإفطار',
//             englishName: 'Breakfast',
//             imagePath: 'assets/cat/breakfast.png'),
//         Category(
//             id: 2,
//             arabicName: 'طواجن',
//             englishName: 'Tagines',
//             imagePath: 'assets/cat/tagines.png'),
//         Category(
//             id: 3,
//             arabicName: 'مشويات',
//             englishName: 'Grills',
//             imagePath: 'assets/cat/Grills.png'),
//         Category(
//             id: 4,
//             arabicName: 'وجبات مقلية',
//             englishName: 'Fried Meals',
//             imagePath: 'assets/cat/FriedMeals.png'),
//         Category(
//             id: 5,
//             arabicName: 'مكرونة',
//             englishName: 'Pasta',
//             imagePath: 'assets/cat/Pasta.png'),
//         Category(
//             id: 6,
//             arabicName: 'وجبات خاصة',
//             englishName: 'Special Meals',
//             imagePath: 'assets/cat/SpecialMeals.png'),
//         Category(
//             id: 7,
//             arabicName: 'وجبات نباتية',
//             englishName: 'Vegetarian',
//             imagePath: 'assets/cat/Vegetarian.png'),
//         Category(
//             id: 8,
//             arabicName: 'هوت كوفي',
//             englishName: 'Hot Coffee',
//             imagePath: 'assets/cat/hot_drinks.png'),
//         Category(
//             id: 9,
//             arabicName: 'مشروبات ساخنة',
//             englishName: 'Hot Drinks',
//             imagePath: 'assets/cat/hot_drinks.png'),
//         Category(
//             id: 10,
//             arabicName: 'مشروبات غازية',
//             englishName: 'Soft Drinks',
//             imagePath: 'assets/cat/softDrinks.png'),
//         Category(
//             id: 11,
//             arabicName: 'فريشات',
//             englishName: 'Fresh Juices',
//             imagePath: 'assets/cat/juices.png'),
//         Category(
//             id: 12,
//             arabicName: 'ميلك شيك',
//             englishName: 'Milkshakes',
//             imagePath: 'assets/cat/milkshakes.png'),
//         Category(
//             id: 13,
//             arabicName: 'وافل',
//             englishName: 'Waffle-Deserts',
//             imagePath: 'assets/cat/waffle.png'),
//         Category(
//             id: 14,
//             arabicName: 'موخيتو',
//             englishName: 'Mojito',
//             imagePath: 'assets/cat/Shisha.png'),
//         Category(
//             id: 15,
//             arabicName: 'فرابيه',
//             englishName: 'Frappé',
//             imagePath: 'assets/cat/Shisha.png'),
//         Category(
//             id: 16,
//             arabicName: 'زبادي',
//             englishName: 'Yogurt',
//             imagePath: 'assets/cat/Shisha.png'),
//         Category(
//             id: 17,
//             arabicName: 'زبادي',
//             englishName: 'Yogurt',
//             imagePath: 'assets/cat/Shisha.png'),
//
//         Category(
//             id: 18,
//             arabicName: 'ايس كوفي',
//             englishName: 'Ice Coffee',
//             imagePath: 'assets/cat/Shisha.png'),
//
//         Category(
//             id: 19,
//             arabicName: 'الشيشة',
//             englishName: 'Hooka',
//             imagePath: 'assets/cat/Shisha.png'),
//
//         Category(
//             id: 20,
//             arabicName: 'اضافات',
//             englishName: 'Extras',
//             imagePath: 'assets/cat/Extras.png'),
//       ];
//
//       for (final cat in categoryList) {
//         await categoriesStore.record(cat.id).put(txn, cat.toJson());
//       }
//
//       // 2. Products (linked by category id)
//       final productList = [
//         // Breakfast (Category 1)
//         Product(
//           id: 1,
//           categoryId: 1,
//           arabicName: 'الإفطار النوبي التقليدي',
//           englishName: 'Traditional Nubian Breakfast',
//           price: 200,
//           imagePath: 'assets/prod/nb.png',
//           englishDescription: 'A traditional Nubian breakfast featuring fava beans, eggs, cheese, and freshly baked bread served with authentic Nubian spices',
//           arabicDescription: 'وجبة إفطار نوبية تقليدية تحتوي على الفول المدمس، البيض، الجبن، والخبز الطازج مع التوابل النوبية الأصيلة',
//           isAvailable: true,
//         ),
//
//         // Waffle (Category 2)
//         Product(
//           id: 100,
//           categoryId: 2,
//           arabicName: 'ميكس شوكولاتة وافل',
//           englishName: 'Mix Chocolate Waffle',
//           price: 110,
//           imagePath: 'assets/prod/mix_choco_waffle.png',
//           englishDescription: 'Crispy waffle topped with mixed chocolate sauce, fresh strawberries, and whipped cream',
//           arabicDescription: 'وافل مقرمش مغطى بصوص الشوكولاتة المتنوع، فراولة طازجة، وكريمة مخفوقة',
//           isAvailable: true,
//         ),
//         Product(
//           id: 101,
//           categoryId: 2,
//           arabicName: 'لوتس وافل',
//           englishName: 'Lotus Waffle',
//           price: 120,
//           imagePath: 'assets/prod/lotus.png',
//           englishDescription: 'Crispy waffle topped with Lotus biscuit spread, crushed Lotus biscuits, and caramel sauce',
//           arabicDescription: 'وافل مقرمش مغطى بكريمة بسكويت لوتس، قطع بسكويت لوتس، وصلصة الكراميل',
//           isAvailable: true,
//         ),
//
//         // Tagines (Category 3)
//         Product(
//           id: 200,
//           categoryId: 3,
//           arabicName: 'طاجن لحم',
//           englishName: 'Meat Tagine',
//           price: 180,
//           imagePath: 'assets/prod/meat_tagine.png',
//           englishDescription: 'Slow-cooked meat tagine with vegetables and Moroccan spices',
//           arabicDescription: 'طاجن لحم مطهو ببطء مع الخضروات والتوابل المغربية',
//           isAvailable: true,
//         ),
//         Product(
//           id: 201,
//           categoryId: 3,
//           arabicName: 'طاجن دجاج',
//           englishName: 'Chicken Tagine',
//           price: 160,
//           imagePath: 'assets/prod/chicken_tagine.png',
//           englishDescription: 'Tender chicken tagine with olives and preserved lemons',
//           arabicDescription: 'طاجن دجاج طري مع الزيتون والليمون المخلل',
//           isAvailable: true,
//         ),
//
//         // Hot Drinks (Category 4)
//         Product(
//           id: 300,
//           categoryId: 4,
//           arabicName: 'قهوة جبانة نوبية',
//           englishName: 'Nubian Jabana Coffee',
//           price: 60,
//           imagePath: 'assets/prod/jabana_coffee.png',
//           englishDescription: 'Traditional Nubian coffee brewed in a clay pot (jabana) with cardamom and aromatic spices',
//           arabicDescription: 'قهوة نوبية تقليدية يتم تحضيرها في الجبانة الفخارية مع الهيل والتوابل العطرية',
//           isAvailable: true,
//         ),
//         Product(
//           id: 301,
//           categoryId: 4,
//           arabicName: 'كركديه ساخن',
//           englishName: 'Hot Hibiscus',
//           price: 50,
//           imagePath: 'assets/prod/hibiscus.png',
//           englishDescription: 'Refreshing hot hibiscus tea made from dried hibiscus flowers, sweetened to taste',
//           arabicDescription: 'كركديه ساخن منعش مصنوع من أزهار الكركديه المجففة، محلى حسب الرغبة',
//           isAvailable: true,
//         ),
//         Product(
//           id: 302,
//           categoryId: 4,
//           arabicName: 'شاي بالحليب',
//           englishName: 'Tea with Milk',
//           price: 40,
//           englishDescription: 'Hot black tea served with fresh milk',
//           arabicDescription: 'شاي أسود ساخن يقدم مع حليب طازج',
//           isAvailable: true,
//         ),
//         Product(
//           id: 303,
//           categoryId: 4,
//           arabicName: 'قهوة تركية',
//           englishName: 'Turkish Coffee',
//           price: 45,
//           englishDescription: 'Rich Turkish coffee served with a piece of Turkish delight',
//           arabicDescription: 'قهوة تركية غنية تقدم مع قطعة من الراحة الحلقوم',
//           isAvailable: true,
//         ),
//
//         // Fresh Juices (Category 5)
//         Product(
//           id: 400,
//           categoryId: 5,
//           arabicName: 'عصير برتقال',
//           englishName: 'Fresh Orange Juice',
//           price: 45,
//           imagePath: 'assets/prod/orange_juice.png',
//           englishDescription: 'Freshly squeezed orange juice, rich in vitamin C',
//           arabicDescription: 'عصير برتقال طازج غني بفيتامين سي',
//           isAvailable: true,
//         ),
//         Product(
//           id: 401,
//           categoryId: 5,
//           arabicName: 'عصير مانجو',
//           englishName: 'Mango Juice',
//           price: 55,
//           imagePath: 'assets/prod/mango_juice.png',
//           englishDescription: 'Fresh mango juice made from ripe mangoes',
//           arabicDescription: 'عصير مانجو طازج مصنوع من المانجو الناضجة',
//           isAvailable: true,
//         ),
//         Product(
//           id: 402,
//           categoryId: 5,
//           arabicName: 'عصير فراولة',
//           englishName: 'Strawberry Juice',
//           price: 50,
//           imagePath: 'assets/prod/strawberry_juice.png',
//           englishDescription: 'Fresh strawberry juice made from sweet strawberries',
//           arabicDescription: 'عصير فراولة طازج مصنوع من الفراولة الحلوة',
//           isAvailable: true,
//         ),
//
//         // Milkshakes (Category 6)
//         Product(
//           id: 500,
//           categoryId: 6,
//           arabicName: 'ميلك شيك شوكولاتة',
//           englishName: 'Chocolate Milkshake',
//           price: 70,
//           imagePath: 'assets/prod/chocolate_milkshake.png',
//           englishDescription: 'Rich and creamy chocolate milkshake topped with whipped cream',
//           arabicDescription: 'ميلك شيك شوكولاتة غني وكريمي مغطى بالكريمة المخفوقة',
//           isAvailable: true,
//         ),
//         Product(
//           id: 501,
//           categoryId: 6,
//           arabicName: 'ميلك شيك فراولة',
//           englishName: 'Strawberry Milkshake',
//           price: 70,
//           imagePath: 'assets/prod/strawberry_milkshake.png',
//           englishDescription: 'Sweet strawberry milkshake made with fresh strawberries',
//           arabicDescription: 'ميلك شيك فراولة حلو مصنوع من الفراولة الطازجة',
//           isAvailable: true,
//         ),
//       ];
//
//       for (final prod in productList) {
//         await productsStore.record(prod.id).put(txn, prod.toJson());
//       }
//     });
//   }
//
//   // ────────────────────────────────────────────────
//   // Public API
//   // ────────────────────────────────────────────────
//
//   /// Get complete list of categories
//   Future<List<Category>> getAllCategories() async {
//     try {
//       final db = await database;
//       final snapshots = await categoriesStore.find(db);
//       return snapshots.map((s) => Category.fromJson(s.value)).toList()
//         ..sort((a, b) => a.id.compareTo(b.id));
//     } catch (e) {
//       print('Error fetching categories: $e');
//       return [];
//     }
//   }
//
//   /// Get complete list of products (all items)
//   Future<List<Product>> getAllProducts() async {
//     try {
//       final db = await database;
//       final snapshots = await productsStore.find(db);
//       return snapshots.map((s) => Product.fromJson(s.value)).toList();
//     } catch (e) {
//       print('Error fetching all products: $e');
//       return [];
//     }
//   }
//
//   /// Get products for one specific category
//   Future<List<Product>> getProductsOfCategory(int categoryId) async {
//     try {
//       final db = await database;
//       final finder = Finder(filter: Filter.equals('categoryId', categoryId));
//       final snapshots = await productsStore.find(db, finder: finder);
//       return snapshots.map((s) => Product.fromJson(s.value)).toList();
//     } catch (e) {
//       print('Error fetching products for category $categoryId: $e');
//       return [];
//     }
//   }
//
//   /// Get single product by id
//   Future<Product?> getProduct(int id) async {
//     try {
//       final db = await database;
//       final json = await productsStore.record(id).get(db);
//       return json != null ? Product.fromJson(json) : null;
//     } catch (e) {
//       print('Error fetching product $id: $e');
//       return null;
//     }
//   }
//
//   /// Search products by name (Arabic or English)
//   Future<List<Product>> searchProducts(String query) async {
//     if (query.isEmpty) return [];
//
//     try {
//       final allProducts = await getAllProducts();
//       return allProducts.where((product) {
//         final arabicMatch = product.arabicName
//             .toLowerCase()
//             .contains(query.toLowerCase());
//         final englishMatch = product.englishName
//             ?.toLowerCase()
//             .contains(query.toLowerCase()) ?? false;
//         return arabicMatch || englishMatch;
//       }).toList();
//     } catch (e) {
//       print('Error searching products: $e');
//       return [];
//     }
//   }
//
//   /// Get available products (in stock)
//   Future<List<Product>> getAvailableProducts() async {
//     try {
//       final allProducts = await getAllProducts();
//       return allProducts.where((product) => product.isAvailable).toList();
//     } catch (e) {
//       print('Error fetching available products: $e');
//       return [];
//     }
//   }
//
//   /// Add or update a product
//   Future<void> upsertProduct(Product product) async {
//     try {
//       final db = await database;
//       await productsStore.record(product.id).put(db, product.toJson());
//     } catch (e) {
//       print('Error upserting product: $e');
//       rethrow;
//     }
//   }
//
//   /// Delete a product
//   Future<void> deleteProduct(int id) async {
//     try {
//       final db = await database;
//       await productsStore.record(id).delete(db);
//     } catch (e) {
//       print('Error deleting product $id: $e');
//       rethrow;
//     }
//   }
//
//   /// Add or update a category
//   Future<void> upsertCategory(Category category) async {
//     try {
//       final db = await database;
//       await categoriesStore.record(category.id).put(db, category.toJson());
//     } catch (e) {
//       print('Error upserting category: $e');
//       rethrow;
//     }
//   }
//
//   /// Delete a category and its associated products
//   Future<void> deleteCategory(int categoryId) async {
//     try {
//       final db = await database;
//       await db.transaction((txn) async {
//         // Delete products in this category
//         final finder = Finder(filter: Filter.equals('categoryId', categoryId));
//         final products = await productsStore.find(txn, finder: finder);
//         for (final product in products) {
//           await productsStore.record(product.key).delete(txn);
//         }
//         // Delete the category
//         await categoriesStore.record(categoryId).delete(txn);
//       });
//     } catch (e) {
//       print('Error deleting category $categoryId: $e');
//       rethrow;
//     }
//   }
//
//   /// Clear all data (useful for testing or reset)
//   Future<void> clearDatabase() async {
//     try {
//       final db = await database;
//       await db.transaction((txn) async {
//         await categoriesStore.delete(txn);
//         await productsStore.delete(txn);
//       });
//       _db = null; // Force re-seeding next time
//     } catch (e) {
//       print('Error clearing database: $e');
//       rethrow;
//     }
//   }
//
//   /// Get product count
//   Future<int> getProductCount() async {
//     try {
//       final db = await database;
//       return await productsStore.count(db);
//     } catch (e) {
//       print('Error getting product count: $e');
//       return 0;
//     }
//   }
//
//   /// Get category count
//   Future<int> getCategoryCount() async {
//     try {
//       final db = await database;
//       return await categoriesStore.count(db);
//     } catch (e) {
//       print('Error getting category count: $e');
//       return 0;
//     }
//   }
//
//   /// Optional: close when app is killed (rarely needed)
//   Future<void> close() async {
//     await _db?.close();
//     _db = null;
//   }
// }
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';
import '../models/product.dart';

class MenuDatabase {
  static final MenuDatabase _instance = MenuDatabase._internal();
  factory MenuDatabase() => _instance;
  MenuDatabase._internal();

  // Supabase client instance
  final SupabaseClient _supabase = Supabase.instance.client;

  // Table names
  static const String categoriesTable = 'categories';
  static const String productsTable = 'products';

  // ────────────────────────────────────────────────
  // Seed with your real menu data (runs only once)
  // ────────────────────────────────────────────────
  Future<void> _seedDataIfEmpty() async {
    try {
      // Check if categories already exist
      final categoryCount = await _supabase
          .from(categoriesTable)
          .count();

      if (categoryCount > 0) return; // already has data → skip

      // 1. Insert Categories
      final categoryList = [
        Category(
            id: 1,
            arabicName: 'الإفطار',
            englishName: 'Breakfast',
            imagePath: 'assets/cat/breakfast.png'),
        Category(
            id: 2,
            arabicName: 'طواجن',
            englishName: 'Tagines',
            imagePath: 'assets/cat/tagines.png'),
        Category(
            id: 3,
            arabicName: 'مشويات',
            englishName: 'Grills',
            imagePath: 'assets/cat/Grills.png'),
        Category(
            id: 4,
            arabicName: 'وجبات مقلية',
            englishName: 'Fried Meals',
            imagePath: 'assets/cat/FriedMeals.png'),
        Category(
            id: 5,
            arabicName: 'مكرونة',
            englishName: 'Pasta',
            imagePath: 'assets/cat/Pasta.png'),
        Category(
            id: 6,
            arabicName: 'وجبات خاصة',
            englishName: 'Special Meals',
            imagePath: 'assets/cat/SpecialMeals.png'),
        Category(
            id: 7,
            arabicName: 'وجبات نباتية',
            englishName: 'Vegetarian',
            imagePath: 'assets/cat/Vegetarian.png'),
        Category(
            id: 8,
            arabicName: 'هوت كوفي',
            englishName: 'Hot Coffee',
            imagePath: 'assets/cat/hot_drinks.png'),
        Category(
            id: 9,
            arabicName: 'مشروبات ساخنة',
            englishName: 'Hot Drinks',
            imagePath: 'assets/cat/hot_drinks.png'),
        Category(
            id: 10,
            arabicName: 'مشروبات غازية',
            englishName: 'Soft Drinks',
            imagePath: 'assets/cat/softDrinks.png'),
        Category(
            id: 11,
            arabicName: 'فريشات',
            englishName: 'Fresh Juices',
            imagePath: 'assets/cat/juices.png'),
        Category(
            id: 12,
            arabicName: 'ميلك شيك',
            englishName: 'Milkshakes',
            imagePath: 'assets/cat/milkshakes.png'),
        Category(
            id: 13,
            arabicName: 'وافل',
            englishName: 'Waffle-Deserts',
            imagePath: 'assets/cat/waffle.png'),
        Category(
            id: 14,
            arabicName: 'موخيتو',
            englishName: 'Mojito',
            imagePath: 'assets/cat/Shisha.png'),
        Category(
            id: 15,
            arabicName: 'فرابيه',
            englishName: 'Frappé',
            imagePath: 'assets/cat/Shisha.png'),
        Category(
            id: 16,
            arabicName: 'زبادي',
            englishName: 'Yogurt',
            imagePath: 'assets/cat/Shisha.png'),
        Category(
            id: 17,
            arabicName: 'زبادي',
            englishName: 'Yogurt',
            imagePath: 'assets/cat/Shisha.png'),
        Category(
            id: 18,
            arabicName: 'ايس كوفي',
            englishName: 'Ice Coffee',
            imagePath: 'assets/cat/Shisha.png'),
        Category(
            id: 19,
            arabicName: 'الشيشة',
            englishName: 'Hooka',
            imagePath: 'assets/cat/Shisha.png'),
        Category(
            id: 20,
            arabicName: 'اضافات',
            englishName: 'Extras',
            imagePath: 'assets/cat/Extras.png'),
      ];

      // Convert categories to Supabase format and insert
      final categoriesData = categoryList.map((cat) => {
        'id': cat.id,
        'arabic_name': cat.arabicName,
        'english_name': cat.englishName,
        'image_path': cat.imagePath,
      }).toList();

      await _supabase.from(categoriesTable).insert(categoriesData);

      // 2. Insert Products
      final productList = [
        // Breakfast (Category 1)
        Product(
          id: 1,
          categoryId: 1,
          arabicName: 'الإفطار النوبي التقليدي',
          englishName: 'Traditional Nubian Breakfast',
          price: 200,
          imagePath: 'assets/prod/nb.png',
          englishDescription: 'A traditional Nubian breakfast featuring fava beans, eggs, cheese, and freshly baked bread served with authentic Nubian spices',
          arabicDescription: 'وجبة إفطار نوبية تقليدية تحتوي على الفول المدمس، البيض، الجبن، والخبز الطازج مع التوابل النوبية الأصيلة',
          isAvailable: true,
        ),
        // ... (rest of your products)
      ];

      // Convert products to Supabase format and insert
      final productsData = productList.map((prod) => {
        'id': prod.id,
        'category_id': prod.categoryId,
        'arabic_name': prod.arabicName,
        'english_name': prod.englishName,
        'price': prod.price,
        'image_path': prod.imagePath,
        'english_description': prod.englishDescription,
        'arabic_description': prod.arabicDescription,
        'is_available': prod.isAvailable,
      }).toList();

      await _supabase.from(productsTable).insert(productsData);

    } catch (e) {
      print('Error seeding database: $e');
      rethrow;
    }
  }

  // ────────────────────────────────────────────────
  // Public API
  // ────────────────────────────────────────────────

  /// Get complete list of categories
  Future<List<Category>> getAllCategories() async {
    try {
      final response = await _supabase
          .from(categoriesTable)
          .select()
          .order('id');

      return (response as List).map((json) => Category(
        id: json['id'],
        arabicName: json['arabic_name'],
        englishName: json['english_name'],
        imagePath: json['image_path'],
      )).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  /// Get complete list of products (all items)
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _supabase
          .from(productsTable)
          .select();

      return (response as List).map((json) => Product(
        id: json['id'],
        categoryId: json['category_id'],
        arabicName: json['arabic_name'],
        englishName: json['english_name'],
        price: json['price'],
        imagePath: json['image_path'],
        englishDescription: json['english_description'],
        arabicDescription: json['arabic_description'],
        isAvailable: json['is_available'] ?? true,
      )).toList();
    } catch (e) {
      print('Error fetching all products: $e');
      return [];
    }
  }

  /// Get products for one specific category
  Future<List<Product>> getProductsOfCategory(int categoryId) async {
    try {
      final response = await _supabase
          .from(productsTable)
          .select()
          .eq('category_id', categoryId);

      return (response as List).map((json) => Product(
        id: json['id'],
        categoryId: json['category_id'],
        arabicName: json['arabic_name'],
        englishName: json['english_name'],
        price: json['price'],
        imagePath: json['image_path'],
        englishDescription: json['english_description'],
        arabicDescription: json['arabic_description'],
        isAvailable: json['is_available'] ?? true,
      )).toList();
    } catch (e) {
      print('Error fetching products for category $categoryId: $e');
      return [];
    }
  }

  /// Get single product by id
  Future<Product?> getProduct(int id) async {
    try {
      final response = await _supabase
          .from(productsTable)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return Product(
        id: response['id'],
        categoryId: response['category_id'],
        arabicName: response['arabic_name'],
        englishName: response['english_name'],
        price: response['price'],
        imagePath: response['image_path'],
        englishDescription: response['english_description'],
        arabicDescription: response['arabic_description'],
        isAvailable: response['is_available'] ?? true,
      );
    } catch (e) {
      print('Error fetching product $id: $e');
      return null;
    }
  }

  /// Search products by name (Arabic or English)
  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await _supabase
          .from(productsTable)
          .select()
          .or('arabic_name.ilike.%$query%,english_name.ilike.%$query%');

      return (response as List).map((json) => Product(
        id: json['id'],
        categoryId: json['category_id'],
        arabicName: json['arabic_name'],
        englishName: json['english_name'],
        price: json['price'],
        imagePath: json['image_path'],
        englishDescription: json['english_description'],
        arabicDescription: json['arabic_description'],
        isAvailable: json['is_available'] ?? true,
      )).toList();
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  /// Get available products (in stock)
  Future<List<Product>> getAvailableProducts() async {
    try {
      final response = await _supabase
          .from(productsTable)
          .select()
          .eq('is_available', true);

      return (response as List).map((json) => Product(
        id: json['id'],
        categoryId: json['category_id'],
        arabicName: json['arabic_name'],
        englishName: json['english_name'],
        price: json['price'],
        imagePath: json['image_path'],
        englishDescription: json['english_description'],
        arabicDescription: json['arabic_description'],
        isAvailable: json['is_available'] ?? true,
      )).toList();
    } catch (e) {
      print('Error fetching available products: $e');
      return [];
    }
  }

  /// Add or update a product
  Future<void> upsertProduct(Product product) async {
    try {
      await _supabase.from(productsTable).upsert({
        'id': product.id,
        'category_id': product.categoryId,
        'arabic_name': product.arabicName,
        'english_name': product.englishName,
        'price': product.price,
        'image_path': product.imagePath,
        'english_description': product.englishDescription,
        'arabic_description': product.arabicDescription,
        'is_available': product.isAvailable,
      });
    } catch (e) {
      print('Error upserting product: $e');
      rethrow;
    }
  }

  /// Delete a product
  Future<void> deleteProduct(int id) async {
    try {
      await _supabase
          .from(productsTable)
          .delete()
          .eq('id', id);
    } catch (e) {
      print('Error deleting product $id: $e');
      rethrow;
    }
  }

  /// Add or update a category
  Future<void> upsertCategory(Category category) async {
    try {
      await _supabase.from(categoriesTable).upsert({
        'id': category.id,
        'arabic_name': category.arabicName,
        'english_name': category.englishName,
        'image_path': category.imagePath,
      });
    } catch (e) {
      print('Error upserting category: $e');
      rethrow;
    }
  }

  /// Delete a category and its associated products
  Future<void> deleteCategory(int categoryId) async {
    try {
      // Products will be automatically deleted due to ON DELETE CASCADE
      await _supabase
          .from(categoriesTable)
          .delete()
          .eq('id', categoryId);
    } catch (e) {
      print('Error deleting category $categoryId: $e');
      rethrow;
    }
  }

  /// Clear all data (useful for testing or reset)
  Future<void> clearDatabase() async {
    try {
      // Delete all products first (or use cascade)
      await _supabase.from(productsTable).delete().neq('id', 0);
      // Delete all categories
      await _supabase.from(categoriesTable).delete().neq('id', 0);
    } catch (e) {
      print('Error clearing database: $e');
      rethrow;
    }
  }

  /// Get product count
  Future<int> getProductCount() async {
    try {
      final count = await _supabase
          .from(productsTable)
          .count();
      return count;
    } catch (e) {
      print('Error getting product count: $e');
      return 0;
    }
  }

  /// Get category count
  Future<int> getCategoryCount() async {
    try {
      final count = await _supabase
          .from(categoriesTable)
          .count();
      return count;
    } catch (e) {
      print('Error getting category count: $e');
      return 0;
    }
  }

  // /// Initialize database and seed if empty
  // Future<void> initialize() async {
  //   await _seedDataIfEmpty();
  // }

  /// No close needed for Supabase
  Future<void> close() async {
    // Supabase client manages connection pooling
    // No explicit close needed
  }
}


